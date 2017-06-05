require 'digest/sha2'
require 'jose'

module Kitsune
  module Hash
    def self.sha256_hash(key)
      Digest::SHA256.digest key
    end

    def self.chain_hash(key, size: 32, index: 0)
      hash = sha256_hash key
      hash = hash.incr index

      JOSE::JWA::SHA3.shake256(hash, size)
    end
  end
end
