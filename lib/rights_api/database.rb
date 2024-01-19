# frozen_string_literal: true

require "sequel"

module RightsAPI
  class Database
    # .connect will take
    #  * a full connection string (passed here OR in the environment
    #    variable RIGHTS_API_DATABASE_CONNECTION_STRING)
    #  * a set of named arguments, drawn from those passed in and the
    #    environment. Arguments are those supported by Sequel.
    #
    # Environment variables are mapped as follows:
    #
    #   user: RIGHTS_API_DATABASE_USER
    #   password: RIGHTS_API_DATABASE_PASSWORD
    #   host: RIGHTS_API_DATABASE_HOST
    #   port: RIGHTS_API_DATABASE_PORT
    #   database: RIGHTS_API_DATABASE_DATABASE
    #   adapter: RIGHTS_API_DATABASE_ADAPTER
    def connect(connection_string = nil, **)
      return @connection if @connection

      connection_string ||= ENV["RIGHTS_API_DATABASE_CONNECTION_STRING"]
      if connection_string.nil?
        db_args = gather_args(**)
        Sequel.connect(**db_args)
      else
        Sequel.connect(connection_string)
      end
    end

    private

    def gather_args(**args)
      %i[user password host port database adapter].each do |arg|
        args[arg] ||= ENV["RIGHTS_API_DATABASE_#{arg.to_s.upcase}"]
      end

      args[:host] ||= "localhost"
      args[:adapter] ||= :mysql2
      args[:database] ||= "ht"
      args
    end
  end
end
