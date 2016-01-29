require 'erb'

class SmarfDoc::TestCase
  attr_reader :request, :response, :created_at, :note, :aside, :information
  attr_accessor :template

  def initialize(request, response, note = '', aside = '', information = {})
    @request, @response, @note, @aside = request, response, note, aside
    @information = information
    @created_at         = Time.now
  end

  def compile_template
    ERB.new(template).result binding
  end
end
