class AbstractSyntaxTreeKit
  class Node
    class QCALL < Node
      attr_reader :receiver, :method_id, :arguments

      def initialize(node:, receiver:, method_id:, arguments:)
        super(node)
        @receiver = receiver
        @method_id = method_id
        @arguments = arguments
      end
    end
  end
end
