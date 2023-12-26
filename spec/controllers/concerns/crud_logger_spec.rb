# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CrudLogger do
  let(:controller) { TestController.new }

  describe 'log_request' do
    it 'logs data at the default level' do
      allow(Rails.logger).to receive(:debug)
      data = { name: 'N', user: 88 }

      controller.create(data)

      expect(Rails.logger).to have_received(:debug).with("TestController request in create with #{data}")
    end
  end

  describe 'log_success' do
    it 'logs data at the default level' do
      allow(Rails.logger).to receive(:info)
      data = { id: 88 }

      controller.destroy(data)

      expect(Rails.logger).to have_received(:info).with("TestController success in destroy with #{data}")
    end
  end

  describe 'log_failure' do
    it 'logs data at the default level' do
      allow(Rails.logger).to receive(:error)
      data = { id: 88, name: 'Updated name' }

      controller.update(data)

      expect(Rails.logger).to have_received(:error).with("TestController failure in update with #{data}")
    end
  end
end

# Class to assist with testing
class TestController
  include CrudLogger

  def create(params)
    log_request(__callee__, params)
  end

  def destroy(params)
    log_success(__callee__, params)
  end

  def update(params)
    log_failure(__callee__, params)
  end
end
