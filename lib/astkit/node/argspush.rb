class AbstractSyntaxTreeKit
  class Node
    class ARGSPUSH < Node
      attr_reader :array, :element

      def initialize(node:, array:, element:)
        super(node)
        @array = array
        @element = element
      end
    end
  end
end
