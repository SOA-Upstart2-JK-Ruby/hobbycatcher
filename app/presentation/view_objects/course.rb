# frozen_string_literal: true

module Views
  # View for a single course entity
  class Course
    def initialize(course)
      @course = course
    end

    def category_id
      @course.owncategory_id
    end

    def entity
      @course
    end

    def image
      @course.image
    end

    def url
      @course.url
    end

    def price
      @course.price
    end

    def title
      @course.title
    end

    def rating
      @course.rating
    end
  end
end
