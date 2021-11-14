# frozen_string_literal: true

require_relative 'categories'
require_relative 'courses'

module HobbyCatcher
  module Repository
    # Repository for Hobby Entities
    class Hobbies
      def self.find_id(id)
        rebuild_entity Database::HobbyOrm.first(id: id)
      end

      def self.find_name(name)
        rebuild_entity Database::HobbyOrm.first(name: name)
      end

      def self.rebuild_entity(db_record)
        return nil unless db_record

        Entity::Hobby.new(
          id:          db_record.id,
          name:        db_record.name,
          img:         db_record.img,
          description: db_record.description,
          user_num:    db_record.user_num
        )
      end

      def self.db_find_or_create(entity)
        Database::HobbyOrm.find_or_create(entity.to_attr_hash)
      end
    end
  end
end
