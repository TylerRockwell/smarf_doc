class SmarfDoc
  attr_accessor :tests
  def initialize
    @tests = []
    @skip_one = false
    @information = {}
    @skip_all = false
  end

  def sort_by_url!
    @tests.sort! do |x, y|
      x.request.path <=> y.request.path
    end
  end

  def clean_up!
    @tests = []
  end

  def aside(msg)
    @aside = ''
    @aside = "<aside class='notice'>\n #{msg}\n</aside>"
  end

  def information(key, value)
    @information[key] = value
  end

  def run!(request, response)
    if @skip_one || @skip_all
      add_test_case(request, response) if @run_anyway
      @skip_one = false
      @run_anyway = false
      return
    end
    add_test_case(request, response)
    self
  end

  def add_test_case(request, response)
    test = SmarfDoc::TestCase.new(request, response, @aside, @information)
    test.template = SmarfDoc::Conf.template
    self.tests << test
  end

  def skip
    @skip_one = true
  end

  def skip_all
    @skip_all = true
  end

  def run_this_anyway
    @run_anyway = true
  end

  def output_testcases_to_file
    docs = self.class::Conf.output_file
    raise 'No output file specific for SmarfDoc' unless docs
    File.delete docs if File.exists? docs
    write_to_file
  end

  def write_to_file
    File.open(self.class::Conf.output_file, 'a') do |file|
      @tests.each do |test|
        file.write(test.compile_template)
      end
    end
  end

  def finish!
    sort_by_url!
    output_testcases_to_file
    clean_up!
  end

# = = = =

  def self.config(&block)
    yield(self::Conf)
  end
end
