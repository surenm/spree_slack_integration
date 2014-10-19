Spree::Order.class_eval do
  Spree::Order.state_machine.after_transition to: :complete, do: :trigger_slack_notification

  def trigger_slack_notification
    puts "Triggering slack notification for order #{self.number}"
  end
end