require 'active_support/concern'

Spree::Order.class_eval do
  after_save :trigger_slack_notification

  def trigger_slack_notification
    if self.state_changed? and self.state == "complete"
      SlackNotificationWorker.perform_async(self.number)
    end
  end
end