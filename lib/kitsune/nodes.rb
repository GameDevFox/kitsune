using Kitsune::Refine

module Kitsune::Nodes
  MAIN_DICT = '00c8ea2a1b79bdd9952564fd159b6ee2071ecfdfebbf1e995a01bc3fa63e582a'.from_hex

  HELLO_WORLD = 'fb24c4e015fcc1cd2eab97085a2283960640cb5d4bdac20c681e7d71f653835f'.from_hex
  WRITE_LINE_STDOUT = '1390e7790f3ee96720d7cfe393b595b84508393a337f7154d35bb2ccfc85738e'.from_hex

  PLATFORM = '5059bd8f7fe72751860914fef7262d524ee398e3667fa9b794161f9e3b76974c'.from_hex
  CODER = '666ba3c4e3a7b0ef2e3859d40f5f337117ab6ea68a305469f20bd18a56a581e6'.from_hex

  # CORE
  NAME = '05f2f484be00a9e2985693f15595ff4328333eb25c5208c41c97ae80c41858f7'.from_hex
  RANDOM_NODE_ID = '456f47d1ebec9fdbf64cf941dd399c36c06e24e71014a08cd6dd67ca03d44966'.from_hex

  # DATA TYPES
  NODE = 'a1a0c49b6ac37cfc02ac4b13aaa41425f78f1fc5b8afd0679631ab1c5eafcc84'.from_hex
  EDGE = 'f4d78e491c46f49090331ca39fc9defe84c7c6269045f5a9e267fde83473a5ad'.from_hex
  RELATION = '083736cc092975b710972678485f9bbd045c1cb932973bca0cec06675ee8cb96'.from_hex
  GROUP = '3c37eca43ed69915f41039515b15c779f5ad697ee7771132e14bb04be9361bd9'.from_hex
  CHAIN = '074b82f559d0bdc0bd23b4ee6ef50b4ff055f53de066a6bfc67e470417d9d2bd'.from_hex

  STRING = '7c696d224904c23efa8c7d85a1af6de18cfa8d09d7d84364cc73c4789a763002'.from_hex

  # STRING COMMANDS
  TO_JSON = '2d3525e869f5884c5a2e9fe3e0fa90bd314cc63684f179efe7b9dab929a24b01'.from_hex
  TO_HEX = 'ea961077cb5326469431eedf200ebbb44b713ab5b866e338d79275a243cdf7a4'.from_hex
  FROM_HEX = 'f9fcaf4b0230ad99499fd5ce154a2307ce53e4edbc67b9f606bfe0aea5e9de18'.from_hex

  # SYSTEM COMMANDS
  SYSTEM = '08e3e9633a82066b242bd191406d0551d18d5f108757770f890f9ff7b36bbd59'.from_hex
  COMMAND = 'dad86fc739936ac293810ae566437862ae3f7424e47a649a7432ac85b0478bf4'.from_hex
  SUPPORTED = '221d0ff78a91f544c2c536f789d522788a9eb29f637e847385bceae1b91d2a15'.from_hex
  REQUIRED = '0e7984f458ec676a68704b429af2d548016b5539d8b8f7296cc54f1ae1cc77de'.from_hex

  # GENERIC COMMANDS
  WRITE = '3a8a50cb200251b649ad073eb91239d1cab6e70398e87e741749b9e229b47471'.from_hex
  READ = '4e4e808fc516be7fb4fa7c6901c02e4605aa45140407ddbef1e169eb3de1e824'.from_hex
  DELETE = '10f8fb2e0fa438f981eebe4eff64ac846cf8308a5c8dfe4acdfd976334bf8929'.from_hex

  ADD = WRITE
  GET = READ
  REMOVE = DELETE

  LIST = '83cb31feb28ee20b9c371d4a1b6acb2f0ae2b6ba9b60c95b43356056f9cf6af8'.from_hex
  HAS = '3fd1c461fc3c83c9804332c6cd3848a9ae5f1bbe3052bf44678ce4ba02540b80'.from_hex
  COUNT = '41d4b936854fc6f197ed309a9ea85cdd7b2fb9b6234573e7e5da6613b51d739f'.from_hex
  SEARCH = '29492b05182ceb3af04e7fab6b4e7d89e17a771ea8eb80fcabe1e43af616c762'.from_hex

  # PLATFORMS
  RUBY = '8608cdfe700811ba86feed8e47ccda347f2b63fe0f505e643e30e7f4c759d0bc'.from_hex
  ECMA_SCRIPT = '19b49d37b96541b3098ac4e33e5dab86b3612021cb33d708dbed62765a468542'.from_hex
  C = '4e5498f104245513fa53e27befcc15e20388542db80b2f499c7cdbf14b6f9936'.from_hex
  JAVA = '2ec4bea3ab4e76986a002e8c26219a3fda15d1657d0759751db057a8a8b649cd'.from_hex

  # Groups
  BI_DIRECTIONAL_PATHS = 'a0ea7ff7e6a5eedca86af704f7027b5c9e51d1258e761f658de2622aa2ac0d31'.from_hex
    # All child paths of this node are bi-directional
    # Example: When SIBLING is a child of BI_DIRECTIONAL_PATH, and
    #               BROTHER >SIBLING> SISTER is defined, then
    #               SISTER >SIBLING> BROTHER is logically defined

  # Edge Paths
  HEAD = '141c879b236897536079fc82d55df6b88d10c303122f9bf0457d4f14f799b577'.from_hex
  TAIL = 'c438a0f9dee871f95ab701e02ffa9269227b70624f310a680a568d89319f417b'.from_hex

  # Paths
  # SELF = '' # Example: HEAD + TAIL = SELF (for a single edge relationship)
  INVERSE_PATH = '218bee0c92decbcf9133e6a627018cf3e7448c3e18151af82032d81962bb3015'.from_hex
    # A references to inverse path for this path (Note: This path is BI-DIRECTIONAL [see above])
    # Example: When PARENT >INVERSE_PATH> CHILD is defined, and
    #               ADAM >FATHER> ABEL is defined, then
    #               ABEL >CHILD> ADAM is logically defined
  BI_DIRECTIONAL_GROUP = 'f7119a75932928621b61bde3efaa3ee3a032509aa461a976a5155adc9556074f'.from_hex
    # All child nodes of this node are group nodes. All children of these group nodes have a logical bi-direactional
    # relationship to each other
end
