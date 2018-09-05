class WarPlayer
    attr_reader :name

    def initialize
        @hand = []
        @name
    end

    def retrieve_card(card)
        @hand.push(card)
    end

    def hand
        @hand
    end

    def play_card
        @hand.shift
    end

    def set_name(name)
        @name = name
    end

    def has_all_cards?
        @hand.length.eql?(52)
    end
end