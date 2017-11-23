module Kitsune::Refine
  refine String do
    def ~
      Kitsune::Hash.sha256 self
    end

    def from_hex
      Kitsune::Util.hex_to_str self
    end

    def to_hex
      Kitsune::Util.str_to_hex self
    end
  end

  refine Array do
    def ~
      Kitsune::Hash.edge_hash self
    end

    def **(type)
      type_str = type.to_s
      sym = "#{type_str}_hash".to_sym
      Kitsune::Hash.send sym, self
    end
  end
end
