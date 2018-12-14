class AbstractSyntaxTreeKit
  class Node
    class CASE2 < Node
      attr_reader :case_clauses

      def initialize(node:, case_clauses:)
        super(node)
        @case_clauses = case_clauses
      end
    end
  end
end
