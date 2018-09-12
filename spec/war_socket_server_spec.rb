require 'socket'
require_relative '../lib/war_socket_server'
require 'pry'

class MockWarSocketClient
  attr_reader :socket
  attr_reader :output

  def initialize(port)
    @socket = TCPSocket.new('localhost', port)
    loop do
      sleep(0.1)
      break if @socket
    end
  end

  def provide_input(text)
    @socket.puts(text)
  end

  def capture_output(delay = 0.1)
    sleep(delay)
    @output = @socket.read_nonblock(1000) # not gets which blocks
  rescue IO::WaitReadable
    @output = ''
  end

  def close
    @socket.close if @socket
  end
end

describe WarSocketServer do
  def setup_clients(server, clients)
    @client1 = MockWarSocketClient.new(server.port_number)
    server.accept_new_client
    clients.push(@client1)
  end

  let(:clients) { [] }
  let(:server) { WarSocketServer.new }

  before(:each) do
    server.start
    setup_clients(server, clients)
  end

  after(:each) do
    server.stop
    clients.each(&:close)
  end

  it 'accepts new clients and starts a game if possible' do
    server.create_game_if_possible
    expect(server.games.length).to eq 0
    client2 = MockWarSocketClient.new(server.port_number)
    server.accept_new_client
    clients.push(client2)
    server.create_game_if_possible
    expect(server.games.length).to eq 1
  end

  it 'sends a message to be received by the client when client is connected' do
    expect(@client1.capture_output).to match(/You are connected!/)
  end

  it 'sends a message to client if no other player has joined yet' do
    expect(@client1.capture_output).to match(/Waiting for another player/)
    client2 = MockWarSocketClient.new(server.port_number)
    server.accept_new_client
    clients.push(client2)
    expect(client2.capture_output).to match(/Prepare to go to war!/)
  end
end
