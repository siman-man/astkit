class AbstractSyntaxTreeKit
  class Node
    class GVAR < Node
      attr_reader :name

      def initialize(node:, name:)
        super(node)
        @name = name
      end
    end
  end
end
