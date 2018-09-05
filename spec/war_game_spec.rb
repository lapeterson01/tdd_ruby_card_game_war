require_relative '../lib/war_game'

describe 'WarGame' do
    describe('#start') do
        it('starts game by shuffling and dealing deck') do
            game = WarGame.new
            game.start
            player1 = game.player(1)
            player2 = game.player(2)
            expect(player1.hand).to_not be_nil
            expect(player2.hand).to_not be_nil
        end
    end

    describe('#player') do
        it('returns specified player') do
            game = WarGame.new
            game.start
            expect(game.player(1)).to_not be_nil
            expect(game.player(2)).to_not be_nil
        end
    end

    describe('#play_round') do
        it('compares a card from each of the players hand and adds both cards to the hand of the player that won the round') do
            game = WarGame.new
            game.start
            expect((game.play_round).class).to eq String
            player1 = game.player(1)
            player2 = game.player(2)
            expect((player1.hand.length - player2.hand.length).abs()).to eq 2
        end
    end

    describe('#winner') do
        it('returns the name of the player who won if there is a winner') do
            game = WarGame.new
            game.start
            deck = CardDeck.new
            player1 = game.player(1)
            i = 0
            until i.eql?(26)
                card = deck.deal
                player1.retrieve_card(card)
                i += 1
            end
            expect(game.winner.name).to eq ('Player 1')
        end
    end
end