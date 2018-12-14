class AbstractSyntaxTreeKit
  class Node
    class OP_ASGN_OR < Node
      attr_reader :variable, :value

      def initialize(node:, variable:, value:)
        super(node)
        @variable = variable
        @value = value
      end
    end
  end
end
