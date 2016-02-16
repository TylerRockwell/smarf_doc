require 'erb'

class SmarfDoc::TestCase
  attr_reader :request, :response, :created_at, :aside, :information
  attr_accessor :template

  def initialize(request, response, aside = '', information = {})
    @request, @response, @aside, = request, response, aside
    @information = information
    @created_at         = Time.now
  end

  def compile_template
    ERB.new(template).result(binding)
  end
end
