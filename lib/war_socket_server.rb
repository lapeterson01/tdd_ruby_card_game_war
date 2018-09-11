require 'socket'
require_relative 'war_socket_game_runner'
require_relative 'war_game'

class WarSocketServer
  attr_reader :games

  def initialize
    @games = {}
    @players = {}
    @pending_clients = []
  end

  def port_number
    3336
  end

  def start
    @server = TCPServer.new(port_number)
  end

  def accept_new_client(player_name = "Random Player")
    client = @server.accept_nonblock
    sleep(0.1) until client
    @pending_clients.push(client)
    client.puts "You are connected!"
    @pending_clients.length.odd? ? client.puts("Waiting for another player") : client.puts("Prepare to go to war!")
  rescue IO::WaitReadable, Errno::EINTR
    
  end

  def create_game_if_possible
    if @pending_clients.length > 1
      game = WarGame.new
      @games[game] = @pending_clients.shift(2)
      game
    end
  end

  def run_game(game)
    game_runner = WarSocketGameRunner.new(game, @games[game])
    game_runner.start
    Thread.start() do
      until game_runner.winner
        game_runner.play_round
      end
      game_runner.winner
    end
  end

  def stop
    @server.close if @server
  end
end