require 'socket'

class WarSocketServer
  attr_reader :game

  def initialize
    @game
    @players = []
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
    @players.push({:name => player_name.split.join.downcase, :client => client})
    client.puts "#{player_name} connected!"
  rescue IO::WaitReadable, Errno::EINTR
    puts "No client to accept"
  end

  def create_game_if_possible
    if @players.length == 2
      @game = WarGame.new
      @players.each do |player|
        player[:name] = @game.send(player[:name].to_sym)
        player[:name].set_client(player[:client])
        player[:client].puts 'Ready?'
      end
    end
  end

  def run_game
    if @game
      @players.each do |player|
        player[:client].puts 'Game Started!'
      end
      @game.start
      # until @game.winner
        @players.each do |player|
          player[:client].puts "Player 1 has #{player[:name].hand.length} cards left; Player 2 has #{player[:name].hand.length} cards left"
        end
        round_result = @game.play_round
        @players.each do |player|
          player[:client].puts round_result
        end
      # end
      # @game.winner
    end
  end

  def stop
    @server.close if @server
  end
end