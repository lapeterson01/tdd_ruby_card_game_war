require_relative '../lib/card_deck'

describe 'CardDeck' do
  describe '#initialize' do
    it 'Should have 52 cards when created' do
      deck = CardDeck.new
      expect(deck.cards_left).to eq 52
    end
  end

  describe '#deal' do
    it 'should deal the top card' do
      deck = CardDeck.new
      card = deck.deal
      expect(card).to be_instance_of PlayingCard
      expect(deck.cards_left).to eq 51
    end
  end

  describe '#cards_left' do
    it 'should return the number of cards left in the deck' do
      deck = CardDeck.new
      expect(deck.cards_left).to eq 52
    end
  end

  describe '#shuffle_deck' do
    it 'randomizes the order of the cards in the deck' do
      deck1 = CardDeck.new
      deck2 = CardDeck.new
      deck1.shuffle_deck
      deck2.shuffle_deck
      expect(deck1.deck[0].card).to_not eq deck2.deck[0].card
    end
  end
end
