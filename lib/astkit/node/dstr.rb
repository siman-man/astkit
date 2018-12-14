class AbstractSyntaxTreeKit
  class Node
    class DSTR < Node
      attr_reader :pre_str, :interpolation, :tail_str

      def initialize(node:, pre_str:, interpolation:, tail_str:)
        super(node)
        @pre_str = pre_str
        @interpolation = interpolation
        @tail_str = tail_str
      end
    end
  end
end
