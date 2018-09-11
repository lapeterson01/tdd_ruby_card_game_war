require_relative '../lib/card_deck'

describe 'CardDeck' do
  let(:deck) { CardDeck.new }

  describe '#initialize' do
    it 'Should have 52 cards when created' do
      expect(deck.cards_left).to eq 52
    end
  end

  describe '#deal' do
    it 'should deal the top card' do
      card = deck.deal
      expect(card).to be_instance_of PlayingCard
      expect(deck.cards_left).to eq 51
    end
  end

  describe '#cards_left' do
    it 'should return the number of cards left in the deck' do
      expect(deck.cards_left).to eq 52
    end
  end

  describe '#shuffle!' do
    it 'randomizes the order of the cards in the deck' do
      deck2 = CardDeck.new
      expect(deck).to eq deck2
      deck.shuffle!
      deck2.shuffle!
      expect(deck).to_not eq deck2
    end
  end

  describe 'equality' do
    it 'should be == if decks are' do
      deck2 = CardDeck.new
      expect(deck).to eq deck2
    end
  end
end
