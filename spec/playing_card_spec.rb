require_relative '../lib/playing_card'

describe 'PlayingCard' do
    describe('#initialize') do
        it('creates a playing card with suit and rank') do
            card = PlayingCard.new('ace', 'spades')
            expect(card.card()).to eq ({'rank' => 'ace', 'suit' => 'spades'})
        end
    end

    describe('#card') do
        it('returns the card object') do
            card = PlayingCard.new('ace', 'spades')
            expect(card.card).to eq ({'rank' => 'ace', 'suit' => 'spades'})
        end
    end

    describe('#set_value') do
        it('sets the value of a card') do
            card = PlayingCard.new('ace', 'spades')
            card.set_value(14)
            expect(card.value).to eq 14
        end
    end

    describe('#value') do
        it('returns the value of the card') do
            card = PlayingCard.new('ace', 'spades')
            card.set_value(14)
            expect(card.value).to eq 14
        end
    end

    describe('#rank') do
        it('returns the rank of the card') do
            card = PlayingCard.new('ace', 'spades')
            expect(card.rank).to eq 'ace'
        end
    end

    describe('#suit') do
        it('returns the suit of the card') do
            card = PlayingCard.new('ace', 'spades')
            expect(card.suit).to eq 'spades'
        end
    end
end