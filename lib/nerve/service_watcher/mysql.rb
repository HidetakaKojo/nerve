require 'nerve/service_watcher/base'

module Nerve
  module ServiceCheck
    class MysqlServiceCheck < BaseServiceCheck
      require 'mysql2'

      def initialize(opts={})
        super

        @host     = opts['host']     || '127.0.0.1'
        @port     = opts['port']     || 3306
        @user     = opts['user']     || nil
        @passowrd = opts['password'] || nil
      end

      def check
        log.debug "nerve: running MySQL health check #{@host}:#{@port}"

        client = Mysql2::Client.new(:host => @host, :port => @port, :username => @user, :password => @password)

        begin
          client.ping
        rescue Mysql2::Error
          log.debug "nerve: can't connect MySQL #{@host}:#{@port}"
          return false
        end

        return true
      end
    end

    CHECKS ||= {}
    CHECKS['mysql'] = MysqlServiceCheck
  end
end
