require_relative 'playing_card'

class CardDeck
  def initialize
    @card_types = {
      'ranks' => ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A'],
      'suits' => ['Spades', 'Clubs', 'Diamonds', 'Hearts']
    }
    @face_card_values = {
      'J' => 11,
      'Q' => 12,
      'K' => 13,
      'A' => 14
    }
    @deck = []
    @card_types['suits'].each do |suit|
      @card_types['ranks'].each do |rank|
        card = PlayingCard.new(rank, suit)
        if rank == 'J' || rank == 'Q' || rank == 'K' || rank == 'A'
          card.set_value(@face_card_values[rank])
        else
          card.set_value(rank.to_i)
        end
        @deck.push(card)
      end
    end
    @current_card
  end

  def cardsLeft
    @deck.length
  end

  def deal
    @current_card = @deck.shift
  end

  def shuffle
    @deck.shuffle
  end
end
