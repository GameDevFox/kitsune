class String
  def incr(count = 1)
    Kitsune::Util.incr_str self, count
  end

  def to_hex
    Kitsune::Util.str_to_hex self
  end
end
