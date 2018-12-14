class AbstractSyntaxTreeKit
  class Node
    class FOR < Node
      attr_reader :receiver, :body

      def initialize(node:, receiver:, body:)
        super(node)
        @receiver = receiver
        @body = body
      end
    end
  end
end
