# Trex

An Elixir key-value store based on Mnesia, perfect as an i18n backend
for Rails applications.

## Tests

Run all tests with:

    ./bin/all_tests.sh

## Usage

To compile and start Trex instance:

```sh
./bin/run.sh
```

### Using Trex as a key-value store

By default Trex handles TCP connections on port 4040. The protocol is based on [RESP](http://redis.io/topics/protocol)
expects each message to be ended by `\r\n`. Accepted message types with examples:

```
> PING\r\n
+PONG\r

> SET\tFOO\tBAR\r\n
+OK\r

> GET\FOO
+BAR\r

> GET\tBAR
+\r

> LIST\r\n
+FOO\r
```

### Using Trex as an i18n backend

You can find client gem with all the details here [trexrb](https://github.com/ignacy/trexrb)

### Accessing Trex data using TrexCli

Under *trex_cli* directory, you can find a CLI client that connects to
a running Trex instance and allows you to interact with it.

## Benchmarking

Trex can be benchmarked using `redis-benchmark`, here's an example:

```shell
redis-benchmark -p 4040 -t ping,set,get
====== PING_INLINE ======
  100000 requests completed in 0.96 seconds
  50 parallel clients
  3 bytes payload
  keep alive: 1

99.85% <= 1 milliseconds
99.96% <= 2 milliseconds
99.97% <= 3 milliseconds
100.00% <= 3 milliseconds
103950.10 requests per second

====== PING_BULK ======
  100000 requests completed in 0.95 seconds
  50 parallel clients
  3 bytes payload
  keep alive: 1

99.88% <= 1 milliseconds
99.96% <= 2 milliseconds
99.96% <= 3 milliseconds
100.00% <= 3 milliseconds
104931.80 requests per second

====== SET ======
  100000 requests completed in 0.99 seconds
  50 parallel clients
  3 bytes payload
  keep alive: 1

99.88% <= 1 milliseconds
99.91% <= 2 milliseconds
99.96% <= 3 milliseconds
100.00% <= 5 milliseconds
100806.45 requests per second

====== GET ======
  100000 requests completed in 0.93 seconds
  50 parallel clients
  3 bytes payload
  keep alive: 1

99.90% <= 1 milliseconds
99.93% <= 2 milliseconds
99.93% <= 3 milliseconds
100.00% <= 3 milliseconds
108108.11 requests per second
```


## License

This code is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
