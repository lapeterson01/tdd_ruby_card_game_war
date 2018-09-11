require_relative '../lib/playing_card'

describe 'PlayingCard' do
  let(:playing_card) { PlayingCard.new('A', 'Spades') }

  describe '#initialize' do
    it 'creates a playing card with suit and rank' do
      expect(playing_card.card).to eq('rank' => 'A', 'suit' => 'Spades')
    end
  end

  describe '#card' do
    it 'returns the card object' do
      expect(playing_card.card).to eq('rank' => 'A', 'suit' => 'Spades')
    end
  end

  describe 'equality' do
    it 'should be == if rank and suit are' do
      playing_card2 = PlayingCard.new('A', 'Spades')
      expect(playing_card).to eq playing_card2
    end
  end
end
