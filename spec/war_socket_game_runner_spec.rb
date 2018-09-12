require_relative '../lib/war_socket_server'
require_relative '../lib/war_socket_game_runner'

describe WarSocketGameRunner do
  def setup_clients(server, clients)
    @client1 = MockWarSocketClient.new(server.port_number)
    @client2 = MockWarSocketClient.new(server.port_number)
    2.times { server.accept_new_client }
    clients << @client1 << @client2
  end
  
  let(:clients) { [] }
  let(:server) { WarSocketServer.new }

  before(:each) do
    server.start
    setup_clients(server, clients)
    @game = server.create_game_if_possible
    @game_runner = WarSocketGameRunner.new(@game, server.games[@game])
  end

  after(:each) do
    server.stop
    clients.each(&:close)
  end

  describe '#initialize' do
    it 'asks players if they are ready to begin the game' do
      expect(@client1.capture_output && @client2.capture_output).to match(/Are you ready?/)
    end
  end

  describe '#provide_input' do
    it 'allows server to send input to client' do
      @client1.provide_input('yes')
      @client2.provide_input('yes')
      @game_runner.start
      expect(@client1.capture_output && @client2.capture_output).to match(/Game Started!/)
    end
  end

  describe '#start' do
    it 'waits for prompt from each client, initiates game and sends "Game Started!" to clients' do
      @client1.provide_input('yes')
      @client2.provide_input('yes')
      @game_runner.start
      expect(@game.player1.hand.length && @game.player2.hand.length).to eq 26
      expect(@client1.capture_output && @client2.capture_output).to match(/Game Started!/)
    end
  end

  describe 'game' do
    let(:card1) { PlayingCard.new('A', 'Spades') }
    let(:card2) { PlayingCard.new('2', 'Hearts') }

    describe '#play_round' do
      it 'initiates a round of war and sends the amount of cards the player has left' do
        @client1.provide_input('yes')
        @client2.provide_input('yes')
        @game_runner.start
        clients.each { |client| client.provide_input('play card') }
        @game_runner.play_round
        expect(@client1.capture_output).to match(/You have 26 cards left/)
        expect(@client2.capture_output).to match(/You have 26 cards left/)
      end

      it 'sends the results of the round to each player' do
        @game.player1.retrieve_card(card1)
        @game.player2.retrieve_card(card2)
        @client1.provide_input('play card')
        @client2.provide_input('play card')
        @game_runner.play_round
        expect(@client1.capture_output).to match(/You took 2 of Hearts with A of Spades/)
        expect(@client2.capture_output).to match(/Player 1 took 2 of Hearts with A of Spades/)
      end
    end

    describe '#winner' do
      it 'sends messages "You won!" and "You lost..." to winner and loser, respectively' do
        @game.player1.retrieve_card(card1)
        @game.player2.retrieve_card(card2)
        clients.each { |client| client.provide_input('play card') }
        @game_runner.play_round
        @game_runner.winner
        expect(@client1.capture_output).to match(/You won!/)
        expect(@client2.capture_output).to match(/You lost.../)
      end
    end
  end
end
