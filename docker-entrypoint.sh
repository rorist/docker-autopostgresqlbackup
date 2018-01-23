#!/bin/sh

# Execute cron with parameters
exec cron -f -l ${LOG_LEVEL:-8}
