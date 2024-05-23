#!/usr/bin/env ruby
# encoding: utf-8

require 'bunny'

conn = Bunny.new
conn.start

ch = conn.create_channel
q = ch.queue('task_queue', durable: true)

ch.prefetch(1) #Get only 1 message at a time, to encourage fair, backlog-based distribution
puts " [*] Waiting for messages in #{q.name}.  To exit press CTRL+C"

begin
  q.subscribe(block: true, manual_ack: true) do |delivery_info, properties, body|
    puts " [x] Received #{body}"
    num_seconds = body.count('.').to_i
    
    puts " [x] Sleeping #{num_seconds}"
    sleep num_seconds
    
    puts ' [x] Done'
    ch.ack(delivery_info.delivery_tag)
  end
rescue Interrupt => _
  conn.close
end
