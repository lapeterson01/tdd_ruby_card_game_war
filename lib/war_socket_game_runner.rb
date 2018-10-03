# frozen_string_literal: true

require 'pry'
require_relative 'war_socket_client'

# Runs the game with sockets and server integrated
class WarSocketGameRunner
  attr_reader :game, :client1, :client2

  def initialize(game, clients)
    @game = game
    @clients = []
    @client1, @client2 = WarSocketClient.new(clients[0]), WarSocketClient.new(clients[1])
    @clients << @client1 << @client2
    @output1, @output2 = ''
    @client1.ready, @client2.ready = false
    @clients.each { |client| client.provide_input 'Are you ready?' }
  end

  def start
    players_ready_status
    @client1.ready, @client2.ready = false
    provide_input('Game Started!')
    @game.start
  end

  def play_round
    fetch_cards_left_messages
    provide_input(@player1_cards_left, @player2_cards_left)
    provide_input("Type 'play card' to play the next round")
    handle_play_card_input
    handle_round_result(@game.play_round)
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

  private

  def players_ready_status
    until @client1.ready && @client2.ready
      @output1, @output2 = @client1.capture_output, @client2.capture_output
      @client1.ready = true if @output1.include? 'yes'
      @client2.ready = true if @output2.include? 'yes'
    end
  end

  def handle_round_result(round_result)
    if round_result.include? 'Player 1'
      provide_input(round_result.sub('Player 1', 'You'), round_result)
    else
      provide_input(round_result, round_result.sub('Player 2', 'You'))
    end
  end

  def handle_play_card_input
    until @client1.ready && @client2.ready
      @output1, @output2 = @client1.capture_output, @client2.capture_output
      @client1.ready = true if @output1.include? 'play card'
      @client2.ready = true if @output2.include? 'play card'
    end
    @client1.ready, @client2.ready = false
  end

  def fetch_cards_left_messages
    @player1_cards_left = "You have #{@game.player1.hand.length} cards left"
    @player2_cards_left = "You have #{@game.player2.hand.length} cards left"
  end

  def provide_input(text1, text2 = text1)
    @client1.provide_input(text1)
    @client2.provide_input(text2)
  end
end
