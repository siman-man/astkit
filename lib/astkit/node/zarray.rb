class AbstractSyntaxTreeKit
  class Node
    class ZARRAY < Node
      attr_reader :value

      def initialize(node:)
        super(node)
        @value = []
      end
    end
  end
end
