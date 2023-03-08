# notional logic:
# wait for ptplace to terminate as long as:
#   the drain endpoint returns a 2XX within 10 seconds AND
#   the drain response contains the word "DRAINING"
# return 0 if we terminated due to a 2xx resonse that DIDNT include draining
# otherwise, return 1 ( we timed out waiting to drain )

while [ 1 ]
do
    debug_msg "Checking ${DRAIN_URL}, timeout=${DRAIN_URL_TIMEOUT_SECS}s"
    echo "" > $RESULT_FILENAME
    curl -s -f --retry 2  --max-time $DRAIN_URL_TIMEOUT_SECS -o $RESULT_FILENAME --no-buffer "${DRAIN_URL}"

    STATUS_RESULT=$?
    debug_msg "curl result code: $STATUS_RESULT"

    if [ $STATUS_RESULT -ne 0 ]; then
      info_msg "Drain returned non 2xx. Terminating"
      exit 1
    fi

    info_msg "Received Result::"
    cat $RESULT_FILENAME

    grep -i -c $STILL_DRAINING $RESULT_FILENAME
    if [ $? -ne  0 ]; then
        info_msg "Draining Complete. Terminating."
        exit 0
    else
        debug_msg "Still Draining. Waiting $DRAIN_URL_INTERVAL_SECS seconds.."
        sleep $DRAIN_URL_INTERVAL_SECS
    fi

done

