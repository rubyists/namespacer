# frozen_string_literal: true

require 'test_helper'

class TestNamespacer < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Rubyists::Namespacer::VERSION
  end

  def test_it_does_something_useful
    namespaced = Rubyists::Namespacer.namespace!('class Foo; end', 'Rubyists::Namespace::Test')
    expected = "module Rubyists\n  module Namespace\n    module Test\n      class Foo\n      end\n    end\n  end\nend\n"

    assert_equal expected, namespaced
  end
end
