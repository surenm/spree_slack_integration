require 'slack-notifier'

class SlackNotificationWorker
  include Sidekiq::Worker
  sidekiq_options :queue => :slack_notification

  def perform(order_number)
    order = Spree::Order.find_by_number(order_number)
    notifier = Slack::Notifier.new(ENV['SLACK_TEAM_NAME'], ENV['SLACK_CHANNEL_TOKEN'])
    notifier.ping(order.slack_notification_message, channel: ENV['SLACK_CHANNEL_NAME'])
  end
end