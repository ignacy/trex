# Trex

An Elixir key-value store based on Mnesia, perfect as an i18n backend
for Rails applications.

## Tests

Run all tests with:

    ./bin/all_tests.sh

## Usage

To compile and start Trex instance:

```sh
mix compile
echo Y | mix release
./rel/trex/bin/trex start
```

### Using Trex as a key-value store

By default Trex handles TCP connections on port 4040. The protocol
expects each message to be ended by `\r\n`. Accepted message types
with examples:

```
> PING\r\n
PONG\r

> SET\tFOO\tBAR\r\n
OK\r

> GET\FOO
BAR\r

> GET\tBAR
\r

> LIST\r\n
FOO\r
```

### Using Trex as an i18n backend

You can find client gem with all the details here [trexrb](https://github.com/ignacy/trexrb)

### Accessing Trex data using TrexCli

Under *trex_cli* directory, you can find a CLI client that connects to
a running Trex instance and allows you to interact with it.

## License

This code is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
