require 'erb'

class SmarfDoc::TestCase
  attr_reader :request, :response, :created_at, :note, :aside, :information, :category, :title, :description
  attr_accessor :template

  def initialize(request, response, note = '', aside = '', category = '', title = '', description = '')
    @request, @response, @note, @aside, @category, @title, @description = request, response, note, aside, category, title, description
    @created_at         = Time.now
  end

  def compile_template
    ERB.new(template).result binding
  end
end
