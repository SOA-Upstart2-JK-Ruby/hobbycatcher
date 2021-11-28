# frozen_string_literal: true

require 'dry/transaction'

module HobbyCatcher
    module Service
        class OrganizeData
            include Dry::Transaction
            step :get_hobby
            # step :find_hobby_ownedcategoty
            # step :find_related_courses
      
            private

            def get_hobby(input)
                hobby = HobbyCatcher::Database::HobbyOrm.where(id: hobby_id).first
                  #categories = HobbyCatcher::Repository::Categories.find_id_categories(hobby_id)
                categories = hobby.owned_categories
                courses_intros = []
                categories.map do |category|
                  courses = Udemy::CourseMapper.new(App.config.UDEMY_TOKEN).find('subcategory', category.name)
                  courses.map do |course_intro|
                    course = Repository::For.entity(course_intro)
                    course.create(course_intro) if course.find(course_intro).nil?
                  end
                  courses_intros.append(courses)
                end
                return [hobby,categories,courses_intros]
            end

            # def find_hobby_ownedcategoty()
            # end

            # def find_related_courses()
            # end
        end
    end
end