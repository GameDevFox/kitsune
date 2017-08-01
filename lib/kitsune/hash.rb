require 'digest/sha2'
require 'jose'

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

    def self.compound_hash(list)
      result = "\x01"

      count = 0
      list.each do |item|
        # First sha the item
        item_hash = sha256(item)
        idx_hash = index_hash count

        # Make sure to trim the result to 32 bytes
        rotated_item_hash = item_hash.binary_add(idx_hash).slice(0...32)
        result = result.binary_mul(rotated_item_hash).slice(0...32)

        count += 1
      end

      result
    end

    def self.chain_hash(key, size: 32, index: 0)
      hash = sha256 key
      hash = hash.binary_add index

      JOSE::JWA::SHA3.shake256(hash, size)
    end
  end
end
