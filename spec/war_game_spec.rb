require_relative '../lib/war_game'
require 'pry'

describe 'WarGame' do
  let(:game) { WarGame.new }
  let(:player1) { game.player1 }
  let(:player2) { game.player2 }

  describe '#initialize' do
    it 'creates game and players' do
      expect(player1.name).to eq 'Player 1'
      expect(player2.name).to eq 'Player 2'
    end
  end

  describe '#start' do
    it 'starts game by shuffling and dealing deck' do
      game.start
      expect(player1.hand.length && player2.hand.length).to eq(26)
    end
  end

  describe 'The started game' do
    let(:card1) { PlayingCard.new('A', 'Spades') }
    let(:card2) { PlayingCard.new('2', 'Hearts') }
    let(:tied_card1) { PlayingCard.new('Q', 'Hearts') }
    let(:tied_card2) { PlayingCard.new('Q', 'Diamonds') }

    describe '#play_round' do
      it 'adds played cards to the hand of the player that won the round' do
        player1.retrieve_card(card1) && player2.retrieve_card(card2)
        expect(game.play_round).to be_instance_of String
        expect(player1.hand).to eq [card1, card2]
        expect(player2.hand).to eq []
      end

      it 'sends all four cards to the hand of the winning player in the case of a tie' do
        player1.retrieve_card(tied_card1) && player2.retrieve_card(tied_card2)
        player1.retrieve_card(card1) && player2.retrieve_card(card2)
        game.play_round
        expect(player1.hand).to eq [tied_card1, tied_card2, card1, card2]
        expect(player2.hand).to eq []
      end
    end

    describe '#winner' do
      let(:deck) { CardDeck.new }

      it 'returns the name of the player who won if there is a winner' do
        player1.retrieve_card(card1) && player2.retrieve_card(card2)

        game.play_round until game.winner
        expect(game.winner.name).to eq 'Player 1'
      end

      it 'assigns winner in the case of a tie on the last round' do
        player1.retrieve_card(tied_card1) && player2.retrieve_card(tied_card2)

        2.times do
          card = deck.deal
          player1.retrieve_card(card)
        end

        game.play_round until game.winner
        expect(game.winner.name).to eq 'Player 1'
      end
    end
  end
end
