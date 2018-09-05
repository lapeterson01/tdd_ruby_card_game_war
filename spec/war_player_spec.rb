require_relative '../lib/war_player'

describe 'WarPlayer' do
    describe('#retrieve_card') do
        it('retrieves the card being dealt from the deck') do
            player = WarPlayer.new
            deck = CardDeck.new
            card = deck.deal
            player.retrieve_card(card)
            expect(player.hand).to eq ([card])
        end
    end

    describe('#hand') do
        it('returns players hand') do
            player = WarPlayer.new
            deck = CardDeck.new
            card = deck.deal
            player.retrieve_card(card)
            expect(player.hand).to eq ([card])
        end
    end

    describe('#play_card') do
        it('removes one card from hand and returns it') do
            player = WarPlayer.new
            deck = CardDeck.new
            card = deck.deal
            player.retrieve_card(card)
            expect(player.play_card).to eq card
        end
    end

    describe('#set_name') do
        it('sets the name of the player') do
            player = WarPlayer.new
            player.set_name('Player 1')
            expect(player.name).to eq 'Player 1'
        end
    end

    describe('#has_all_cards?') do
        it('returns true if player has all 52 cards') do
            player = WarPlayer.new
            deck = CardDeck.new
            i = 0
            until i.eql?(52)
                card = deck.deal
                player.retrieve_card(card)
                i += 1
            end
            expect(player.has_all_cards?).to eq true
        end
    end
end