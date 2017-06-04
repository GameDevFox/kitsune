module Kitsune
  module Util
    def self.incr_array(array, count = 1)
      i = 0
      loop do
        initial = array[i] || 0
        incr = initial + count
        quotient = incr / 256
        rem = incr % 256
        array[i] = rem

        break if quotient == 0
        i += 1
        count = quotient
      end
      array
    end

    def self.incr_str(str, count = 1)
      result = incr_array str.bytes, count
      result.pack 'c*'
    end

    def self.str_to_hex(str)
      str.each_byte.map { |b| b.to_s(16).rjust(2, '0') }.join
    end
  end
end
