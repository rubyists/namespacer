# frozen_string_literal: true

require_relative 'namespacer/version'
require 'parser/current'
require 'unparser'
require 'pry'

# Top-level namespace to keep Rubyists namespaces in isolation
module Rubyists
  # Namespace for the namespacer tool
  module Namespacer
    require_relative 'namespacer/rewriter'

    # Wrap some namespace(s) around top-level AST nodes of 'module' or 'class' type
    #
    # @param string_or_io [String, IO] The source code to namespace
    # @param namespaces [String] The namespace(s) to wrap around the top-level AST nodes
    #
    # @return [String] The source code with the namespace(s) wrapped around the top-level AST nodes
    def self.namespace!(string_or_io, namespaces)
      buffer = Parser::Source::Buffer.new("(#{namespaces})")
      buffer.source = string_or_io.is_a?(IO) ? string_or_io.read : string_or_io
      parser = Parser::CurrentRuby.new
      rewriter = Rubyists::Namespacer::Rewriter.new namespaces
      rewriter.rewrite(buffer, parser.parse(buffer))
    end
  end
end

if $PROGRAM_NAME == __FILE__
  warn 'Wrapping myself'
  puts Rubyists::Namespacer.namespace!(File.read(__FILE__), 'Wrapped::Smoke::Test')
end
