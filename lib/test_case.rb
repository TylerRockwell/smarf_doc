require 'erb'

class SmarfDoc::TestCase
  attr_reader :request, :response, :created_at, :note, :aside, :information, :category, :title, :description
  attr_accessor :template

  def initialize(request, response, aside = '', information = {})
    @request, @response, @aside, @category, @title = request, response, aside, category, title
    @information = information
    @created_at         = Time.now
  end

  def compile_template
    ERB.new(template).result(binding)
  end
end
