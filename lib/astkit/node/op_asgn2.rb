class AbstractSyntaxTreeKit
  class Node
    class OP_ASGN2 < Node
      attr_reader :receiver, :operator, :index, :value

      def initialize(node:, receiver:, operator:, index:, value:)
        super(node)
        @receiver = receiver
        @operator = operator
        @index = index
        @value = value
      end
    end
  end
end
