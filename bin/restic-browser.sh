#!/bin/bash

printenv | grep RESTIC

source <(sudo bash <<EOF
diff <(printenv) <(source /etc/restic/default.env.sh && printenv) \
     | awk -F'=' '{if (\$1 ~ />/) {print "export " \$1 "=" \$2}}' \
     | sed 's/^export >/export/'
EOF
   )

if [[ -z "$RESTIC_PASSWORD" ]]; then
    if [[ ! -z "$RESTIC_PASSWORD_FILE" ]]; then
        export RESTIC_PASSWORD="$(sudo cat $RESTIC_PASSWORD_FILE)"
        unset RESTIC_PASSWORD_FILE
    else
        echo "No restic password set" >&2
        exit 1
    fi
fi

#printenv | grep -i restic
#printenv | grep B2
restic-browser

