require_relative '../lib/war_socket_server'
require_relative '../lib/war_socket_game_runner'

describe WarSocketGameRunner do
    before(:each) do
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

    after(:each) do
        @server.stop
        @clients.each do |client|
            client.close
        end
    end

    describe '#initialize' do
        it 'asks players if they are ready to begin the game' do
            expect(@client1.capture_output && @client2.capture_output).to match /Are you ready?/
        end
    end

    describe '#provide_input' do
        it 'allows server to send input to client' do
            @client1.provide_input('yes')
            @client2.provide_input('yes')
            @game_runner.start
            expect(@client1.capture_output && @client2.capture_output).to match /Game Started!/
        end
    end

    describe '#start' do
        it 'waits for prompt from each client, then initiates game and send "Game Started!" to clients' do
            @client1.provide_input('yes')
            @client2.provide_input('yes')
            @game_runner.start
            expect(@game.player1.hand.length && @game.player2.hand.length).to eq 26
            expect(@client1.capture_output && @client2.capture_output).to match /Game Started!/
        end
    end

    describe '#play_round' do
        it 'initiates a round of war and sends the amount of cards the player has left' do
            @client1.provide_input('yes')
            @client2.provide_input('yes')
            @game_runner.start
            @clients.each {|client| client.provide_input('play card')}
            @game_runner.play_round
            expect(@client1.capture_output && @client2.capture_output).to match /You have 26 cards left/
        end

        it 'sends the results of the round to each player' do
            card1, card2 = PlayingCard.new('A', 'Spades'), PlayingCard.new('2', 'Hearts')
            @game.player1.retrieve_card(card1)
            @game.player2.retrieve_card(card2)
            @client1.provide_input('play card')
            @client2.provide_input('play card')
            @game_runner.play_round
            expect(@client1.capture_output).to match /You took 2 of Hearts with A of Spades/
            expect(@client2.capture_output).to match /Player 1 took 2 of Hearts with A of Spades/
        end
    end

    describe '#winner' do
        it 'sends messages "You won!" and "You lost..." to winner and loser, respectively' do
            card1, card2 = PlayingCard.new('A', 'Spades'), PlayingCard.new('2', 'Hearts')
            @game.player1.retrieve_card(card1)
            @game.player2.retrieve_card(card2)
            @clients.each {|client| client.provide_input('play card')}
            @game_runner.play_round
            @game_runner.winner
            expect(@client1.capture_output).to match /You won!/
            expect(@client2.capture_output).to match /You lost.../
        end
    end
end