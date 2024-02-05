# frozen_string_literal: true

require "rails_helper"

RSpec.describe "GET /up" do
  it "returns a 200 response" do
    get "/up"

    expect(response).to have_http_status(:ok)
  end
end
