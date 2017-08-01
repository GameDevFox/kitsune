module Kitsune
  module BinaryOps
    def binary_add(value)
      binary_op :+, value
    end

    def binary_inc
      binary_op :+, 1
    end

    def binary_mul(value)
      binary_op :*, value
    end
  end
end

class String
  include Kitsune::BinaryOps

  def binary_op(op, value)
    result = Kitsune::Util.binary_op op, self, value
    result.pack 'c*'
  end

  def to_hex
    Kitsune::Util.str_to_hex self
  end
end

class Array
  include Kitsune::BinaryOps

  def binary_op(op, value)
    Kitsune::Util.binary_op op, self, value
  end

  def to_i(radix = 256)
    result = 0
    exponent = 1

    each do |x|
      result += x * exponent
      exponent *= radix
    end
    result
  end
end

class Integer
  def to_a(radix = 256)
    result = []
    value = self

    count = 0
    while value > 0
      result[count] = value % radix
      value /= radix
      count += 1
    end
    result
  end
end
