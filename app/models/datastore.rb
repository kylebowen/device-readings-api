# frozen_string_literal: true

class Datastore
  def initialize
    @mutex = Mutex.new
    @devices = {}
    @devices.default_proc = proc do |hash, key|
      hash[key] = Device.new
    end
  end

  def get(uuid)
    @mutex.synchronize do
      @devices[uuid]
    end
  end

  def set(uuid, readings)
    @mutex.synchronize do
      @devices[uuid].add_readings(readings)
    end
  end
end
