class AbstractSyntaxTreeKit
  class Node
    attr_reader :condition, :body, :els

    class IF < Node
      def initialize(node:, condition:, body:, els:)
        super(node)
        @condition = condition
        @body = body
        @els = els
      end
    end
  end
end
