#!/bin/sh

# Logic for Password file required
#  If PASSWORD_SECRET env var is defined, search for the /run/secrets/${PASSWORD_SECRET} and read the content
#  If PASSWORD_SECRET is not defined, use PASSWORD env variable
# The idea, as specified in the software:
#   create a file $HOME/.pgpass containing a line like this 
#           hostname:*:*:dbuser:dbpass
# replace hostname with the value of DBHOST and postgres with
# the value of USERNAME

PASSPHRASE=""
if [ "${PASSWORD_SECRET}" ]; then
    if [ -f "/run/secrets/${PASSWORD_SECRET}" ]; then
        PASSPHRASE=$(cat /run/secrets/${PASSWORD_SECRET})
    else
        echo "ERROR: Secret file not found in /run/secrets/${PASSWORD_SECRET}"
        echo "Please verify your docker secrets configuration."
        exit 1
    fi
else
    PASSPHRASE=${PASSWORD}
fi

# Create the file
cat <<-EOF > ${HOME}/.pgpass
${DBHOST}:*:*:${USERNAME:-postgres}:${PASSPHRASE}
EOF

# Execute cron with parameters (autopostgresql script is under /etc/cron.daily)
exec cron -f -l ${LOG_LEVEL:-8}
