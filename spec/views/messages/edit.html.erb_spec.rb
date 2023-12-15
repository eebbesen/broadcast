require 'rails_helper'

RSpec.describe "messages/edit", type: :view do
  let(:message) {
    create :sent_message
  }

  before(:each) do
    assign(:message, message)
  end

  it "renders the edit message form" do
    render

    assert_select "form[action=?][method=?]", message_path(message), "post" do

      assert_select "input[name=?]", "message[content]"

      assert_select "input[name=?]", "message[status]"

      assert_select "input[name=?]", "message[user_id]"
    end
  end
end
