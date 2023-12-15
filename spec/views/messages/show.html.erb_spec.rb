require 'rails_helper'

RSpec.describe "messages/show", type: :view do
  let(:user) {
    create :user
  }

  before(:each) do
    assign(:message, Message.create!(
      content: "Parks information",
      status: "SENT",
      sent_at: (DateTime.now - 2),
      user: user
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Content/)
    expect(rendered).to match(/Status/)
    expect(rendered).to match(//)
  end
end
