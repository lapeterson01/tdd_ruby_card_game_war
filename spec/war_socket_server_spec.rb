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
    @server.accept_new_client
    @server.create_game_if_possible
    expect(@server.games.length).to eq 0
    client2 = MockWarSocketClient.new(@server.port_number)
    @clients.push(client2)
    @server.accept_new_client
    @server.create_game_if_possible
    expect(@server.games.length).to eq 1
  end

  it 'runs the game if it has been created' do
    @server.start
    client1 = MockWarSocketClient.new(@server.port_number)
    @clients.push(client1)
    @server.accept_new_client
    client2 = MockWarSocketClient.new(@server.port_number)
    @clients.push(client2)
    @server.accept_new_client
    expect(@server.run_game(nil)).to_not be_instance_of WarSocketGameRunner
    game = @server.create_game_if_possible
    expect(@server.run_game(game)).to be_instance_of WarSocketGameRunner
  end

  it 'sends a message to be received by the client when client is connected' do
    @server.start
    client = MockWarSocketClient.new(@server.port_number)
    @clients.push(client)
    @server.accept_new_client
    expect(client.capture_output).to match /You are connected!/
  end

  it 'sends a message to client if no other player has joined yet and a message to both clients when second client joins' do
    @server.start
    client1 = MockWarSocketClient.new(@server.port_number)
    @server.accept_new_client
    expect(client1.capture_output).to match /Waiting for another player/
    client2 = MockWarSocketClient.new(@server.port_number)
    @server.accept_new_client
    @clients << client1 << client2
    expect(client1.capture_output && client2.capture_output).to match /Prepare to go to war!/
  end

  # it 'handles multiple games at once' do
  #   @server.start
  #   client1 = MockWarSocketClient.new(@server.port_number)
  #   @server.accept_new_client
  #   client2 = MockWarSocketClient.new(@server.port_number)
  #   @server.accept_new_client
  #   client3 = MockWarSocketClient.new(@server.port_number)
  #   @server.accept_new_client
  #   client4 = MockWarSocketClient.new(@server.port_number)
  #   @server.accept_new_client
  #   @clients << client1 << client2 << client3 << client4
  #   game1 = @server.create_game_if_possible
  #   game_runner1 = @server.run_game(game1)
  #   expect(game_runner1).to be_instance_of WarSocketGameRunner
  #   game2 = @server.create_game_if_possible
  #   game_runner2 = @server.run_game(game2)
  #   expect(game_runner2).to be_instance_of WarSocketGameRunner
  #   card1, card2 = PlayingCard.new('A', 'Spades'), PlayingCard.new('2', 'Hearts')
  #   game1.player1.retrieve_card(card1)
  #   game1.player2.retrieve_card(card2)
  #   game_runner1.play_round
  #   expect(client1.capture_output).to match /You took 2 of Hearts with A of Spades/
  #   expect(client2.capture_output).to match /Player 1 took 2 of Hearts with A of Spades/
  #   card3, card4 = PlayingCard.new('2', 'Clubs'), PlayingCard.new('K', 'Diamonds')
  #   game2.player1.retrieve_card(card3)
  #   game2.player2.retrieve_card(card4)
  #   game_runner2.play_round
  #   expect(client3.capture_output).to match /Player 2 took 2 of Clubs with K of Diamonds/
  #   expect(client4.capture_output).to match /You took 2 of Clubs with K of Diamonds/
  # end
end