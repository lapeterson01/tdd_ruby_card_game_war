class PlayingCard
    attr_reader :value, :rank, :suit

    def initialize(rank, suit)
        @rank = rank
        @suit = suit
        @face_card_values = {
            'J' => 11,
            'Q' => 12,
            'K' => 13,
            'A' => 14
        }
        @value
        if rank == 'J' || rank == 'Q' || rank == 'K' || rank == 'A'
            @value = @face_card_values[rank]
        else
            @value = rank.to_i
        end
    end

    def card
        card = {'rank' => @rank, 'suit' => @suit}
    end
end