require 'pry'

class WarSocketGameRunner
    attr_reader :game, :player1, :player2

    def initialize(game, clients)
        @game = game
        @clients = clients
        @client1, @client2 = @clients[0], @clients[1]
        @output1, @output2 = "", ""
        @clients.each {|client| client.puts 'Are you ready?'}
    end

    def provide_input(text1, text2 = text1)
        @client1.puts(text1)
        @client2.puts(text2)
    end

    def capture_output(delay=0.1)
        sleep(delay)
        @output1 = @client1.read_nonblock(1000)
    rescue IO::WaitReadable
        @output2 = @client2.read_nonblock(1000)
    rescue IO::WaitReadable
        @output = ""
    end

    def start
        # ready_player1 = false
        # ready_player2 = false
        # until ready_player1 && ready_player2
        #     # capture_output(0.5)
        #     if @output1.include? 'yes'
        #         ready_player1 = true
        #     end
        #     if @output2.include? 'yes'
        #         ready_player2 = true
        #     end
        # end
        provide_input('Game Started!')
        @game.start
    end

    def play_round
        player1_cards_left, player2_cards_left = @game.player1.hand.length, @game.player2.hand.length
        provide_input("You have #{player1_cards_left} cards left", "You have #{player2_cards_left} cards left")
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