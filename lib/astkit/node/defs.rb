class AbstractSyntaxTreeKit
  class Node
    class DEFS < Node
      attr_reader :receiver, :name, :body

      def initialize(node:, receiver:, name:, body:)
        super(node)
        @receiver = receiver
        @name = name
        @body = body
      end
    end
  end
end
