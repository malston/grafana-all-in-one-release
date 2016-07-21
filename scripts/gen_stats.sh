#!/bin/bash

declare -a COUNTERS=(
"foo"
"foobitty"
"fobbittyfoo"
)

function get_counter {
	number=$RANDOM
  let "number %= ${#COUNTERS[@]}"
	echo ${COUNTERS[$number]}
}

function get_metric {
	metric=$RANDOM
	let "metric %= 100"
	echo $metric
}


while [ 1 -eq 1 ];do

  for i in {1..100};do
	  mycounter=$(get_counter)
	  mymetric=$(get_metric)
          echo "$mycounter:$mymetric|c" | nc -u -w0 $1 $2
  done

  echo "batch sent to statsd..."
  sleep 1

done
