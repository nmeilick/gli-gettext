if not defined?(GetText)
  # If gettext is not loaded, create a GetText class with the
  # most important methods.
  module GetText
    # Return the given argument unchanged
    def gettext(text)
      text
    end
    alias :_ :gettext

    # Return singular or plural, depending on num
    def ngettext(singular, plural, num)
      (num==1) ? _(singular) : _(plural)
    end
    alias :n_ :ngettext

    # bindtextdomain does nothing
    def bindtextdomain(*args)
    end
 
    module LocalePath
      def self.method_missing(*args)
        nil
      end
    end
  end

  class String
    # Allow parametrization via hash
    alias :_old_format_m :%
    def %(args)
      if args.kind_of?(Hash)
        ret = dup
        args.each {|key, value|
          ret.gsub!(/\%\{#{key}\}/) { value.to_s }
        }
        ret
      else
        ret = gsub(/%\{/, '%%{')
        begin
          ret._old_format_m(args)
        rescue ArgumentError
          $stderr.puts "  The string:#{ret}"
          $stderr.puts "  args:#{args.inspect}"
        end
      end
    end
  end
end

module GLI
  include GetText

  def initialize_i18n(*paths)
    # Add paths to be searched by gettext
    paths.flatten.uniq.compact.each do
      |path|
      LocalePath.add_default_rule(File.expand_path(path))
    end
  end
end

# Bind to textdomains
if respond_to?(:bindtextdomain)
  bindtextdomain "gli-lib"
elsif GetText.respond_to?(:bindtextdomain)
  GetText.bindtextdomain "gli-lib"
end

