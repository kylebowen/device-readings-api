# frozen_string_literal: true

class Reading
  attr_reader :count, :timestamp

  def initialize(count:, timestamp:)
    @count = count.to_i
    @timestamp = timestamp
  end
end
