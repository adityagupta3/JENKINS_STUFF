#!/bin/bash

## Provides a nicer syntax for running 'one-off' jboss-cli commands
function jboss_cli() { ${JBOSS_HOME}/bin/jboss-cli.sh -c --command="${@}"; }

# Pull-out the current server status
current_state="$(jboss_cli 'read-attribute server-state')"

# Succeed if the status is 'running'
if [[ "${current_state}" = 'running' ]]; then
        echo 'running'
        exit 0
fi

# "Succeed" if the status contains a timeout (starting)
if $(echo "${current_state}" | grep -q 'waiting for the system to boot'); then
        echo 'starting'
        exit 0
fi


if

fi

# Fail otherwise.
echo >&2 "${current_state}"
exit 1