require 'thor'

class Thor
  class << self

    protected

      # here I add 'rescue ArgumentError => e', to avoid ugly error messages
      def normalize_command_name(meth)
        return default_command.to_s.gsub('-', '_') unless meth

        possibilities = find_command_possibilities(meth)
        if possibilities.size > 1
          raise ArgumentError, "Ambiguous command #{meth} matches [#{possibilities.join(', ')}]"
        elsif possibilities.size < 1
          meth = meth || default_command
        elsif map[meth]
          meth = map[meth]
        else
          meth = possibilities.first
        end

        meth.to_s.gsub('-','_') # treat foo-bar as foo_bar
      rescue ArgumentError => e
        # do nothing
      end
      alias normalize_task_name normalize_command_name
  end
end
