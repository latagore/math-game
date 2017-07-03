require './game_state'
require './player'
require './question'

class Game
  @@STARTING_LIVES = 3;

  attr_accessor :state, :players

  def initialize
    @state = InitialState.new(self).next
    @players = [Player.new(1, @@STARTING_LIVES), Player.new(2, @@STARTING_LIVES)]
  end

  def play
    while !@state.done
      player = @state.player_number
      question = Question.random_question

      puts "Player #{player}: #{question}"
      input = gets.chomp.to_i

      if question.answered_by input
        puts "Player #{player}: Yay! You are correct."
      else
        puts "Player #{player}: Seriously? No!"
        @players[player - 1].die
      end


      @state.next
      puts @state.status
      if !@state.done
        puts "===== NEW TURN ====="
      else
        puts "===== GAME OVER ====="
      end
    end
  end
end

Game.new.play
