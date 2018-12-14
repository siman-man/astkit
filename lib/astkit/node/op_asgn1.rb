class AbstractSyntaxTreeKit
  class Node
    class OP_ASGN1 < Node
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
