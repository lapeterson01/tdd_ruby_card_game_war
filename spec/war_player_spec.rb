require_relative '../lib/war_player'

describe 'WarPlayer' do
    describe '#initialize' do
        it 'sets name for new player and starts with empty hand' do
            player = WarPlayer.new('Player')
            expect(player.name).to eq 'Player'
            expect(player.hand).to eq ([])
        end
    end

    describe '#retrieve_card' do
        it 'retrieves the card being dealt from the deck' do
            player = WarPlayer.new('Player')
            deck = CardDeck.new
            card = deck.deal
            player.retrieve_card(card)
            expect(player.hand).to eq ([card])
        end
    end

    describe '#reset_hand' do
        it 'sets the players hand to a specified array' do
            player = WarPlayer.new('Player')
            expect(player.hand).to eq ([])
            card = PlayingCard.new('A', 'Spades')
            player.retrieve_card(card)
            expect(player.hand).to eq ([card])
            player.reset_hand
            expect(player.hand).to eq ([])
        end
    end

    describe '#play_card' do
        it 'removes one card from hand and returns it' do
            player = WarPlayer.new('Player')
            card = PlayingCard.new('A', 'Spades')
            player.retrieve_card(card)
            expect(player.play_card).to eq card
        end
    end

    describe '#has_all_cards?' do
        it 'returns true if player has all 52 cards' do
            player = WarPlayer.new('Player')
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