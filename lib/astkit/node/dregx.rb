class AbstractSyntaxTreeKit
  class Node
    class DREGX < Node
      attr_reader :interpolation, :tail_str

      def initialize(node:, interpolation:, tail_str:)
        super(node)
        @interpolation = interpolation
        @tail_str = tail_str
      end
    end
  end
end
