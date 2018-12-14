class AbstractSyntaxTreeKit
  class Node
    class ENSURE < Node
      attr_reader :body, :clause

      def initialize(node:, body:, clause:)
        super(node)
        @body = body
        @clause = clause
      end
    end
  end
end
