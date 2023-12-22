# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'messages/new' do
  let!(:user) { create(:user_with_artifacts) }

  before { sign_in(user) }

  it 'renders empty form' do
    assign :message, Message.new

    render

    assert_select 'form[action=?][method=?]', messages_path, 'post' do
      assert_select 'textarea', ''
      assert_select 'input[type=checkbox]'
    end
  end
end
