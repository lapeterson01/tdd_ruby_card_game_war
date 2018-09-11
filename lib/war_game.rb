require_relative 'card_deck'
require_relative 'war_player'

# Creates game including methods that allow the game to run
class WarGame
  attr_reader :player1, :player2

  def initialize(deck = CardDeck.new)
    @deck = deck
    @player1, @player2 = WarPlayer.new('Player 1'), WarPlayer.new('Player 2')
    @played_cards = []
    @extra_cards_display = ' '
  end

  def start
    @deck.shuffle!
    until @deck.cards_left.eql?(0)
      @player1.retrieve_card(@deck.deal) && @player2.retrieve_card(@deck.deal)
    end
  end

  def play_round
    fetch_cards_being_played
    @played_cards << @card1 << @card2

    check_tie
    handle_round_result
    @string_to_display.join(@extra_cards_display) if @string_to_display
  end

  def winner
    if @player2.out_of_cards?
      @winner = @player1
    elsif @player1.out_of_cards?
      @winner = @player2
    else
      @winner
    end
  end

  private

  def fetch_cards_being_played
    @card1, @card2 = @player1.play_card, @player2.play_card
  end

  def fetch_player1_win_strings_to_display
    @player1_win_string_pt1 = "Player 1 took #{@card2.rank} of #{@card2.suit}"
    @player1_win_string_pt2 = "with #{@card1.rank} of #{@card1.suit}"
  end

  def fetch_player2_win_strings_to_display
    @player2_win_string_pt1 = "Player 2 took #{@card1.rank} of #{@card1.suit}"
    @player2_win_string_pt2 = "with #{@card2.rank} of #{@card2.suit}"
  end

  def fetch_extra_cards_display
    (@played_cards - [@card1, @card2]).each do |card|
      rank, suit = card.rank, card.suit
      @extra_cards_display = ", #{rank} of #{suit}" + @extra_cards_display
    end
  end

  def check_tie
    @tied_last_round = false
    return unless @card1.value == @card2.value

    while @card1.value == @card2.value
      return if @tied_last_round == true

      tie_handler
    end
  end

  def tie_handler
    if !@player1.hand.empty? && !@player2.hand.empty?
      @card1, @card2 = @player1.play_card, @player2.play_card
    else
      @tied_last_round = true
    end
    @played_cards << @card1 << @card2
  end

  def handle_round_result
    if @card1.value > @card2.value
      handle_player1_round_winner
    elsif @card2.value > @card1.value
      handle_player2_round_winner
    end
  end

  def handle_player1_round_winner
    @played_cards.each { |card| @player1.retrieve_card(card) }

    fetch_extra_cards_display if @played_cards.size > 2

    fetch_player1_win_strings_to_display
    @string_to_display = [@player1_win_string_pt1, @player1_win_string_pt2]
  end

  def handle_player2_round_winner
    @played_cards.each { |card| @player2.retrieve_card(card) }

    fetch_extra_cards_display if @played_cards.size > 2

    fetch_player2_win_strings_to_display
    @string_to_display = [@player2_win_string_pt1, @player2_win_string_pt2]
  end
end
