class AbstractSyntaxTreeKit
  class Node
    class NIL < Node
      attr_reader :value

      def initialize(node:)
        super(node)
        @value = nil
      end
    end
  end
end
