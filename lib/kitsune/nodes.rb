using Kitsune::Refine

module Kitsune::Nodes
  # CORE
  WRITE = '3a8a50cb200251b649ad073eb91239d1cab6e70398e87e741749b9e229b47471'
  READ = '4e4e808fc516be7fb4fa7c6901c02e4605aa45140407ddbef1e169eb3de1e824'

  CREATE = '49369fe57696b74814470afd8d894ffe1592a46bea2634b562233e328641f3ea'
  DESTROY= '10f8fb2e0fa438f981eebe4eff64ac846cf8308a5c8dfe4acdfd976334bf8929'

  LIST_V = '83cb31feb28ee20b9c371d4a1b6acb2f0ae2b6ba9b60c95b43356056f9cf6af8'
  HAS = '3fd1c461fc3c83c9804332c6cd3848a9ae5f1bbe3052bf44678ce4ba02540b80'
  COUNT = '41d4b936854fc6f197ed309a9ea85cdd7b2fb9b6234573e7e5da6613b51d739f'
  SEARCH = '29492b05182ceb3af04e7fab6b4e7d89e17a771ea8eb80fcabe1e43af616c762'

  HEAD = '141c879b236897536079fc82d55df6b88d10c303122f9bf0457d4f14f799b577'
  TAIL = 'c438a0f9dee871f95ab701e02ffa9269227b70624f310a680a568d89319f417b'

  NAME = '05f2f484be00a9e2985693f15595ff4328333eb25c5208c41c97ae80c41858f7'

  RANDOM_NODE_ID = '456f47d1ebec9fdbf64cf941dd399c36c06e24e71014a08cd6dd67ca03d44966'

  ADD = WRITE
  GET = READ
  DELETE = DESTROY
  REMOVE = DESTROY

  CONTAINS = HAS

  RANDOM = RANDOM_NODE_ID

  # VALUES
  NULL = '0000000000000000000000000000000000000000000000000000000000000000'
  BOOLEAN = 'c7e5370d50434047b1f5a8f2556127273d7e8545256fac53b3d39f303b37d5fd'
    TRUE = NULL
    FALSE = '0000000000000000000000000000000000000000000000000000000000000001'
  INTEGER = 'b22c550969ed34f3bc8cb2378319e4cb8bd41a83d1fce289d6eea5ce42c8dd4d'
    ZERO = NULL
  STRING = '7c696d224904c23efa8c7d85a1af6de18cfa8d09d7d84364cc73c4789a763002'

  # DATA TYPES
  NODE = 'a1a0c49b6ac37cfc02ac4b13aaa41425f78f1fc5b8afd0679631ab1c5eafcc84'
  EDGE = 'f4d78e491c46f49090331ca39fc9defe84c7c6269045f5a9e267fde83473a5ad'
  RELATION = '083736cc092975b710972678485f9bbd045c1cb932973bca0cec06675ee8cb96'
  GROUP = '3c37eca43ed69915f41039515b15c779f5ad697ee7771132e14bb04be9361bd9'
  LIST_N = '074b82f559d0bdc0bd23b4ee6ef50b4ff055f53de066a6bfc67e470417d9d2bd'
  CHAIN = LIST_N

  # DATA CONVERSION COMMANDS
  TO_JSON = '2d3525e869f5884c5a2e9fe3e0fa90bd314cc63684f179efe7b9dab929a24b01'
  TO_HEX = 'ea961077cb5326469431eedf200ebbb44b713ab5b866e338d79275a243cdf7a4'
  FROM_HEX = 'f9fcaf4b0230ad99499fd5ce154a2307ce53e4edbc67b9f606bfe0aea5e9de18'
  HEXIFY = '7cae2fe2935c033306bda9e2eaf4031dea290f880122dc022559cf73c30b2bc8'

  # SYSTEM COMMANDS
  SYSTEM = '08e3e9633a82066b242bd191406d0551d18d5f108757770f890f9ff7b36bbd59'
  COMMAND = 'dad86fc739936ac293810ae566437862ae3f7424e47a649a7432ac85b0478bf4'
  SUPPORTED = '221d0ff78a91f544c2c536f789d522788a9eb29f637e847385bceae1b91d2a15'
  REQUIRED = '0e7984f458ec676a68704b429af2d548016b5539d8b8f7296cc54f1ae1cc77de'

  # PLATFORMS
  RUBY = '8608cdfe700811ba86feed8e47ccda347f2b63fe0f505e643e30e7f4c759d0bc'
  ECMA_SCRIPT = '19b49d37b96541b3098ac4e33e5dab86b3612021cb33d708dbed62765a468542'
  C = '4e5498f104245513fa53e27befcc15e20388542db80b2f499c7cdbf14b6f9936'
  JAVA = '2ec4bea3ab4e76986a002e8c26219a3fda15d1657d0759751db057a8a8b649cd'

  JAVA_SCRIPT = ECMA_SCRIPT

  # Groups
  BI_DIRECTIONAL_PATHS = 'a0ea7ff7e6a5eedca86af704f7027b5c9e51d1258e761f658de2622aa2ac0d31'
    # All child paths of this node are bi-directional
    # Example: When SIBLING is a child of BI_DIRECTIONAL_PATH, and
    #               BROTHER >SIBLING> SISTER is defined, then
    #               SISTER >SIBLING> BROTHER is logically defined

  # Paths
  # SELF = '' # Example: HEAD + TAIL = SELF (for a single edge relationship)
  INVERSE_PATH = '218bee0c92decbcf9133e6a627018cf3e7448c3e18151af82032d81962bb3015'
    # A references to inverse path for this path (Note: This path is BI-DIRECTIONAL [see above])
    # Example: When PARENT >INVERSE_PATH> CHILD is defined, and
    #               ADAM >FATHER> ABEL is defined, then
    #               ABEL >CHILD> ADAM is logically defined
  BI_DIRECTIONAL_GROUP = 'f7119a75932928621b61bde3efaa3ee3a032509aa461a976a5155adc9556074f'
    # All child nodes of this node are group nodes. All children of these group nodes have a logical bi-direactional
    # relationship to each other

  # Testing
  ALPHA = '5b30d9dffff167e3a503408972e3df5077ab1128a626e2e9c24e5ad79fe6aa06'
  BETA = '1c9f6aa7e4cdc3f6cfb25eac6b9bcf2a70f1cc95e5cd7145f7ec068965696573'
  DELTA = '35ad52fc549ed5278d6e132a4f837292b122092ece38df27eb59ada8ae5cb924'
  THETA = '2204d8c586f07506e4c2bbe5250f0f2da18671b9824897f9a28e9bf4c8cd74de'
  OMEGA = '621257ebe9df935a2b3f0d41179b1a80fb62b18337e9fc3840a22f09e313db25'

  # Misc
  INITIALIZE = 'bc397c85ae19f69eb4c9f166885585d23e0691dd51d34cf7ad1667b2ad4dd8cb'
  IS_INITIALIZED = 'a0ea3db8883f86ee383921a54b7a9cdb1eda10fcb6d362f95a8121eb9c629643'

  EN_US_DICT = '00c8ea2a1b79bdd9952564fd159b6ee2071ecfdfebbf1e995a01bc3fa63e582a'

  HELLO_WORLD = 'fb24c4e015fcc1cd2eab97085a2283960640cb5d4bdac20c681e7d71f653835f'
  WRITE_LINE_STDOUT = '1390e7790f3ee96720d7cfe393b595b84508393a337f7154d35bb2ccfc85738e'

  PLATFORM = '5059bd8f7fe72751860914fef7262d524ee398e3667fa9b794161f9e3b76974c'
  CODE = 'ba117ebd672acc46841829733283de63e8bfb6b0763ee202b4c1bbaf0a4ad119'
  TYPE = '046a6f127fb3d910ddc67fbfbe7feb28f46f2fa240fc3699f7b11b33976b4bff'
  GRAPH = 'c2b1b7190693475195604473803f837865bd2d730895abd9d2d93bb3bf9988cd'

  INPUT = 'e84f12155f8e3351b06942e62801a202de1164fcc895b8b844998f3dcf1a2e10'
  OUTPUT = '0395ac61656e89334f103ba0205f9314439b5276350564294264a65beb6d1b16'

  STD_OUT = 'e03d1823fdf225a3de2123cf004e07b3fc48dc52c145c8ff61b53518ab180fab'

  INIT = INITIALIZE

  def self.name_nodes(system)
    # TODO: Move this to a system and configure it for logging
    puts ''
    self.constants.each { |const|
      name = const.to_s.downcase
      node = self.const_get const
      puts "#{name} => #{node}"
      system.execute ~[WRITE, NAME], { node: node, name: name }
    }
    puts ''
  end
end
