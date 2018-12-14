class AbstractSyntaxTreeKit
  class Node
    class SCOPE < Node
      attr_reader :local_table, :arguments, :body

      def initialize(node:, local_table:, arguments:, body:)
        super(node)
        @local_table = local_table
        @arguments = arguments
        @body = body
      end
    end
  end
end
