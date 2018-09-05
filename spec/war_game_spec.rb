require_relative '../lib/war_game'

describe 'WarGame' do
    describe '#start' do
        it 'starts game by shuffling and dealing deck' do
            game = WarGame.new
            game.start
            player1 = game.player1
            player2 = game.player2
            expect(player1.hand.length).to eq 26
            expect(player2.hand.length).to eq 26
        end
    end

    describe '#play_round' do
        it 'compares a card from each of the players hand and adds both cards to the hand of the player that won the round' do
            game = WarGame.new
            game.start
            expect(game.play_round).to be_instance_of String
            card1 = PlayingCard.new('A', 'Spades')
            card2 = PlayingCard.new('2', 'Hearts')
            player1 = game.player1
            player2 = game.player2
            player1.reset_hand
            player2.reset_hand
            player1.retrieve_card(card1)
            player2.retrieve_card(card2)
            game.play_round
            expect(player1.hand).to eq ([card1, card2])
            expect(player2.hand).to eq ([])
        end

        it 'sends all four cards to the hand of the winning player if the previous round resulted in a tie' do
            game = WarGame.new
            game.start
            card1 = PlayingCard.new('Q', 'Spades')
            card2 = PlayingCard.new('Q', 'Hearts')
            card3 = PlayingCard.new('A', 'Spades')
            card4 = PlayingCard.new('2', 'Clubs')
            player1 = game.player1
            player2 = game.player2
            player1.reset_hand
            player2.reset_hand
            player1.retrieve_card(card1)
            player2.retrieve_card(card2)
            player1.retrieve_card(card3)
            player2.retrieve_card(card4)
            game.play_round
            expect(player1.hand).to eq ([card1, card2, card3, card4])
            expect(player2.hand).to eq ([])
        end
    end

    describe '#winner' do
        it 'returns the name of the player who won if there is a winner' do
            game = WarGame.new
            game.start
            player1 = game.player1
            player2 = game.player2
            card1 = PlayingCard.new('A', 'Spades')
            card2 = PlayingCard.new('2', 'Hearts')
            player1.retrieve_card(card1)
            player2.retrieve_card(card2)
            deck = CardDeck.new
            25.times do
                card = deck.deal
                player1.retrieve_card(card)
            end
            until game.winner do
                game.play_round
            end
            expect(game.winner.name).to eq ('Player 1')
        end

        it 'assigns winner to the player with 52 cards in hand even in the case of a tie on the last round' do
            game = WarGame.new
            game.start
            player1 = game.player1
            player2 = game.player2
            card1 = PlayingCard.new('A', 'Spades')
            card2 = PlayingCard.new('A', 'Hearts')
            player1.retrieve_card(card1)
            player2.retrieve_card(card2)
            deck = CardDeck.new
            25.times do
                card = deck.deal
                player1.retrieve_card(card)
            end
            until game.winner do
                game.play_round
            end
            expect(game.winner.name).to eq ('Player 1')
        end
    end
end