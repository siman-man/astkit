class AbstractSyntaxTreeKit
  class Node
    class FALSE < Node
      attr_reader :value

      def initialize(node:)
        super(node)
        @value = false
      end
    end
  end
end
