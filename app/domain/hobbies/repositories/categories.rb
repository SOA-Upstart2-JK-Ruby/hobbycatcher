# frozen_string_literal: true

require_relative 'courses'

module HobbyCatcher
  module Repository
    # Repository for Categories
    class Categories
      def self.all
        Database::CategoryOrm.all.map { |db_category| rebuild_entity(db_category) }
      end

      def self.find_full_name(ownhobby_name, owncategory_name)
        db_category = Database::CategoryOrm
          .left_join(:hobbies, id: :ownhobby_id)
          .where(hobbyname: ownhobby_name, name: owncategory_name)
          .first
        rebuild_entity(db_category)
      end

      def self.find(entity)
        find_ud_category_id(entity.ud_category_id)
      end

      def self.find_id(id)
        rebuild_entity Database::CategoryOrm.first(id: id)
      end

      def self.find_name(name)
        rebuild_entity Database::CategoryOrm.first(name: name)
      end

      def self.find_ud_category_id(ud_category_id)
        rebuild_entity Database::CategoryOrm.first(ud_category_id: ud_category_id)
      end

      def self.create(entity)
        raise 'Category already exists' if find(entity)

        db_category = PersistCategory.new(entity).call
        rebuild_entity(db_category)
      end

      def self.rebuild_entity(db_record)
        return nil unless db_record
        Entity::Category.new(
          db_record.to_hash.merge(
            ownhobby: Hobbies.rebuild_entity(db_record.ownhobby)
          )
        )
      end

      # Helper class to persist category and its hobby to database
      class PersistCategory
        def initialize(entity)
          @entity = entity
        end

        def create_category
          Database::CategoryOrm.create(@entity.to_attr_hash)
        end

        def call
          ownhobby = Hobbies.db_find_or_create(@entity.ownhobby)

          create_category.tap do |db_category|
            db_category.update(ownhobby: ownhobby)
          end
        end
      end

      def self.db_find_or_create(entity)
        Database::CategoryOrm.find_or_create(entity.to_attr_hash)
      end
    end
  end
end
