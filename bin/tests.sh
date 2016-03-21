#!/bin/bash

cleanup() {
  kill -9 $(cat ./tmp/trex.pid)
  rm ./tmp/trex.pid
  rm trex_acceptance.dat
}

trap cleanup EXIT

assert_eql() {
  msg=$1; shift
  expected=$1; shift
  actual=$1; shift;
  if [ "$actual" = "$expected" ]; then
    echo "PASSED ${msg}"
  else
   echo "FAILED ${msg}"
   echo "  EXPECTED ${expected}"
   echo "  BUT GOT  ${actual}"
  fi
}

cmd() {
  printf "$1\r\n" | nc 127.0.0.1 4040
}

touch trex_acceptance.dat
TREX_STORAGE_FILE=trex_acceptance.dat nohup mix run --no-halt > /dev/null 2>&1 & echo $! > ./tmp/trex.pid

until nc -z 127.0.0.1 4040; do
  sleep 0.1
done

assert_eql "ping-pong" $(echo -e "PONG\r") $(cmd "PING")
assert_eql "sets key" $(echo -e "OK\r") $(cmd "SET\tKEY\tVALUE")
assert_eql "gets existing key" $(echo -e "VALUE\r") $(cmd "GET\tKEY")
assert_eql "gets not existing key" $(echo -e "\r") $(cmd "GET\tNOT_EXISTING_KEY")
assert_eql "list keys" $(echo -e "KEY\r") $(cmd "LIST")
assert_eql "wrong SET message format (missing key)" $(echo -e "UNKNOWN_COMMAND\r") $(cmd "SET\tSOMETHING")
