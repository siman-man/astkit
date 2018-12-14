class AbstractSyntaxTreeKit
  class Node
    class AND < Node
      attr_reader :left, :right

      def initialize(node:, left:, right:)
        super(node)
        @left = left
        @right = right
      end
    end
  end
end
