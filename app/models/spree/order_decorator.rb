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

  def edit_admin_url
    "#{ENV['SLACK_ADMIN_ORDER_URL']}/#{number}/edit"
  end

  def render_view(partial, assigns = {})
    view = ActionView::Base.new(ActionController::Base.view_paths, assigns)
    view.extend ApplicationHelper
    view.render(:partial => partial)
  end

  def slack_notification_message
    render_view('notification', order: self)
  end
end