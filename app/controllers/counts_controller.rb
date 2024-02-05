# frozen_string_literal: true

class CountsController < ApplicationController
  before_action :set_device_uuid

  def cumulative
    cumulative_count = $datastore.get(@device_uuid)[:cumulative_count]
    render json: { cumulative_count: cumulative_count }
  end

  private

  def set_device_uuid
    @device_uuid = params.require(:device_uuid).to_sym
  end
end
