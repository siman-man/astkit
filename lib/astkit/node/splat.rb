class AbstractSyntaxTreeKit
  class Node
    class SPLAT < Node
      attr_reader :element

      def initialize(node:, element:)
        super(node)
        @element = element
      end
    end
  end
end
