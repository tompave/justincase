require 'minitest_helper'

class TestDummy < MiniTest::Unit::TestCase
  def setup
    @a_var = "something"
  end

  def test_that_it_is_something
    assert_equal "something", @a_var
  end

  def test_that_it_will_not_blend
    refute_match /^no/, @a_var
  end

  def test_that_will_be_skipped
    skip "test this later"
  end
end