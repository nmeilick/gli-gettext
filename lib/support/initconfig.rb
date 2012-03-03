require 'gli'
require 'gli/command'
require 'yaml'

module GLI
  class InitConfig < Command # :nodoc:
    COMMANDS_KEY = 'commands'

    def initialize(config_file_name)
      @filename = config_file_name
      super(:initconfig, _("Initialize the config file using current global options"), nil, _('Initializes a configuration file where you can set default options for command line flags, both globally and on a per-command basis.  These defaults override the built-in defaults and allow you to omit commonly-used command line flags when invoking this program'))

      self.desc _('force overwrite of existing config file')
      self.switch :force
    end

    def execute(global_options,options,arguments)
      if options[:force] || !File.exist?(@filename)
        config = global_options
        config[COMMANDS_KEY] = {}
        GLI.commands.each do |name,command|
          if (command != self) && (name != :rdoc) && (name != :help)
            config[COMMANDS_KEY][name.to_sym] = {} if command != self
          end
        end
        File.open(@filename,'w', 0600) do |file|
          YAML.dump(config,file)
        end
      else
        raise _("Not overwriting existing config file %{file}, use --force to override") % { :file => @filename }
      end
    end
  end
end
