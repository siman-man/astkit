class AbstractSyntaxTreeKit
  class Node
    class OP_CDECL < Node
      attr_reader :namespace, :operator, :value

      def initialize(node:, namespace:, operator:, value:)
        super(node)
        @namespace = namespace
        @operator = operator
        @value = value
      end
    end
  end
end
