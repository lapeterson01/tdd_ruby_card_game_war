class PlayingCard
    attr_reader :value, :rank, :suit

    FACE_CARD_VALUES = {'J' => 11, 'Q' => 12, 'K' => 13, 'A' => 14}

    def initialize(rank, suit)
        @rank, @suit = rank, suit
        @value
        rank == 'J' || rank == 'Q' || rank == 'K' || rank == 'A' ? @value = FACE_CARD_VALUES[rank] : @value = rank.to_i
    end

    def card
        card = {'rank' => @rank, 'suit' => @suit}
    end

    def == other
        @rank == other.rank && @suit == other.suit
    end
end