module Kitsune
  module Nodes

    # TODO: Move these into a graph with names

    # Nodes
    INDEX_BASE_HASH = "\x9E\xBC~~7\xA2b\xEE\xD9\xF5\x0E\xB0\xE2\x06u\xDBC\xFDo\xA2Bm\x7F}VS\xD5EI\x04\x84\x14"

    # Groups
    # ALL_NODES = "3A\x88\x82\agU\xBE\x8B\xAAts\xF5\xB4\x10G\xB9\x86\xF5#\xC5q\"\xCD\xB3@Q\xCC\x00\x19\x0E\xC6"
    BI_DIRECTIONAL_PATHS = "\xA0\xEA\x7F\xF7\xE6\xA5\xEE\xDC\xA8j\xF7\x04\xF7\x02{\\\x9EQ\xD1%\x8Ev\x1Fe\x8D\xE2b*\xA2\xAC\r1"
      # All child paths of this node are bi-directional
      # Example: When SIBLING is a child of BI_DIRECTIONAL_PATH, and
      #               BROTHER >SIBLING> SISTER is defined, then
      #               SISTER >SIBLING> BROTHER is logically defined

    # Edge Paths
    HEAD = "\x14\x1C\x87\x9B#h\x97S`y\xFC\x82\xD5]\xF6\xB8\x8D\x10\xC3\x03\x12/\x9B\xF0E}O\x14\xF7\x99\xB5w"
    TAIL = "\xC48\xA0\xF9\xDE\xE8q\xF9Z\xB7\x01\xE0/\xFA\x92i\"{pbO1\nh\nV\x8D\x891\x9FA{"
    # HEAD_EDGE = ''
    # TAIL_EDGE = ''
    # EDGE_HEAD = ''
    # EDGE_TAIL = ''

    # Paths
    # SELF = '' # Example: HEAD + TAIL = SELF (for a single edge relationship)
    INVERSE_PATH = "!\x8B\xEE\f\x92\xDE\xCB\xCF\x913\xE6\xA6'\x01\x8C\xF3\xE7D\x8C>\x18\x15\x1A\xF8 2\xD8\x19b\xBB0\x15"
      # A references to inverse path for this path (Note: This path is BI-DIRECTIONAL [see above])
      # Example: When PARENT >INVERSE_PATH> CHILD is defined, and
      #               ADAM >FATHER> ABEL is defined, then
      #               ABEL >CHILD> ADAM is logically defined
    BI_DIRECTIONAL_GROUP = "\xF7\x11\x9Au\x93)(b\ea\xBD\xE3\xEF\xAA>\xE3\xA02P\x9A\xA4a\xA9v\xA5\x15Z\xDC\x95V\aO"
      # All child nodes of this node are group nodes. All children of these group nodes have a logical bi-direactional
      # relationship to each other

  end
end
