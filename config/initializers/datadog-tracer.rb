# rubocop:disable Naming/FileName
# frozen_string_literal: true

Datadog.configure do |c|
  c.env = 'development'
  c.service = 'broadcast'
  c.profiling.enabled = true
  c.appsec.enabled = true
end

# rubocop:enable Naming/FileName
