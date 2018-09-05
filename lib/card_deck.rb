require_relative 'playing_card'

class CardDeck
  attr_reader :deck

  def initialize
    @card_types = {
      'ranks' => ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A'],
      'suits' => ['Spades', 'Clubs', 'Diamonds', 'Hearts']
    }
    @deck = []
    @card_types['suits'].each do |suit|
      @card_types['ranks'].each do |rank|
        card = PlayingCard.new(rank, suit)
        @deck.push(card)
      end
    end
    @current_card
  end

  def cards_left
    @deck.length
  end

  def deal
    @current_card = @deck.shift
  end

  def shuffle_deck
    @deck.shuffle!
  end
end
