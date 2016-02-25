require 'i18n'
require 'socket'

module Trex
  class Store
    DEFAULT_HOST = 'localhost'
    DEFAULT_PORT = 4040

    def initialize(host = nil, port = nil)
      @host = host || DEFAULT_HOST
      @port = port || DEFAULT_PORT
    end

    def get(key)
      with_connection { |conn| conn.print Request.new.get(key) }
    end

    def set(key, value)
      with_connection { |conn| conn.print Request.new.set(key, value) }
    end

    def keys
      with_connection { |conn| conn.print Request.new.list }
    end

    alias_method :[], :get
    alias_method :[]=, :set

    private

    attr_reader :host, :port

    def with_connection
      socket = Socket.tcp(host, port)
      yield socket
    rescue => ex
      puts "Connection error: #{ex.inspect}"
    ensure
      socket.close_write
      return Response.new(socket.read).body
    end

    Response = Struct.new(:data) do
      def body
        return "{}" if no_data?
        YAML.load(cleaned_data)
      rescue => ex
        puts ex.inspect
        cleaned_data
      end

      private

      def no_data?
        data.to_s.strip.length == 0
      end

      def cleaned_data
        data.rstrip
      end
    end

    Request = Class.new do
      FIELD_SEPARATOR = "\t"
      TERMINATOR = "\r\n"

      def get(key)
        build("GET", key)
      end

      def set(key, value)
        build("SET", key, YAML.dump(value))
      end

      def list
        build("LIST")
      end

      private

      def build(command_name, *params)
        ([command_name] + params).join(FIELD_SEPARATOR) + TERMINATOR
      end
    end
  end

  def self.store
    @store ||= Store.new
  end

  class Backend < I18n::Backend::KeyValue
    include I18n::Backend::Memoize

    def initialize
      super(Trex.store)
    end
  end
end

I18n.backend = Trex::Backend.new
I18n.available_locales = :en
I18n.backend.store_translations :en, :foo => { :bar => :baz }

puts "Keys #{Trex.store.keys.inspect}"
puts I18n.t "foo" #=> { :bar => :baz }
