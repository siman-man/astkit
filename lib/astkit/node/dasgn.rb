class AbstractSyntaxTreeKit
  class Node
    class DASGN < Node
      attr_reader :name, :value

      def initialize(node:, name:, value:)
        super(node)
        @name = name
        @value = value
      end
    end
  end
end
