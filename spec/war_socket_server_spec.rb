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
      if @socket
        break
      end
    end
  end

  def provide_input(text)
    @socket.puts(text)
  end

  def capture_output(delay=0.1)
    sleep(delay)
    @output = @socket.read_nonblock(1000) # not gets which blocks
  rescue IO::WaitReadable
    @output = ""
  end

  def close
    @socket.close if @socket
  end
end

describe WarSocketServer do
  before(:each) do
    @clients = []
    @server = WarSocketServer.new
  end

  after(:each) do
    @server.stop
    @clients.each do |client|
      client.close
    end
  end

  it "is not listening on a port before it is started"  do
    expect {MockWarSocketClient.new(@server.port_number)}.to raise_error(Errno::ECONNREFUSED)
  end

  it "accepts new clients and starts a game if possible" do
    @server.start
    client1 = MockWarSocketClient.new(@server.port_number)
    @clients.push(client1)
    @server.accept_new_client("Player 1")
    @server.create_game_if_possible
    expect(@server.game).to be nil
    client2 = MockWarSocketClient.new(@server.port_number)
    @clients.push(client2)
    @server.accept_new_client("Player 2")
    @server.create_game_if_possible
    expect(@server.game).to_not be nil
  end

  it 'runs the game if it has been created' do
    @server.start
    client1 = MockWarSocketClient.new(@server.port_number)
    @clients.push(client1)
    @server.accept_new_client('Player 1')
    client2 = MockWarSocketClient.new(@server.port_number)
    @clients.push(client2)
    @server.accept_new_client('Player 2')
    @server.run_game
    expect(client1.capture_output || client2.capture_output).to_not match /Game Started!/
    @server.create_game_if_possible
    @server.run_game
    expect(client1.capture_output && client2.capture_output).to match /Game Started!/
  end

  # Add more tests to make sure the game is being played
  # For example:
  #   make sure the mock client gets appropriate output
  #   make sure the next round isn't played until both clients say they are ready to play
  #   ...

  it 'sends a message to be received by the client when client is connected' do
    @server.start
    client = MockWarSocketClient.new(@server.port_number)
    @clients.push(client)
    @server.accept_new_client('Player 1')
    expect(client.capture_output.strip).to eq 'Player 1 connected!'
  end

  it 'sends a message to be received by the client when game has started' do
    @server.start
    client1 = MockWarSocketClient.new(@server.port_number)
    @clients.push(client1)
    @server.accept_new_client('Player 1')
    client2 = MockWarSocketClient.new(@server.port_number)
    @clients.push(client2)
    @server.accept_new_client('Player 2')
    @server.create_game_if_possible
    @server.run_game
    expect(client1.capture_output && client2.capture_output).to match /Game Started!/
  end

  it 'sends a message to be received by the client to ask if players are ready' do
    @server.start
    client1 = MockWarSocketClient.new(@server.port_number)
    @clients.push(client1)
    @server.accept_new_client('Player 1')
    client2 = MockWarSocketClient.new(@server.port_number)
    @clients.push(client2)
    @server.accept_new_client('Player 2')
    @server.create_game_if_possible
    expect(client1.capture_output && client2.capture_output).to match /Ready?/
  end

  it 'sends a message to be received by the client to inform player how many cards that they have left' do
    @server.start
    client1 = MockWarSocketClient.new(@server.port_number)
    @clients.push(client1)
    @server.accept_new_client('Player 1')
    client2 = MockWarSocketClient.new(@server.port_number)
    @clients.push(client2)
    @server.accept_new_client('Player 2')
    @server.create_game_if_possible
    @server.run_game
    client1_output, client2_output = client1.capture_output, client2.capture_output
    expect(client1_output && client2_output).to match /You have 26 cards left/
    expect(client1_output && client2_output).to include('Player', 'took', 'of', 'with')
  end
end
