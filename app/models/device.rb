# frozen_string_literal: true

class Device
  attr_reader :cumulative_count, :latest_timestamp, :readings, :timestamps

  def initialize(count: 0, latest: "", readings: [], timestamps: [])
    @cumulative_count = count
    @latest_timestamp = latest
    @readings = readings
    @timestamps = timestamps
  end

  def add_readings(reads)
    reads.each do |read|
      # ignore readings for duplicate timestamps
      next if timestamps.include?(read.timestamp)

      self.timestamps << read.timestamp
      self.readings << read
      self.cumulative_count += read.count
      self.latest_timestamp = [latest_timestamp, read.timestamp].max
    end
  end

  private

  attr_writer :cumulative_count, :latest_timestamp, :readings, :timestamps
end
