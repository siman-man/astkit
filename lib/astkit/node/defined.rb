class AbstractSyntaxTreeKit
  class Node
    class DEFINED < Node
      attr_reader :expression

      def initialize(node:, expression:)
        super(node)
        @expression = expression
      end
    end
  end
end
