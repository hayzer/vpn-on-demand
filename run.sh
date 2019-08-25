#!/bin/bash

ENDPOINT_PORT=52180

function install_wg () {
    if ! $(which wg); then
       echo "First install wireguard"
       exit 2
    fi
}


function prepare_wg_keys () {
    wg genkey > ./server_privatekey
    wg genkey > ./client_privatekey
    wg pubkey < ./server_privatekey > ./server_pubkey
    wg pubkey < ./client_privatekey > ./client_pubkey
}

function prepare_client () {
    sed '{
s|%%CLIENT_PRIVATEKEY%%|'$(cat ./client_privatekey)'|
s|%%ENDPOINT_ADDRESS%%|'$(terraform output -json vpn_ip_addr|jq -r .[0])'|
s|%%ENDPOINT_PORT%%|'${ENDPOINT_PORT}'|
s|%%SERVER_PUBLICKEY%%|'$(cat ./server_pubkey)'|
}' client/wg0.conf.tpl > client/wg0.conf
    sudo wg-quick up client/wg0.conf
}

function prepare_server_conf () {
    sed '{
s|%%ENDPOINT_PORT%%|'${ENDPOINT_PORT}'|
s|%%SERVER_PRIVATEKEY%%|'$(cat ./server_privatekey)'|
s|%%CLIENT_PUBLICKEY%%|'$(cat ./client_pubkey)'|
}' server/wg0.conf.tpl > server/wg0.conf
}

function choose_location () {
    locations=(nbg1 hel1 fsn1)
    location=${locations[$RANDOM % ${#locations[@]}]}
    echo ${location}
}

function current_location () {
    location=$(terraform state show hcloud_server.vpn|awk -F= '/location/{print $2}')
    echo ${location}
}

function run_terraform () {
    export TF_VAR_location="$(choose_location)"
    terraform init     && \
    terraform validate && \
    terraform plan     && \
    terraform apply --auto-approve
}

function remove_vpn () {
    sudo wg-quick down client/wg0.conf
    rm -f ./server_privatekey \
          ./client_privatekey \
          ./server_pubkey \
          ./client_pubkey \
          server/wg0.conf \
          client/wg0.conf
    export TF_VAR_location=$(current_location)
    terraform destroy --auto-approve
}

function current_region () {
    echo "$(curl -s ipinfo.io/region)"
}

function is_vpn_running () {
    region=${1}

    echo "Check if server is up & running.."
    if test -z "$(terraform state list)"; then
        echo "Server is not deploy yet"
        return 1
    fi
    if ! ping -c 2 -q $(terraform output -json vpn_ip_addr|jq -r .[0]) 1>/dev/null; then
        echo "Server is not responding"
        return 1
    fi
    echo "Server is running"
    for just_a_sec in $(seq 3); do
        if test "$(curl -s ipinfo.io/region)" == "${region}"; then
            echo "Shit, we're still in ${region}"
            sleep 2
        else
            break
        fi
    done
    if test $just_a_sec -eq 3; then
        return 1
    fi
    echo "VPN is ready"
    return 0
}

function main () {
    arg=$1
    case "${arg}" in
        start)
            region=$(current_region)
            echo "Start VPN.."
            install_wg || (echo "Failed to install wg on local" && exit 1)
            prepare_wg_keys || (echo "Failed to generate the keys" && exit 1)
            prepare_server_conf || (echo "Failed to prepare server configuration" && exit 1)
            run_terraform || (echo "Failed to deploy the server" && exit 1)
            prepare_client || (echo "Failed to configure the client" && exit 1)
            is_vpn_running "${region}" || (echo "VPN is not running :-(" && exit 1)
            exit 0
            ;;
        stop )
            echo "Remove VPN.."
            remove_vpn || (echo "Failed to remove the VPN" && exit 1)
            exit 0
            ;;
        *    )
            echo "$0 [start|stop]"
            echo
            exit 7
            ;;
    esac
}

main $1
