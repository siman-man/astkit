class AbstractSyntaxTreeKit
  class Node
    class UNTIL < Node
      attr_reader :condition, :body

      def initialize(node:, condition:, body:)
        super(node)
        @condition = condition
        @body = body
      end
    end
  end
end
