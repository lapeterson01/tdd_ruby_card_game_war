require_relative '../lib/war_socket_client'
require_relative '../lib/war_socket_server'
require_relative 'war_socket_server_spec'

describe WarSocketClient do
  def setup_clients(server, clients)
    @client1 = MockWarSocketClient.new(server.port_number)
    @client2 = MockWarSocketClient.new(server.port_number)
    2.times { server.accept_new_client }
    clients << @client1 << @client2
  end

  let(:clients) { [] }
  let(:server) { WarSocketServer.new }

  before do
    server.start
    setup_clients(server, clients)
    @game = server.create_game_if_possible
    @game_runner = WarSocketGameRunner.new(@game, server.games[@game])
    @connection1, @connection2 = @game_runner.client1, @game_runner.client2
  end

  after do
    server.stop
    clients.each(&:close)
  end

  describe 'provide_input' do
    it 'sends messages from server to clients' do
      @connection1.provide_input('You are Player 1')
      @connection2.provide_input('You are Player 2')
      expect(@client1.capture_output).to match(/You are Player 1/)
      expect(@client2.capture_output).to match(/You are Player 2/)
    end
  end

  describe 'capture_output' do
    it 'gets messages sent from client to server' do
      @client1.provide_input('I am player 1')
      @client2.provide_input('I am player 2')
      expect(@connection1.capture_output).to match(/I am player 1/)
      expect(@connection2.capture_output).to match(/I am player 2/)
    end
  end
end
