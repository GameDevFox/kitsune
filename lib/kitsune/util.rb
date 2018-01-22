using Kitsune::Refine

module Kitsune
  module Util
    def self.hex_to_str(hex)
      [hex].pack('H*')
    end

    def self.str_to_hex(str)
      str.each_byte.map { |b| b.to_s(16).rjust(2, '0') }.join
    end

    def self.hexify(input)
      case input.class.to_s
        when 'Array'
          hexify_array input
        when 'Hash'
          hexify_hash input
        when 'String'
          input.to_hex
        else
          input
      end
    end

    def self.hexify_array(array)
      array.map { |x| hexify x }
    end

    def self.hexify_hash(hash)
      hash.map { |k, v| [k, hexify(v)] }.to_h
    end
  end
end
