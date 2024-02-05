# frozen_string_literal: true

class ReadingsController < ApplicationController
  before_action :set_device_uuid
  before_action :set_readings

  def create
    $datastore.set(@device_uuid, @readings)

    render status: :created
  end

  private

  def set_device_uuid
    @device_uuid = params.require(:id).to_sym
  end

  def set_readings
    @readings = params.permit(readings: [:timestamp, :count]).require(:readings)
    @readings = @readings.map(&:to_h).map(&:symbolize_keys)
  end
end
