class AbstractSyntaxTreeKit
  class Node
    class CONST < Node
      attr_reader :name

      def initialize(node:, name:)
        super(node)
        @name = name
      end
    end
  end
end
