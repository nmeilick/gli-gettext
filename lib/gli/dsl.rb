module GLI
  # The common DSL methods that exist between the top-level GLI
  # module and a command block
  module DSL
    # Describe the next switch, flag, or command.  This should be a
    # short, one-line description
    #
    # +description+:: A String of the short descripiton of the switch, flag, or command following
    def desc(description); @next_desc = description; end
    alias :d :desc

    # Provide a longer, more detailed description.  This
    # will be reformatted and wrapped to fit in the terminal's columns
    #
    # +long_desc+:: A String that is s longer description of the switch, flag, or command following.
    def long_desc(long_desc); @next_long_desc = long_desc; end

    # Describe the argument name of the next flag.  It's important to keep
    # this VERY short and, ideally, without any spaces (see Example).
    #
    # +name+:: A String that *briefly* describes the argument given to the following command or flag.
    #
    # Example:
    #     desc 'Set the filename'
    #     arg_name 'file_name'
    #     flag [:f,:filename]
    #
    # Produces:
    #     -f, --filename=file_name      Set the filename
    def arg_name(name); @next_arg_name = name; end

    # set the default value of the next flag
    #
    # +val+:: A String reprensenting the default value to be used for the following flag if the user doesn't specify one
    #         and, when using a config file, the config also doesn't specify one
    def default_value(val); @next_default_value = val; end

    # Create a flag, which is a switch that takes an argument
    #
    # +names+:: a String or Symbol, or an Array of String or Symbol that represent all the different names
    #           and aliases for this flag.
    #
    # Example:
    #
    #     desc 'Set the filename'
    #     flag [:f,:filename,'file-name']
    #
    # Produces:
    #
    #     -f, --filename, --file-name=arg     Set the filename
    def flag(*names)
      names = [names].flatten
      verify_unused(names,flags,switches,"in global options")
      flag = Flag.new(names,@next_desc,@next_arg_name,@next_default_value,@next_long_desc)
      flags[flag.name] = flag
      clear_nexts
    end
    alias :f :flag

    # Create a switch, which is a command line flag that takes no arguments (thus, it _switches_ something on)
    #
    # +names+:: a String or Symbol, or an Array of String or Symbol that represent all the different names
    #           and aliases for this switch.
    def switch(*names)
      names = [names].flatten
      verify_unused(names,flags,switches,"in global options")
      switch = Switch.new(names,@next_desc,@next_long_desc)
      switches[switch.name] = switch
      clear_nexts
    end
    alias :s :switch

    def clear_nexts # :nodoc:
      @next_desc = nil
      @next_arg_name = nil
      @next_default_value = nil
      @next_long_desc = nil
    end

    private
    # Checks that the names passed in have not been used in another flag or option
    def verify_unused(names,flags,switches,context) # :nodoc:
      names.each do |name|
        verify_unused_in_option(name,flags,"flag",context)
        verify_unused_in_option(name,switches,"switch",context)
      end
    end

    def verify_unused_in_option(name,option_like,type,context) # :nodoc:
      raise ArgumentError.new("#{name} has already been specified as a #{type} #{context}") if option_like[name]
      option_like.each do |one_option_name,one_option|
        if one_option.aliases
          raise ArgumentError.new("#{name} has already been specified as an alias of #{type} #{one_option_name} #{context}") if one_option.aliases.include? name
        end
      end
    end

  end
end