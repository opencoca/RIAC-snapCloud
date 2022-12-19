#!/bin/bash
source .env
if [[ $1 != "--no-tor" ]]; then
    wget https://check.torproject.org/torbulkexitlist -O lib/torbulkexitlist
fi

service postgresql start &

lapis server $LAPIS_ENVIRONMENT --trace &

sleep infinity

wait -n

# Exit with status of process that exited first
exit $?
