require_relative "test_helper"
class TestBase < SmarfDocTest
  def test_run!
    # smarf = SmarfDoc.current
    tests = @smarf.tests
    assert_equal 0, tests.length,
      "Expected current tests to be an empty array"
    @smarf.run!(request, response)
    assert_equal 1, tests.length,
      "Expected run!() to increase number of tests"
    assert tests.first.is_a?(SmarfDoc::TestCase)
    @smarf.run!(request, response)
    assert_equal 2, tests.length,
      "Expected run!() to increase number of tests"
    assert_includes tests.first.compile_template,
        "You can use ERB to format each test case",
        "Did not load correct template file"
  end

  def test_sort!
    first = Request.new("GET", {id: 12}, 'api/aaa')
    last  = Request.new("GET", {id: 12}, 'api/zzz')
    @smarf.run!(first, response)
    @smarf.run!(last, response)
    results = @smarf.sort_by_url!.map{|tc| tc.request.path}
    assert_equal ["api/aaa", "api/zzz"], results,
      "Did not sort test cases by request URL"
  end

  def test_finish!
    file = SmarfDoc::Conf.output_file
    first = Request.new("GET", {id: 12}, 'api/aaa')
    last  = Request.new("GET", {id: 12}, 'api/zzz')
    @smarf.run!(first, response)
    @smarf.run!(last, response)
    @smarf.finish!
    assert File.exists?(file),
      "Did not create an output file after finish!()ing"
    assert_includes File.read(file), "You can use ERB",
      "Did not utilize template to output docs."
  end

  def test_skip
    tests= @smarf.tests
    first = Request.new("GET", {id: 12}, 'api/skip')
    last  = Request.new("GET", {id: 12}, 'api/noskip')
    @smarf.skip
    @smarf.run!(first, response)
    @smarf.run!(last, response)
    assert_equal 1, tests.length,
      "Smarf did not skip tests."
    assert_equal 'api/noskip', tests.first.request.path,
      "Smarf did not skip tests."
  end

  def test_multiple_skips
    tests= @smarf.tests
    first = Request.new("GET", {id: 12}, 'api/noskip1')
    second = Request.new("GET", {id: 12}, 'api/skip1')
    third  = Request.new("GET", {id: 12}, 'api/skip2')
    fourth  = Request.new("GET", {id: 12}, 'api/noskip2')
    @smarf.run!(first, response)
    @smarf.skip
    @smarf.run!(second, response)
    @smarf.skip
    @smarf.run!(third, response)
    @smarf.run!(fourth, response)
    assert_equal 2, tests.length,
      "Smarf skipped 2 tests."
    assert_equal 'api/noskip1', tests[0].request.path,
      "Smarf did not skip first unskipped test."
    assert_equal 'api/noskip2', tests[1].request.path,
      "Smarf did not skip second unskipped test."
  end

  def test_note
    tests= @smarf.tests
    first = Request.new("GET", {id: 12}, 'api/skip')
    last  = Request.new("GET", {id: 12}, 'api/noskip')
    @smarf.information(:note, "안녕하세요")
    @smarf.run!(first, response)
    @smarf.run!(last, response)
    assert_includes tests.first.compile_template, "안녕하세요",
      "Could not find note in documentation."
  end

  def test_aside
    tests= @smarf.tests
    first = Request.new("GET", {id: 12}, 'api/skip')
    last  = Request.new("GET", {id: 12}, 'api/noskip')
    @smarf.aside("Too many docs")
    @smarf.run!(first, response)
    @smarf.run!(last, response)
    assert_includes tests.first.compile_template,
      "<aside class='notice'>\n Too many docs\n</aside>",
      "Could not find aside in documentation."
  end

  def test_category
    tests= @smarf.tests
    first = Request.new("GET", {id: 12}, 'api/skip')
    last  = Request.new("GET", {id: 12}, 'api/noskip')
    @smarf.information(:category, "Test category")
    @smarf.run!(first, response)
    @smarf.run!(last, response)
    assert_includes tests.first.compile_template,
      "Test category",
      "Could not find category in documentation."
  end

  def test_title
    tests= @smarf.tests
    first = Request.new("GET", {id: 12}, 'api/skip')
    last  = Request.new("GET", {id: 12}, 'api/noskip')
    @smarf.information(:title, "Test title")
    @smarf.run!(first, response)
    @smarf.run!(last, response)
    assert_includes tests.first.compile_template, "Test title",
      "Could not find title in documentation."
  end

  def test_description
    tests= @smarf.tests
    first = Request.new("GET", {id: 12}, 'api/skip')
    last  = Request.new("GET", {id: 12}, 'api/noskip')
    @smarf.information(:description, "Test description")
    @smarf.run!(first, response)
    @smarf.run!(last, response)
    assert_includes tests.first.compile_template, "Test description",
      "Could not find description in documentation."
  end
end
