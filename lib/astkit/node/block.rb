class AbstractSyntaxTreeKit
  class Node
    class BLOCK < Node
      attr_reader :statements

      def initialize(node:, statements:)
        super(node)
        @statements = statements
      end
    end
  end
end
