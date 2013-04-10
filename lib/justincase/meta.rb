module JustInCase
  module Meta
    VERSION = '0.0.0'

    def self.date_string
      Time.now.strftime("%Y-%m-%d")
    end
  end
end
