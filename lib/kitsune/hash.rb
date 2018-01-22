require 'digest/sha2'

using Kitsune::Refine

module Kitsune::Hash
  include Kitsune::Nodes

  def self.sha256(key)
    Digest::SHA256.digest key
  end

  def self.hash_list(list)
    b_list = list.map { |item| item.from_hex }
    b_hash = sha256 b_list.join
    b_hash.to_hex
  end

  def self.hash_type(type, list)
    hash_list([type] + list)
  end

  def self.edge_hash(edge)
    norm_edge = edge[0..1].map { |x| x.class == Array ? edge_hash(x) : x }
    hash_type EDGE, norm_edge
  end

  def self.group_hash(group)
    hash_type GROUP, group.sort
  end

  def self.list_hash(list)
    hash_type LIST, list
  end
end
