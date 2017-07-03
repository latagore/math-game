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
