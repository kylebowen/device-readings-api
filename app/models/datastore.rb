# frozen_string_literal: true

class Datastore
  def initialize
    @devices = {}
    @devices.default_proc = proc do |hash, key|
      hash[key] = {
        cumulative_count: 0,
        latest_timestamp: "",
        timestamps: [],
        readings: [],
      }
    end
  end

  def get(uuid)
    @devices[uuid]
  end

  def set(uuid, readings)
    device = get(uuid)
    readings.each do |reading|
      # ignore readings for duplicate timestamps
      next if device[:timestamps].include?(reading[:timestamp])

      reading[:count] = reading[:count].to_i

      device[:timestamps] << reading[:timestamp]
      device[:readings] << reading
      device[:cumulative_count] += reading[:count]
      device[:latest_timestamp] = [device[:latest_timestamp], reading[:timestamp]].max
    end

    @devices[uuid] = device
  end
end
