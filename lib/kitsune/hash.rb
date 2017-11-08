require 'digest/sha2'

module Kitsune
  module Hash
    include Kitsune::Nodes

    def self.sha256(key)
      Digest::SHA256.digest key
    end

    def self.index_hash(index)
      hash = INDEX_BASE_HASH
      while index > 0 do
        hash = sha256 hash
        index -= 1
      end
      return hash
    end

    def self.list_hash(list)
      list.each { |x| x.force_encoding 'ascii-8bit' }
      sha256 list.join
    end

    def self.chain_hash(key, index: 0)
      hash = sha256 key
      hash = hash.binary_add index

      sha256 hash
    end
  end
end
