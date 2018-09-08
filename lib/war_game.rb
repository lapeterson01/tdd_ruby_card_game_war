require_relative 'card_deck'
require_relative 'war_player'
require('pry')

class WarGame
    attr_reader :player1, :player2

    def initialize(deck = CardDeck.new)
        @deck = deck
        @player1, @player2 = WarPlayer.new('Player 1'), WarPlayer.new('Player 2')
        @winner
    end

    def start
        @deck.shuffle!
        @player1.retrieve_card(@deck.deal) and @player2.retrieve_card(@deck.deal) until @deck.cards_left.eql?(0)
    end

    def play_round
        played_cards = []
        card1, card2 = @player1.play_card, @player2.play_card
        played_cards << card1 << card2

        if card1.value == card2.value
            while card1.value == card2.value do
                if @player1.hand.length > 0 && @player2.hand.length > 0
                    card1, card2 = @player1.play_card, @player2.play_card
                else
                    return
                end
                played_cards << card1 << card2
            end
        end

        extra_cards_display = " "
        if card1.value > card2.value
            played_cards.each {|card| @player1.retrieve_card(card)}

            if played_cards.size > 2
                (played_cards - [card1, card2]).each do |card|
                    extra_cards_display = ", #{card.rank} of #{card.suit}" + extra_cards_display
                end
            end

            string_to_display = ["Player 1 took #{card2.rank} of #{card2.suit}", "with #{card1.rank} of #{card1.suit}"]
        else
            played_cards.each {|card| @player2.retrieve_card(card)}

            if played_cards.size > 2
                (played_cards - [card1, card2]).each do |card|
                    extra_cards_display = ", #{card.rank} of #{card.suit}" + extra_cards_display
                end
            end

            string_to_display = ["Player 2 took #{card1.rank} of #{card1.suit}", "with #{card2.rank} of #{card2.suit}"]
        end
        string_to_display.join(extra_cards_display)
    end

    def winner
        if @player1.out_of_cards? && @player2.out_of_cards?
            @winner = @player1.hand > @player2.hand ? @player1 : @player2
        elsif @player2.out_of_cards?
            @winner = @player1
        elsif @player1.out_of_cards?
            @winner = @player2
        else
            @winner
        end
    end
end