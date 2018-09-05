require_relative '../lib/playing_card'

describe 'PlayingCard' do
    describe '#initialize' do
        it 'creates a playing card with suit and rank' do
            card = PlayingCard.new('ace', 'spades')
            expect(card.card()).to eq ({'rank' => 'ace', 'suit' => 'spades'})
        end
    end

    describe '#card' do
        it 'returns the card object' do
            card = PlayingCard.new('ace', 'spades')
            expect(card.card).to eq ({'rank' => 'ace', 'suit' => 'spades'})
        end
    end
end