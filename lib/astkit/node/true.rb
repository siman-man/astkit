class AbstractSyntaxTreeKit
  class Node
    class TRUE < Node
      attr_reader :value

      def initialize(node:)
        super(node)
        @value = true
      end
    end
  end
end
