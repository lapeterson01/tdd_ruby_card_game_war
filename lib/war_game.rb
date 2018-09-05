require_relative 'card_deck'
require_relative 'war_player'
require('pry')

class WarGame
    def start
        @deck = CardDeck.new
        @player1 = WarPlayer.new
        @player1.set_name('Player 1')
        @player2 = WarPlayer.new
        @player2.set_name('Player 2')
        @deck.shuffle
        until @deck.cardsLeft.eql?(0) do
            card1 = @deck.deal
            @player1.retrieve_card(card1)
            card2 = @deck.deal
            @player2.retrieve_card(card2)
        end
        @winner
    end

    def player(number)
        if number.eql?(1)
            return @player1
        else
            return @player2
        end
    end

    def play_round
        tied_cards = []
        card1 = @player1.play_card
        card2 = @player2.play_card
        if card1.value == card2.value
            while card1.value == card2.value do
                tied_cards.push(card1)
                tied_cards.push(card2)
                card1 = @player1.play_card
                card2 = @player2.play_card
            end
        end
        if card1.value > card2.value
            tied_cards.each do |card|
                @player1.retrieve_card(card)
            end
            @player1.retrieve_card(card1)
            @player1.retrieve_card(card2)
            return string_to_display = "Player 1 took #{card2.rank} of #{card2.suit} with #{card1.rank} of #{card1.suit}"
        else
            tied_cards.each do |card|
                @player2.retrieve_card(card)
            end
            @player2.retrieve_card(card1)
            @player2.retrieve_card(card2)
            return string_to_display = "Player 2 took #{card1.rank} of #{card1.suit} with #{card2.rank} of #{card2.suit}"
        end
    end

    def winner
        if @player1.has_all_cards?
            @winner = @player1
        elsif @player2.has_all_cards?
            @winner = @player2
        else
            @winner
        end
    end
end