# frozen_string_literal: true

require "rails_helper"

RSpec.describe "GET /devices/:device_uuid/counts/cumulative" do
  let(:device_uuid) { "36d5658a-6908-479e-887e-a949ec199272" }
  let(:reading1) { { timestamp: "2021-09-29T16:08:15+01:00", count: 2 } }
  let(:reading2) { { timestamp: "2021-09-29T16:09:15+01:00", count: 15 } }

  before do
    $datastore.set(device_uuid.to_sym, [reading2, reading1])
  end

  context "when given a valid device_uuid" do
    it "returns a 200 :ok response" do
      get "/devices/#{device_uuid}/counts/cumulative"

      expect(response).to have_http_status(:ok)
    end

    it "returns json with the cumulative count" do
      get "/devices/#{device_uuid}/counts/cumulative"

      expect(response.body).to eq(
        { cumulative_count: 17 }.to_json
      )
    end
  end

  context "when given a device_uuid with no readings" do
    it "returns a 200 :ok response" do
      get "/devices/invalid/counts/cumulative"

      expect(response).to have_http_status(:ok)
    end

    it "returns json with the cumulative count" do
      get "/devices/invalid/counts/cumulative"

      expect(response.body).to eq(
        { cumulative_count: 0 }.to_json
      )
    end
  end
end
