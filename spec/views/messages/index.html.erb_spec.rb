require 'rails_helper'

RSpec.describe "messages/index", type: :view do
  let(:user) { create :user }
  before(:each) do
    assign(:messages, [
      (create :sent_message, user: user),
      (create :scheduled_message, user: user)
    ])
  end

  it "renders a list of messages" do
    render

    cell_selector = Rails::VERSION::STRING >= '7' ? 'div>p' : 'tr>td'
    assert_select cell_selector, text: Regexp.new("Content".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Status".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("User".to_s), count: 2
  end
end
