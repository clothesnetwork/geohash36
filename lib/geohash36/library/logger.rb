#!/usr/bin/env ruby


# System
require 'ostruct'
require 'singleton'

# XMPP (jabber) support
# require 'xmpp4r'
# require 'xmpp4r-simple'
# require 'xmpp4log'

# AMQP support
# equire 'amqp'


module ClothesNetwork

  class Logger

    include Singleton

    # @fn         def initialize options = nil # {{{
    # @brief      Default constuctor
    def initialize

      @symbols = {
        :unknown   => [ "(UU)", "LightBlue"   ],
        :trace     => [ "(**)", "LightBlue"   ],
        :debug     => [ "(++)", "LightBlue"   ],
        :info      => [ "(--)", "Brown"       ],
        :notice    => [ "(==)", "Brown"       ],
        :warning   => [ "(WW)", "Yellow"      ],
        :error     => [ "(EE)", "LightRed"    ],
        :critical  => [ "(!!)", "LightRed"    ],
        :alert     => [ "(!!)", "LightRed"    ],
        :fatal     => [ "(!!)", "LightRed"    ],

        :success   => [ "(II)", "LightGreen"  ],
        :question  => [ "(??)", "LightCyan"   ]
      }

      @color    = true
      @silent   = false

      # # Determine what levels are relevant for XMPP based on @options.xmpp_message_level
      # levels          = @symbols.keys.to_a
      # @xmpp_relevant  = levels.slice( levels.index( @options.xmpp_message_level ), levels.length ) unless( @xmpp.nil? )

      # # Handle XMPP Setup
      # @xmpp     = nil

      # if( @options.xmpp )
      #   # FIXME: Re-write wrapper to a more proper form
      #   # @xmpp         = XMPPLogger.new( @options.server_xmpp_id, @options.server_xmpp_password, @options.client_xmpp_ids )
      #   # @xmpp.level   = Logger::ERROR # default level on which messages will be sent
      #   # @xmpp.error "Houston, we have a problem"

      #   @xmpp   = Jabber::Simple.new( @options.server_xmpp_id, @options.server_xmpp_password )
      # end
    end  # }}}

    # @fn         def colorize color, message # {{{
    # @brief      The function colorize takes a message and wraps it into standard color commands such as for baih.
    #
    # @param      [String]    color     The colorname in plain english. e.g. "LightGray", "Gray", "Red", "BrightRed"
    # @param      [String]    message   The message which should be wrapped
    #
    # @return     [String]    Colorized message string
    #
    # @note       This might not work for your terminal
    #
    # Black       0;30     Dark Gray     1;30
    # Blue        0;34     Light Blue    1;34
    # Green       0;32     Light Green   1;32
    # Cyan        0;36     Light Cyan    1;36
    # Red         0;31     Light Red     1;31
    # Purple      0;35     Light Purple  1;35
    # Brown       0;33     Yellow        1;33
    # Light Gray  0;37     White         1;37
    #
    def colorize color, message 

      colors  = {
        "Gray"        => "\e[1;30m",
        "LightGray"   => "\e[0;37m",
        "Cyan"        => "\e[0;36m",
        "LightCyan"   => "\e[1;36m",
        "Blue"        => "\e[0;34m",
        "LightBlue"   => "\e[1;34m",
        "Green"       => "\e[0;32m",
        "LightGreen"  => "\e[1;32m",
        "Red"         => "\e[0;31m",
        "LightRed"    => "\e[1;31m",
        "Purple"      => "\e[0;35m",
        "LightPurple" => "\e[1;35m",
        "Brown"       => "\e[0;33m",
        "Yellow"      => "\e[1;33m",
        "White"       => "\e[1;37m",
        "NoColor"     => "\e[0m"
      }

      raise ArgumentError, "Function arguments cannot be nil" if( color.nil? or message.nil? )
      raise ArgumentError, "Unknown color" unless( colors.keys.include?( color ) )

      colors[ color ] + message + colors[ "NoColor" ]
    end # of def colorize }}}

    # @fn         def message level, msg, colorize = @options.colorize # {{{
    # @brief      The function message will take a message as argument as well as a level (e.g.
    #             "info", "ok", "error", "question", "debug") which then would print ( "(--) msg..", "(II)
    #             msg..", "(EE) msg..", "(??) msg..")
    #
    # @param      [Symbol]      level         Ruby symbol, can either be :info, :success, :error or :question
    # @param      [String]      msg           String, which represents the message you want to send to stdout (info, ok, question) stderr (error)
    #
    # Helpers: colorize
    #
    def message level, msg #, colorize = @options.colorize, silent = @options.silent

      # return if( silent )

      raise ArugmentError, "Can't find the corresponding symbol for this message level (#{level.to_s}) - is the spelling wrong?" unless( @symbols.key?( level )  )

      print = []

      output = ( level == :error ) ? ( "STDERR.puts" ) : ( "STDOUT.puts" )
      print << output
      print << "colorize(" if( @color )
      print << "\"" + @symbols[ level ].last + "\"," if( @color )
      print << "\"#{@symbols[ level ].first.to_s} #{msg.to_s}\""
      print << ")" if( @color )

      print.clear if( @silent )

      eval( print.join( " " ) )

      # # Send messages also to XMPP clients if activated and in level of interest
      # if( @options.xmpp )

      #   @options.client_xmpp_ids.each do |address|
      #     next unless( @xmpp_relevant.include?( level ) )

      #     @xmpp.deliver( address, @symbols[level].first.to_s + " " + msg.to_s )
      #   end
      # end

      # # Send messages also to AMQP queue if activated and in the level of interest
      # if( @options.amqp )

      #   EventMachine.next_tick do
      #     AMQP.channel ||= AMQP::Channel.new(AMQP.connection)

      #     # Durable -> http://rubydoc.info/github/ruby-amqp/amqp/master/AMQP/Channel
      #     AMQP.channel.queue("#{@options.amqp_server_routing_key_base.to_s}.logger", :durable => true)

      #     3.times do |i|
      #       puts "[auth][after_fork/amqp] Publishing a warmup message ##{i}"

      #       AMQP.channel.default_exchange.publish( @symbols[level].first.to_s + " " + msg.to_s, :routing_key => "#{@options.amqp_server_routing_key_base.to_s}.logger")
      #     end # of 3.times
      #   end # of EventMachine

      # end # of if( @options.amqp )

    end # of def message }}}

    attr_accessor :color, :silent

  end # of class Logger

end # of module ClothesNetwork


# vim:ts=2:tw=100:wm=100
