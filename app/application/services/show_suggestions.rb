# frozen_string_literal: true

require 'dry/monads'
# :reek:NestedIterators
# :reek:TooManyStatements
# :reek:NilCheck
module HobbyCatcher
  module Service
    # Retrieves array of all listed hobby entities
    class ShowSuggestion
      include Dry::Monads[:result]

      def call(input)
        # categories = Repository::Hobbies.find_owncategories(input)
        hobby = Repository::Hobbies.find_id(input)
        categories = hobby.categories

        categories.each do |category|
          list = Udemy::CategoryMapper.new(App.config.UDEMY_TOKEN).find('subcategory', category.name)
          Repository::For.entity(list).update_courses(list) if category.courses.empty?
        end

        hobby = Repository::Hobbies.find_id(input)

        Success(hobby)
      rescue StandardError
        Failure('Having trouble accessing Udemy courses')
      end
    end
  end
end
