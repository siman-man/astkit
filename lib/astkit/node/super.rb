class AbstractSyntaxTreeKit
  class Node
    class SUPER < Node
      attr_reader :arguments

      def initialize(node:, arguments:)
        super(node)
        @arguments = arguments
      end
    end
  end
end
