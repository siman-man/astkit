class AbstractSyntaxTreeKit
  class Node
    class MATCH2 < Node
      attr_reader :regexp, :string

      def initialize(node:, regexp:, string:)
        super(node)
        @regexp = regexp
        @string = string
      end
    end
  end
end
