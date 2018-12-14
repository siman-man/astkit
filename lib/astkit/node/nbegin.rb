class AbstractSyntaxTreeKit
  class Node
    class NBEGIN < Node
      attr_reader :body

      def initialize(node:, body:)
        super(node)
        @body = body
      end
    end
  end
end
