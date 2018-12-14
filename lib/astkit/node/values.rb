class AbstractSyntaxTreeKit
  class Node
    class VALUES < Node
      attr_reader :elements

      def initialize(node:, elements:)
        super(node)
        @elements = elements
      end
    end
  end
end
