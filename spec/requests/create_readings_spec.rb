# frozen_string_literal: true

require "rails_helper"

RSpec.describe "POST /readings" do
  let(:headers) { { accept: "application/json" } }
  let(:device_uuid) { "36d5658a-6908-479e-887e-a949ec199272" }
  let(:reading1) { { timestamp: "2021-09-29T16:08:15+01:00", count: 2 } }
  let(:reading2) { { timestamp: "2021-09-29T16:09:15+01:00", count: 15 } }
  let(:params) { { id: device_uuid, readings: [reading1, reading2] } }
  let(:persisted_device) { $datastore.get(device_uuid.to_sym) }

  it "returns a 201 :created response" do
    post "/readings", params: params, headers: headers

    expect(response).to have_http_status(:created)
  end

  it "adds the device & readings to the datastore" do
    post "/readings", params: params, headers: headers

    expect(persisted_device).to have_attributes(
      cumulative_count: 17,
      latest_timestamp: reading2[:timestamp],
      readings: a_collection_containing_exactly(
        an_object_having_attributes(reading1),
        an_object_having_attributes(reading2),
      ),
      timestamps: a_collection_containing_exactly(
        reading1[:timestamp],
        reading2[:timestamp],
      )
    )
  end
end
