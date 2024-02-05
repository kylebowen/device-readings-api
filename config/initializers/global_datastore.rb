# frozen_string_literal: true

Rails.configuration.after_initialize do
  $datastore = ::Datastore.new
end
