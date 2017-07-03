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
