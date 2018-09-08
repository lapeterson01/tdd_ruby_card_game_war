require_relative 'playing_card'
require 'pry'

class CardDeck
  attr_reader :cards

  RANKS = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A']
  SUITS = ['Spades', 'Clubs', 'Diamonds', 'Hearts']

  def initialize(cards = RANKS.map{|rank| SUITS.map{|suit| PlayingCard.new(rank, suit)}}.flatten)
    @cards = cards
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

  def == other
    equal = true
    other.cards.each {|card2| equal = false if @cards[other.cards.index(card2)] != card2}
    equal
  end
end
