class WarPlayer
    attr_reader :name, :hand

    def initialize(name)
        @hand = []
        @name = name
    end

    def retrieve_card(card)
        @hand.push(card)
    end

    def play_card
        @hand.shift
    end

    def has_all_cards?
        @hand.length.eql?(52)
    end

    def reset_hand
        @hand = []
    end
end