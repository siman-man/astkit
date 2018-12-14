class AbstractSyntaxTreeKit
  class Node
    class STR < Node
      attr_reader :value

      def initialize(node:, value:)
        super(node)
        @value = value
      end
    end
  end
end
