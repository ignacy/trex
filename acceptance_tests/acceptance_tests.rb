require 'minitest/autorun'
require 'net/telnet'

describe 'trex' do
  let(:telnet) { Net::Telnet::new("Port" => 4040) }

  it 'ping-pongs' do
    send_command("PING").must_equal "PONG\n"
  end

  it 'sets and gets key' do
    {"key" => "value", "key1" => "value1"}.each do |k,v|
      send_command("SET #{k} #{v}").must_equal "OK\n"
      send_command("GET #{k}").must_equal "#{v}\n"
    end
  end

  it 'updates previously set key' do
    send_command("SET KEY VALUE").must_equal "OK\n"
    send_command("SET KEY OTHER_VALUE").must_equal "OK\n"
    send_command("GET KEY").must_equal "OTHER_VALUE\n"
  end

  def send_command(cmd)
    telnet.cmd("String" => cmd, "Match" => /\n/)
  end
end
