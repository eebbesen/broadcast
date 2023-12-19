# frozen_string_literal: true

# Recipient Helper
module RecipientsHelper
  def format(phone)
    p = phone.gsub(/[\s\+(\)\.-]/, '')
    p = p.delete_prefix('1') if p.length == 11
    p = p.split('x')[0] if p.index('x') == 10
    p
  end
end
