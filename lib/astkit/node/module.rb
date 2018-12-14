class AbstractSyntaxTreeKit
  class Node
    class MODULE < Node
      attr_reader :path, :body

      def initialize(node:, path:, body:)
        super(node)
        @path = path
        @body = body
      end
    end
  end
end
