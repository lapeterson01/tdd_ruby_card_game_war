# Creates a player for a game with name and hand
class WarPlayer
  attr_reader :name, :hand

  def initialize(name)
    @hand, @name = [], name
  end

  def retrieve_card(card)
    @hand.push(card)
  end

  def play_card
    @hand.shift
  end

  def out_of_cards?
    @hand.length.eql?(0)
  end

  def reset_hand
    @hand = []
  end
end
