# frozen_string_literal: true

require 'rails_helper'

# This spec was written with AI assistance
RSpec.describe Datastore do
  let(:datastore) { Datastore.new }
  let(:uuid) { 'thread_safety_uuid' }

  context 'when performing concurrent writes' do
    it 'does not result in deadlocks' do
      # This test creates multiple threads that simultaneously write to the same UUID
      threads = []
      10.times do
        threads << Thread.new do
          datastore.set(uuid, [Reading.new(timestamp: '2022-01-01', count: 1)])
        end
      end

      # Wait for all threads to finish
      threads.each(&:join)

      expect { datastore.get(uuid) }.not_to raise_error
    end

    it 'preserves data consistency during concurrent writes' do
      # This test creates multiple threads that simultaneously write to the same UUID
      threads = []
      10.times do |i|
        threads << Thread.new do
          datastore.set(uuid, [Reading.new(timestamp: "2022-01-0#{i + 1}", count: 1)])
        end
      end

      # Wait for all threads to finish
      threads.each(&:join)

      device = datastore.get(uuid)

      # Ensure that the final cumulative_count matches the expected sum
      expect(device.cumulative_count).to eq(10)
    end
  end

  context 'when performing concurrent reads and writes' do
    it 'does not result in deadlocks' do
      # This test creates multiple threads that simultaneously read and write to the same UUID
      threads = []

      5.times do
        threads << Thread.new do
          10.times do
            datastore.get(uuid)
            datastore.set(uuid, [Reading.new(timestamp: '2022-01-01', count: 1)])
          end
        end
      end

      # Wait for all threads to finish
      threads.each(&:join)

      expect { datastore.get(uuid) }.not_to raise_error
    end

    it 'preserves data consistency during concurrent reads and writes' do
      # This test creates multiple threads that simultaneously read and write to the same UUID
      threads = []

      5.times do |i|
        threads << Thread.new do
          10.times do |j|
            datastore.get(uuid)
            datastore.set(uuid, [Reading.new(timestamp: "2022-0#{i + 1}-#{j + 1}", count: 1)])
          end
        end
      end

      # Wait for all threads to finish
      threads.each(&:join)

      device = datastore.get(uuid)

      # Ensure that the final cumulative_count matches the expected sum
      expect(device.cumulative_count).to eq(50)
    end
  end
end

