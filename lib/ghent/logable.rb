module Ghent

  def self.app_name
    @app_name || "ghent"
  end

  def self.app_name=( name )
    @app_name = name
  end

  class Logging
    def self.init
      unless @initialized then
        layout   = ::Logging::Layouts::Pattern.new( :pattern => "%5l %c %t : %m\n" )
        appender = ::Logging::Appenders::Stderr.new( Ghent.app_name,
        #appender = ::Logging::Appenders::Syslog.new( Ghent.app_name,
                                                    :logopt => ::Syslog::Constants::LOG_CONS | ::Syslog::Constants::LOG_PID, 
                                                    :facility => ::Syslog::Constants::LOG_LOCAL1,
                                                    :layout => layout)
        gemology_logger = ::Logging::Logger[Ghent]
        #::Logging::Appenders['syslog'] = appender
        ::Logging::Appenders['ghent'] = appender
        gemology_logger.add_appenders( appender )
        @initialized = true
      end
      return @initialized
    end
  end

  module Logable
    def logger
      Ghent::Logging.init
      ::Logging::Logger[self]
    end
  end

  # for when you need ane explicit logging class instance
  class Logger
    include Logable
    %w[ info warn error debug fatal ].each do |m|
      module_eval <<-_code
        def #{m}(*args)
          logger.#{m}(*args)
        end
      _code
    end
  end
end
