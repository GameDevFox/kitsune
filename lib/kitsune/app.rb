class Kitsune::App

  def initialize(edges)
    @edges = edges

    @system_cache = {}
  end

  def resolve(system_id)
    return @system_cache[system_id] if @system_cache.has_key? system_id

    system = case system_id
      when 'hello'
        proc { 'world' }
      when 'goodbye'
        proc { 'moon' }
      when '456f47d1ebec9fdbf64cf941dd399c36c06e24e71014a08cd6dd67ca03d44966' +
           '1d24dedc2d1655910a4d2e1bac34e6d5648b7699ca30f3021049c53b78b7bc85'.from_hex
        proc {
          Random.new.bytes 64
        }
      when 'ea961077cb5326469431eedf200ebbb44b713ab5b866e338d79275a243cdf7a4' +
           'f49e32e6719c86aba2836f509e835ee759334176ab61de7a4837da134113aa96'.from_hex
        proc { |input|
          input.to_hex
        }
      else
        nil #proc { 'none' }
    end

    @system_cache[system_id] = system
  end
end
