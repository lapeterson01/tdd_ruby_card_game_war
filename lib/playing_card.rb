# Creates a new playing card with rank, suit, and value (2-14)
class PlayingCard
  attr_reader :value, :rank, :suit

  FACE_CARD_VALUES = { 'J' => 11, 'Q' => 12, 'K' => 13, 'A' => 14 }.freeze

  def initialize(rank, suit)
    @rank, @suit = rank, suit
    @value = FACE_CARD_VALUES.include?(rank) ? FACE_CARD_VALUES[rank] : rank.to_i
  end

  def card
    { 'rank' => @rank, 'suit' => @suit }
  end

  def ==(other)
    @rank == other.rank && @suit == other.suit
  end
end
