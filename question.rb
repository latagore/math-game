require 'pry'
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
