class AbstractSyntaxTreeKit
  class Node
    class CLASS < Node
      attr_reader :path, :superclass, :body

      def initialize(node:, path:, superclass:, body:)
        super(node)
        @path = path
        @superclass = superclass
        @body = body
      end
    end
  end
end
