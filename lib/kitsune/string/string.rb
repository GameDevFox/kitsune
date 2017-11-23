using Kitsune::Refine

module Kitsune::String
  class System
    include Kitsune::Nodes
    include Kitsune::System

    def self.init(db)
      db.execute <<~EOF
        CREATE TABLE strings (
          hash VARCHAR(32) PRIMARY KEY,
          string TEXT
        );
      EOF
    end

    def initialize(db)
      db.results_as_hash = true

      @read_string = db.prepare 'SELECT string FROM strings WHERE hash = :hash;'
      @read_hash = db.prepare 'SELECT hash FROM strings WHERE string = :string;'

      @write = db.prepare 'INSERT INTO strings (hash, string) VALUES (:hash, :string);'
    end

    command ~[READ, STRING] do |hash|
      result = @read_string.execute({ hash: hash })
      result.next&.dig('string')
    end

    command ~[WRITE, STRING] do |string|
      result = @read_hash.execute({ string: string })
      hash = result.next&.dig('hash')

      unless hash
        hash = Kitsune::Hash.sha256 string
        @write.execute({ hash: hash, string: string })
      end

      hash
    end
  end
end
