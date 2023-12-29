# rubocop:disable Naming/FileName
# frozen_string_literal: true

if Rails.env.production? && !ENV.fetch('SKIP_DATADOG', false)
  Datadog.configure do |c|
    c.service = 'broadcast'
    c.profiling.enabled = true
    c.appsec.enabled = true
  end
end

# rubocop:enable Naming/FileName
