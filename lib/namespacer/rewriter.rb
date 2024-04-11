# frozen_string_literal: true

module Rubyists
  module Namespacer
    # Do the AST rewriting with the Rewriter class
    class Rewriter < Parser::TreeRewriter
      attr_accessor(:namespaces)

      def initialize(namespaces)
        super()
        @namespaces = namespaces
      end

      def on_module(node)
        _on_module(node)
      end

      def on_class(node)
        _on_module(node)
      end

      private

      def wrap(ast)
        # Recursively wrap the AST in the namespace modules
        namespaces.split('::').reverse.inject(ast) do |current_ast, ns|
          # Create a module node with the current namespace part and the current AST
          Parser::AST::Node.new(:module, [Parser::AST::Node.new(:const, [nil, ns.to_sym]), current_ast])
        end
      end

      def _on_module(node)
        return unless node.location.column.zero?

        (ast, comments) = Unparser.parse_with_comments(node.location.expression.source)
        replace(node.location.expression, Unparser.unparse(wrap(ast), comments))
      end
    end
  end
end
