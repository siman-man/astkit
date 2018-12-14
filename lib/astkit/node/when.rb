class AbstractSyntaxTreeKit
  class Node
    class WHEN < Node
      attr_reader :expressions, :body, :els

      def initialize(node:, expressions:, body:, els: nil)
        super(node)
        @expressions = expressions
        @body = body
        @els = els
      end
    end
  end
end
