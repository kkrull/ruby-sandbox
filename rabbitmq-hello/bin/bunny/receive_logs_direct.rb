#!/usr/bin/env ruby
# encoding: utf-8

require 'bunny'

if ARGV.empty?
  abort "Usage: #{$0} <info|warning|error> ..."
end

conn = Bunny.new
conn.start

ch = conn.create_channel
x = ch.direct('direct_logs')
q = ch.queue('', exclusive: true) #This consumer gets its own, anonymous queue with a generated name

ARGV.each do |severity|
  q.bind(x, routing_key: severity)
end

puts " [*] Waiting for messages in #{q.name}.  To exit press CTRL+C"

begin
  q.subscribe(block: true) do |delivery_info, properties, body|
    puts " [x] #{body}"
  end
rescue Interrupt => _
  ch.close
  conn.close
end
