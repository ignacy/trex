#!/bin/bash

function assert_eql() {
  msg=$1; shift
  expected=$1; shift
  actual=$1; shift;
  if [ "$actual" = "$expected" ]; then
    echo PASSED
  else
    echo "FAILED: EXPECTED=$expected ACTUAL=$actual"
  fi
}

function cmd() {
  printf "$1\r\n" | nc 127.0.0.1 4040
}

nohup mix run --no-halt > /dev/null 2>&1 & echo $! > ./tmp/trex.pid

until nc -z 127.0.0.1 4040; do
  sleep 0.1
done

assert_eql "ping-pong" $(echo -e "PONG\r") $(cmd "PING")
assert_eql "sets key" $(echo -e "OK\r") $(cmd "SET KEY VALUE")
assert_eql "gets existing key" $(echo -e "VALUE\r") $(cmd "GET KEY")
assert_eql "gets not existing key" $(echo -e "\r") $(cmd "GET NOT_EXISTING_KEY")
assert_eql "list keys" $(echo -e "KEY\r") $(cmd "LIST")

kill -9 $(cat ./tmp/trex.pid)
rm ./tmp/trex.pid
