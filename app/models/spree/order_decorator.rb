Spree::Order.class_eval do
  after_save :trigger_slack_notification

  def trigger_slack_notification
    if self.state_changed? and self.state == "complete"
      SlackNotificationWorker.perform_async(self.number)
    end
  end

  def user_display_format
    if name.present? && email.present?
      return "#{name}(#{email})"
    else
      return "#{email}"
    end
  end

  def slack_notification_message    
    line_items_str = ""
    self.line_items.each { |line_item| line_items_str += "\n#{line_item.variant.name}(#{line_item.quantity})" }
    
    "Order completed by #{user_display_format} for $#{self.total} with items #{line_items_str}"
  end
end