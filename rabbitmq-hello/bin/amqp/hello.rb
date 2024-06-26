#!/usr/bin/env ruby
# encoding: utf-8

require 'rubygems'
require 'amqp'
require 'thread'

AMQP.start('amqp://127.0.0.1:5672') do |connection|
  puts "Connected."
  channel = AMQP::Channel.new connection
  queue = channel.queue('amqpgem.examples.helloworld', auto_delete: true)
  exchange = channel.direct('')

  queue.subscribe do |payload|
    puts "Received a message: #{payload}.  Disconnecting."
    connection.close { EventMachine.stop }
  end
  exchange.publish('Hello, world!', routing_key: queue.name)
end
