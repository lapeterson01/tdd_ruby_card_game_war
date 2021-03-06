require_relative '../lib/war_player'

describe 'WarPlayer' do
  let(:player) { WarPlayer.new('Player 1') }
  let(:card) { PlayingCard.new('A', 'Spades') }

  describe '#initialize' do
    it 'sets name for new player and starts with empty hand' do
      expect(player.name).to eq 'Player 1'
      expect(player.hand).to eq []
    end
  end

  describe '#retrieve_card' do
    it 'retrieves the card being dealt from the deck' do
      player.retrieve_card(card)
      expect(player.hand).to eq [card]
    end
  end

  describe '#reset_hand' do
    it 'sets the players hand to a specified array' do
      player.retrieve_card(card)
      expect(player.hand).to eq [card]

      player.reset_hand
      expect(player.hand).to eq []
    end
  end

  describe '#play_card' do
    it 'removes one card from hand and returns it' do
      player.retrieve_card(card)
      expect(player.play_card).to eq card
    end
  end

  describe '#out_of_cards?' do
    it 'returns true if player has all 52 cards' do
      player.retrieve_card(card)
      expect(player.out_of_cards?).to eq false
      player2 = WarPlayer.new('Player 2')
      expect(player2.out_of_cards?).to eq true
    end
  end
end
