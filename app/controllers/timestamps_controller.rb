# frozen_string_literal: true

class TimestampsController < ApplicationController
  before_action :set_device_uuid

  def latest
    latest_timestamp = $datastore.get(@device_uuid)[:latest_timestamp]
    render json: { latest_timestamp: latest_timestamp }
  end

  private

  def set_device_uuid
    @device_uuid = params.require(:device_uuid).to_sym
  end
end
