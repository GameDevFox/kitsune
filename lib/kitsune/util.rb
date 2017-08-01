module Kitsune
  module Util
    def self.binary_op(op, a, b)
      a_int = a.respond_to?(:bytes) ? a.bytes.to_i : a.to_i
      b_int = b.respond_to?(:bytes) ? b.bytes.to_i : b.to_i

      a_int.send(op, b_int).to_a
    end

    def self.str_to_hex(str)
      str.each_byte.map { |b| b.to_s(16).rjust(2, '0') }.join
    end
  end
end
