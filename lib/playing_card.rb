class PlayingCard
    def initialize(rank, suit)
        @rank = rank
        @suit = suit
        @value
    end

    def card
        card = {'rank' => @rank, 'suit' => @suit}
    end

    def set_value(value)
        @value = value
    end

    def value
        @value
    end

    def rank
        @rank
    end

    def suit
        @suit
    end
end