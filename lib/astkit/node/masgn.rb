class AbstractSyntaxTreeKit
  class Node
    class MASGN < Node
      attr_reader :rhs, :lhs, :splat

      def initialize(node:, rhs:, lhs:, splat:)
        super(node)
        @rhs = rhs
        @lhs = lhs
        @splat = splat
      end
    end
  end
end
