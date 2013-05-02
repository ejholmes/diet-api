worker_processes ENV['UNICORNS'] ? ENV['UNICORNS'].to_i : 4
timeout 30
preload_app true

before_fork do |server, worker|
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.connection.disconnect!
  end

  sleep 1
end

after_fork do |server, worker|
  if defined?(ActiveRecord::Base)
    Diet.connect!
  end
end
