require './game_state'
require './player'
require './question'

module MathGame
  module GameState
    def next; end
    def status; end
    def done; end
  end

  class InitialState
    include GameState
    def initialize(game)
      @game = game
    end

    def next
      @game.state = PlayState.new @game, 1
    end

    def done
      false
    end
  end

  class PlayState
    include GameState

    attr_reader :player_number

    def initialize(game, player_number)
      @game = game
      @player_number = player_number
    end

    def next
      players_alive = @game.players.select do |player|
        player.lives > 0
      end

      if players_alive.size < 2
        @game.state = EndState.new players_alive.first
      elsif @player_number == 1
        @game.state = PlayState.new @game, 2
      else
        @game.state = PlayState.new @game, 1
      end
    end

    def status
      "P1: #{@game.players[0].lives}/3 vs P2: #{@game.players[1].lives}/3"
    end

    def done
      false
    end
  end

  class EndState
    include GameState

    def initialize(winner)
      @winner = winner
    end

    def nextState
      raise "No next state"
    end

    def status
      "P#{@winner.id} wins with a score of #{@winner.lives}/3"
    end

    def done
      true
    end
  end

  class Question
    @@MIN_NUMBER = 1;
    @@MAX_NUMBER = 20;
    @@VALID_OPERATORS = ['+', '-', '*'];
    # random number generator
    GEN = Random.new
    def initialize(a, b, operator = "+")
      if !(@@VALID_OPERATORS.include? operator)
        raise "operator must be either +, -, *, or /"
      end
      @a = a
      @b = b
      @operator = operator
    end

    def self.random_question()
      Question.new(
        GEN.rand(@@MIN_NUMBER..@@MAX_NUMBER),
        GEN.rand(@@MIN_NUMBER..@@MAX_NUMBER),
        @@VALID_OPERATORS.sample
      )
    end

    def answered_by(number)
      # check if @a ~ @b equals the given number
      # ex: if @operator = '*'
      # then return @a * @b == number
      @a.send(@operator, @b) == number
    end

    def to_s
      case @operator
      when '+'
        op = "plus"
      when '-'
        op = 'minus'
      when '*'
        op = 'times'
      end
      "What does #{@a} #{op} #{@b} equal?"
    end
  end

  class Player
    attr_reader :id, :lives

    def initialize(id, lives)
      @id = id
      @lives = lives
    end

    def die
      @lives -= 1
    end
  end

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
end
