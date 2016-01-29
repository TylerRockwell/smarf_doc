require 'erb'

class SmarfDoc::TestCase
  attr_reader :request, :response, :created_at, :note, :aside
  attr_accessor :template

  def initialize(request, response, note = '', aside = '')
    @request, @response, @note, @aside = request, response, note, aside
    @created_at         = Time.now
  end

  def compile_template
    ERB.new(template).result binding
  end
end
