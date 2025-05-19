class TestJob < ApplicationJob
  queue_as :default

  def perform(*args)
    puts "Sidekiq ejecutó el job correctamente: #{args.inspect}"
  end
end
