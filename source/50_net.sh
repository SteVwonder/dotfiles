# Add a port forward to an existing SSH ControlMaster connection.
# Usage: sshfwd <host> <port> [remote_port]
#   sshfwd dev-sjc 1313         # forward localhost:1313 -> remote:1313
#   sshfwd dev-sjc 9999 1313    # forward localhost:9999 -> remote:1313
#   sshfwd -R dev-sjc 1313      # reverse: remote:1313 -> local:1313
sshfwd() {
  local direction="-L"
  if [[ "$1" == "-R" ]]; then
    direction="-R"
    shift
  fi
  local host="$1"
  local local_port="$2"
  local remote_port="${3:-$local_port}"
  if [[ -z "$host" || -z "$local_port" ]]; then
    echo "Usage: sshfwd [-R] <host> <local_port> [remote_port]"
    return 1
  fi
  ssh -O forward "$direction" "${local_port}:localhost:${remote_port}" "$host" \
    && echo "Forwarded ${direction#-} ${local_port} <-> ${host}:${remote_port}"
}

# IP addresses
alias wanip="dig +short myip.opendns.com @resolver1.opendns.com"

# Flush Directory Service cache
alias flush="dscacheutil -flushcache"
