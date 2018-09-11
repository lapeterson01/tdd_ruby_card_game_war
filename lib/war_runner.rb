require_relative 'war_game'

game = WarGame.new
game.start
puts game.play_round until game.winner
puts "Winner: #{game.winner.name}"
