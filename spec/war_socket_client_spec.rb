require_relative '../lib/war_socket_client'
require_relative '../lib/war_socket_server'
require_relative 'war_socket_server_spec'

describe WarSocketClient do
    before :each do
        @clients = []
        @server = WarSocketServer.new
        @server.start
        @client1 = MockWarSocketClient.new(@server.port_number)
        @server.accept_new_client
        @client2 = MockWarSocketClient.new(@server.port_number)
        @server.accept_new_client
        @clients << @client1 << @client2
        @game = @server.create_game_if_possible
        @game_runner = WarSocketGameRunner.new(@game, @server.games[@game])
    end

    after :each do
        @server.stop
        @clients.each do |client|
            client.close
        end
    end

    describe 'provide_input' do
        it 'sends messages from server to clients' do
            client1 = @game_runner.client1
            client2 = @game_runner.client2
            client1.provide_input('You are Player 1')
            client2.provide_input('You are Player 2')
            expect(@client1.capture_output).to match /You are Player 1/
            expect(@client2.capture_output).to match /You are Player 2/
        end
    end

    describe 'capture_output' do
        it 'gets messages sent from client to server' do
            client1 = @game_runner.client1
            client2 = @game_runner.client2
            @client1.provide_input("I am player 1")
            @client2.provide_input("I am player 2")
            expect(client1.capture_output).to match /I am player 1/
            expect(client2.capture_output).to match /I am player 2/
        end
    end
end