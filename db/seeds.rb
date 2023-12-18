# frozen_string_literal: true

# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# create a user in the console
# User.create!(email: 'you@you.you', password: 'S3kr!t_')

Message.create!(content: 'Thank you for subscribing to park information messages',
                user: User.first, status: Message.statuses[:sent], sent_at: (DateTime.now - 4))
Message.create!(content: 'Holiday garbage collection date changes',
                user: User.first, status: Message.statuses[:unsent])

Recipient.create!(phone: '6515551212', status: Recipient.statuses[:verified])
Recipient.create!(phone: '6125551212', status: Recipient.statuses[:unverified])
