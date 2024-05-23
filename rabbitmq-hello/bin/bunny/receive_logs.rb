#!/usr/bin/env ruby
# encoding: utf-8

require 'bunny'

conn = Bunny.new
conn.start

ch = conn.create_channel
x = ch.fanout('logs')
q = ch.queue('', exclusive: true) #This consumer gets its own, anonymous queue with a generated name
q.bind(x)

puts " [*] Waiting for messages in #{q.name}.  To exit press CTRL+C"

begin
  q.subscribe(block: true) do |delivery_info, properties, body|
    puts " [x] #{body}"
  end
rescue Interrupt => _
  ch.close
  conn.close
end
