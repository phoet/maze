class FakeIO
  attr_reader :messages

  def initialize
    @messages = []
  end

  def puts message
    messages << message
  end

  def flush; end
end
