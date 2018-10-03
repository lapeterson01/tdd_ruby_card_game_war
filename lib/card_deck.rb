require_relative 'playing_card'

# Creates a new deck of 52 standard playing cards
class CardDeck
  attr_reader :cards

  RANKS = %w[2 3 4 5 6 7 8 9 10 J Q K A].freeze
  SUITS = %w[Spades Clubs Diamonds Hearts].freeze

  def initialize
    @cards = RANKS.map do |rank|
      SUITS.map { |suit| PlayingCard.new(rank, suit) }
    end
    @cards.flatten!
  end

  def cards_left
    @cards.length
  end

  def deal
    @cards.shift
  end

  def shuffle!
    @cards.shuffle!
  end

  def ==(other)
    equal = true
    other.cards.each do |card2|
      equal = false if @cards[other.cards.index(card2)] != card2
    end
    equal
  end
end
