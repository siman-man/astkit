class AbstractSyntaxTreeKit
  class Node
    class OR < Node
      attr_reader :left, :right

      def initialize(node:, left:, right:)
        super(node)
        @left = left
        @right = right
      end
    end
  end
end
