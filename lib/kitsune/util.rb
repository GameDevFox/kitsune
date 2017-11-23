module Kitsune
  module Util
    def self.hex_to_str(hex)
      [hex].pack('H*')
    end

    def self.str_to_hex(str)
      str.each_byte.map { |b| b.to_s(16).rjust(2, '0') }.join.force_encoding(Encoding::ASCII_8BIT)
    end
  end
end
