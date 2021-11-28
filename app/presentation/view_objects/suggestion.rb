# frozen_string_literal: true

require_relative 'category'
require_relative 'course'

module Views
  # View for a single hobby entity
  class Suggestion
    def initialize(hobby, category, course, index = nil)
      @hobby    = hobby
      @category = category
      @course   = course
      @index    = index
    end

    def entity
      @hobby
    end

    def id
      @hobby.id
    end

    def index_str
      "hobby[#{@index}]"
    end

    def name
      @hobby.name
    end

    def img
      @hobby.img
    end

    def user_num
      @hobby.user_num
    end

    def description
      @hobby.description
    end

    def time
      @hobby.updated_at
    end

    def standard_time
      time.strftime('%F %R')
    end

    def result_url
      "/suggestion/#{@hobby.id}"
    end

    def categories
      @category.map { |category| Category.new(category) }
    end

    def categories_each(&block)
      categories.each(&block)
    end

    def categories_any?
      categories.any?
    end

    def courses
      @course.flatten.map { |course| Course.new(course) }
    end

    def courses_each(&block)
      courses.each(&block)
    end

    def courses_any?
      courses.any?
    end


  end
end