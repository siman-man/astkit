class AbstractSyntaxTreeKit
  class Node
    class DOT2 < Node
      attr_reader :begin, :end

      def initialize(node:, nd_begin:, nd_end:)
        super(node)
        @begin = nd_begin
        @end = nd_end
      end
    end
  end
end
