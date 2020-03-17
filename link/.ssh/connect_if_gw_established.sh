#!/bin/bash

USAGE="$0 remote_host [-p|--port=22]"

if [[ -z "$1" ]]; then
    echo $USAGE
    exit 1
fi

REMOTE_HOST=$1
IGW_HOST="izgw"
EGW_HOST="czgw"
shift

PORT=22
# Use -gt 1 to consume two arguments per pass in the loop (e.g. each
# argument has a corresponding value to go with it).
# Use -gt 0 to consume one or more arguments per pass in the loop (e.g.
# some arguments don't have a corresponding value to go with it such
# as in the --default example).
# note: if this is set to -gt 0 the /etc/hosts part is not recognized ( may be a bug )
while [[ $# -gt 0 ]]
do
    key="$1"

    case $key in
        -p|--port)
            PORT="$2"
            shift # past argument
            ;;
        -h|--help)
            echo $USAGE
            exit 0
            ;;
        *)
            # unknown option
            echo "Unkown option: $1"
            ;;
    esac
    shift # past argument or value
done

establish_gw_connection() {
    CONTROL_PATH="$1"
    GW_HOST="$2"
    echo "Connecting to $GW_HOST" >&2
    ssh -qfNMS $CONTROL_PATH -E $CONTROL_PATH.debug $GW_HOST
}

connect_to_remote_host() {
    CONTROL_PATH="$1"
    GW_HOST="$2"
    echo "Connecting to $REMOTE_HOST(:$PORT) through existing connection to $GW_HOST" >&2
    exec ssh -S $CONTROL_PATH $GW_HOST nc $REMOTE_HOST $PORT
}

connect_through_gw() {
    GW_HOST="$1"
    CONTROL_PATH=$(ssh -TG $GW_HOST | grep -o 'controlpath .*' | awk '{print $2}')
    if [[ ! -e $CONTROL_PATH ]]; then
        establish_gw_connection $CONTROL_PATH $GW_HOST
    fi
    connect_to_remote_host $CONTROL_PATH $GW_HOST
}

determine_gw() {
   if nc -w 3 -z "$IGW_HOST" 22 &> /dev/null; then
        echo "$IGW_HOST"
    else
        echo "$EGW_HOST"
    fi
}

GW_HOST=$(determine_gw)
connect_through_gw $GW_HOST
