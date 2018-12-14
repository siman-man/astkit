class AbstractSyntaxTreeKit
  class Node
    class FCALL < Node
      attr_reader :method_id, :arguments

      def initialize(node:, method_id:, arguments:)
        super(node)
        @method_id = method_id
        @arguments = arguments
      end
    end
  end
end
