require 'pry'
require_relative 'war_socket_client'

class WarSocketGameRunner
    attr_reader :game, :client1, :client2

    def initialize(game, clients)
        @game = game
        @clients = []
        @client1, @client2 = WarSocketClient.new(clients[0]), WarSocketClient.new(clients[1])
        @clients << @client1 << @client2
        @output1, @output2 = "", ""
        @clients.each {|client| client.provide_input 'Are you ready?'}
    end

    def provide_input(text1, text2 = text1)
        @client1.provide_input(text1)
        @client2.provide_input(text2)
    end

    def start
        until @client1.ready && @client2.ready
            @output1, @output2 = @client1.capture_output, @client2.capture_output
            @client1.ready = true if @output1.include? 'yes'
            @client2.ready = true if @output2.include? 'yes'
        end
        provide_input('Game Started!')
        @game.start
    end

    def play_round
        @client1.ready, @client2.ready = false, false
        player1_cards_left, player2_cards_left = @game.player1.hand.length, @game.player2.hand.length
        provide_input("You have #{player1_cards_left} cards left", "You have #{player2_cards_left} cards left")
        provide_input("Type 'play card' to play the next round")
        until @client1.ready && @client2.ready
            @output1, @output2 = @client1.capture_output, @client2.capture_output
            @client1.ready = true if @output1.include? 'play card'
            @client2.ready = true if @output2.include? 'play card'
        end
        round_result = @game.play_round
        if round_result.include? 'Player 1'
            provide_input(round_result.sub('Player 1', 'You'), round_result)
        else
            provide_input(round_result, round_result.sub('Player 2', 'You'))
        end
    end

    def winner
        if @game.winner == @game.player1
            provide_input('You won!', 'You lost...')
        elsif @game.winner == @game.player2
            provide_input('You lost...', 'You won!')
        else
            @game.winner
        end      
    end
end