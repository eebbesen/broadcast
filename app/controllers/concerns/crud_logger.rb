# frozen_string_literal: true

# Concern to standardize controller loggging
module CrudLogger
  extend ActiveSupport::Concern

  TEMPLATE = '%<class_name>s TYPE in %<method>s with %<data>s'
  REQUEST = TEMPLATE.gsub('TYPE', 'request')
  SUCCESS = TEMPLATE.gsub('TYPE', 'success')
  FAILURE = TEMPLATE.gsub('TYPE', 'failure')

  included do
    # log request to do something (e.g., create/destroy/edit a resource)
    def log_request(method, data)
      Rails.logger.debug(format(REQUEST, class_name: self.class.name, method:, data:))
    end

    def log_success(method, data)
      Rails.logger.info(format(SUCCESS, class_name: self.class.name, method:, data:))
    end

    def log_failure(method, data)
      Rails.logger.error(format(FAILURE, class_name: self.class.name, method:, data:))
    end
  end

  # class_methods do

  # end
end
