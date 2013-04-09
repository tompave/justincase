module JustInCase
  module Meta
    VERSION = '0.0.0'

    def self.date_string
      Time.now.strftime("%d-%m-%Y")
    end
  end
end
