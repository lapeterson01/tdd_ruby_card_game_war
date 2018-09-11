require_relative '../lib/war_game'
require 'pry'

describe 'WarGame' do
  let(:game) { WarGame.new }

  describe '#initialize' do
    it 'creates game and players' do
      expect(game.player1.name).to eq 'Player 1'
      expect(game.player2.name).to eq 'Player 2'
    end
  end

  describe '#start' do
    it 'starts game by shuffling and dealing deck' do
      game.start
      player1, player2 = game.player1, game.player2
      expect(26).to eq(player1.hand.length) && eq(player2.hand.length)
    end
  end

  describe '#play_round' do
    it 'adds played cards to the hand of the player that won the round' do
      player1, player2 = game.player1, game.player2
      card1, card2 = PlayingCard.new('A', 'Spades'), PlayingCard.new('2', 'Hearts')

      player1.retrieve_card(card1) && player2.retrieve_card(card2)
      expect(game.play_round).to be_instance_of String
      expect(player1.hand).to eq [card1, card2]
      expect(player2.hand).to eq []
    end

    it 'sends all four cards to the hand of the winning player in the case of a tie' do
      card1, card2 = PlayingCard.new('Q', 'Spades'), PlayingCard.new('Q', 'Hearts')
      card3, card4 = PlayingCard.new('A', 'Spades'), PlayingCard.new('2', 'Clubs')
      player1, player2 = game.player1, game.player2

      player1.retrieve_card(card1) && player2.retrieve_card(card2)
      player1.retrieve_card(card3) && player2.retrieve_card(card4)
      game.play_round
      expect(player1.hand).to eq [card1, card2, card3, card4]
      expect(player2.hand).to eq []
    end
  end

  describe '#winner' do
    it 'returns the name of the player who won if there is a winner' do
      player1, player2 = game.player1, game.player2
      card1, card2 = PlayingCard.new('A', 'Spades'), PlayingCard.new('2', 'Hearts')

      player1.retrieve_card(card1) && player2.retrieve_card(card2)

      deck = CardDeck.new
      50.times do
        card = deck.deal
        player1.retrieve_card(card)
      end

      game.play_round until game.winner
      expect(game.winner.name).to eq 'Player 1'
    end

    it 'assigns winner in the case of a tie on the last round' do
      player1, player2 = game.player1, game.player2
      card1, card2 = PlayingCard.new('A', 'Spades'), PlayingCard.new('A', 'Hearts')
      player1.retrieve_card(card1) && player2.retrieve_card(card2)

      deck = CardDeck.new
      2.times do
        card = deck.deal
        player1.retrieve_card(card)
      end

      game.play_round until game.winner
      expect(game.winner.name).to eq 'Player 1'
    end
  end
end
