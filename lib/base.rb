class SmarfDoc
  attr_accessor :tests
  def initialize
    @tests = []
    @skip = false
  end

  def sort_by_url!
    @tests.sort! do |x, y|
      x.request.path <=> y.request.path
    end
  end

  def clean_up!
    @tests = []
  end

  def note(msg)
    @note = msg || ''
  end

  def aside(msg)
    @aside = ''
    @aside = "<aside class='notice'>\n #{msg}\n</aside>" if msg
  end

  def category(test_category)
    @category = test_category || ''
  end

  def title(msg)
    @title = msg || ''
  end

  def description(msg)
    @description = msg || ''
  end

  def run!(request, response)
    @category ||= ''
    if @skip
      @skip = false
      return
    end
    add_test_case(request, response, @note, @aside, @category, @title, @description)
    @note = ''
    @aside = ''
    @category = ''
    self
  end

  def add_test_case(request, response, note, aside, category, title, description)
    test = SmarfDoc::TestCase.new(request, response, note, aside, category, title, description)
    test.template = SmarfDoc::Conf.template
    self.tests << test
  end

  def skip
    @skip = true
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

  def self.current
    Thread.current[:dys_instance] ||= self.new
  end

  def self.config(&block)
    yield(self::Conf)
  end
end
