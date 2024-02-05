# frozen_string_literal: true

class DevicesController < ApplicationController
  before_action :set_device_uuid

  def cumulative_count
    count = $datastore.get(@device_uuid).cumulative_count

    render json: { cumulative_count: count }
  end

  def latest_timestamp
    timestamp = $datastore.get(@device_uuid).latest_timestamp

    render json: { latest_timestamp: timestamp }
  end

  private

  def set_device_uuid
    @device_uuid = params.require(:device_uuid).to_sym
  end
end
