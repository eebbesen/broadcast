# frozen_string_literal: true

# Base class
module ApplicationHelper
  DATE_FORMAT = '%a %m/%d/%Y %I:%M %p'

  def ui_date(date)
    return '' if date.blank?

    date.strftime(DATE_FORMAT)
  end
end
