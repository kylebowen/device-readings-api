# frozen_string_literal: true

require "rails_helper"

RSpec.describe "POST /readings" do
  let(:headers) { { accept: "application/json" } }
  let(:params) {
    {
      id: "36d5658a-6908-479e-887e-a949ec199272",
      readings: [
        {
          timestamp: "2021-09-29T16:08:15+01:00",
          count: 2
        },
        {
          timestamp: "2021-09-29T16:09:15+01:00",
          count: 15
        }
      ]
    }
  }

  it "returns a 201 :created response" do
    post "/readings", params: params, headers: headers

    expect(response).to have_http_status(:created)
  end
end
