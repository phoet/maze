require 'spec_helper'

describe Maze do

  IOS = []

  context "running client and server" do
    it "emits payload queues it on the server" do
      class Server < GServer
        def initialize
          super Maze::USER_CLIENT_PORT
        end

        def serve io
          puts io.closed?
          user_id = io.readline.chomp
          puts "received user with ID: #{user_id}"
          IOS << io
          puts io.closed?


          unless io.closed?
            io.write "hi #{user_id}"
            sleep(0.1)
          end
        end
      end

      Server.new.start

      3.times do |i|
        TCPSocket.open Maze::HOST, Maze::USER_CLIENT_PORT do |socket|
          socket.print "moin#{i}\n"
          socket.flush

          while event = socket.readline.chomp
            puts "received event: #{event}"
            sleep(0.1)
          end
        end
      end

      sleep(2)
      IOS.should have(3).elements
    end
  end
end
