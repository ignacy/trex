require 'minitest/autorun'
require 'net/telnet'

describe 'trex' do
  let(:telnet) { Net::Telnet::new("Host" => "127.0.0.1", "Port" => 6379) }

  it 'ping-pongs' do
    send_command("PING").must_equal "+PONG\n"
  end

  def send_command(cmd)
    telnet.cmd("String" => cmd, "Match" => /\n/)
  end
end
