# frozen_string_literal: true

# Base class
class ApplicationController < ActionController::Base
  include CrudLogger
end
