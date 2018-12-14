class AbstractSyntaxTreeKit
  class Node
    class CDECL < Node
      attr_reader :extension, :name, :value

      def initialize(node:, extension: nil, name:, value:)
        super(node)
        @extension = extension
        @name = name
        @value = value
      end
    end
  end
end
