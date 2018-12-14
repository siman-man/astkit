class AbstractSyntaxTreeKit
  class Node
    class RESCUE < Node
      attr_reader :body, :rescue_body, :else_body

      def initialize(node:, body:, rescue_body:, else_body:)
        super(node)
        @body = body
        @rescue_body = rescue_body
        @else_body = else_body
      end
    end
  end
end
