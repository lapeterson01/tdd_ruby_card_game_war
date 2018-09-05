require_relative '../lib/playing_card'

describe 'PlayingCard' do
    before do
        @card = PlayingCard.new('A', 'Spades')
    end

    describe '#initialize' do
        it 'creates a playing card with suit and rank' do
            expect(@card.card()).to eq ({'rank' => 'A', 'suit' => 'Spades'})
        end
    end

    describe '#card' do
        it 'returns the card object' do
            expect(@card.card).to eq ({'rank' => 'A', 'suit' => 'Spades'})
        end
    end

    describe 'equality' do
        it 'should be == if rank and suit are' do
            card2 = PlayingCard.new('A', 'Spades')
            expect(@card).to eq card2
        end
    end
end