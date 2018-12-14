class AbstractSyntaxTreeKit
  class Node
    class COLON2 < Node
      attr_reader :receiver, :name

      def initialize(node:, receiver:, name:)
        super(node)
        @receiver = receiver
        @name = name
      end
    end
  end
end
