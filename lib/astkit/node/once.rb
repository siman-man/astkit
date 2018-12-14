class AbstractSyntaxTreeKit
  class Node
    class ONCE < Node
      attr_reader :body

      def initialize(node:, body:)
        super(node)
        @body = body
      end
    end
  end
end
