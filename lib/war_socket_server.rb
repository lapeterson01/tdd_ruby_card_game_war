require 'socket'

class WarSocketServer
  attr_reader :game

  def initialize
    @game
    @players = {}
  end

  def port_number
    3336
  end

  def start
    @server = TCPServer.new(port_number)
  end

  def accept_new_client(player_name = "Random Player")
    client = @server.accept_nonblock
    # associate player and client
    until client do
      sleep(0.1)
    end
    @players[player_name] = client
    client.puts "#{player_name} connected!"
  rescue IO::WaitReadable, Errno::EINTR
    puts "No client to accept"
  end

  def create_game_if_possible
    if @players.length == 2
      @game = WarGame.new
      @player1, @player2 = @game.player1, @game.player2
      @player1.set_client(@players[@player1.name])
      @player2.set_client(@players[@player2.name])
      @players = [@player1, @player2]
      @players.each {|player| player.client.puts 'Ready?'}
    end
  end

  def run_game
    if @game
      @players.each {|player| player.client.puts 'Game Started!'}
      @game.start
      # until @game.winner
        @players.each {|player| player.client.puts "You have #{player.hand.length} cards left"}
        round_result = @game.play_round
        if round_result.include? 'Player 1'
          @player1.client.puts round_result.sub('Player 1', 'You')
          @player2.client.puts round_result
        else
          @player2.client.puts round_result.sub('Player 2', 'You')
          @player1.client.puts round_result
        end
      # end
      # @game.winner
    end
  end

  def stop
    @server.close if @server
  end
end