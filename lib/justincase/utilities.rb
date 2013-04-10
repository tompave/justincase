module JustInCase
  module Utilities
  end
end

class Hash
  # taken from:
  # http://api.rubyonrails.org/classes/Hash.html#method-i-symbolize_keys-21
  def symbolize_keys!
    keys.each do |key|
      self[(key.to_sym rescue key) || key] = delete(key)
    end
    self
  end
end