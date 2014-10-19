class SlackNotificationWorker
  include Sidekiq::Worker

  def perform(order_number)
    puts "Notifying order state for #{order_number}"
    order = Spree::Order.find_by_number(order_number)
  end
end