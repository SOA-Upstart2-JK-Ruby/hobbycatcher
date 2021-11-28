# frozen_string_literal: true

require 'dry-validation'

module HobbyCatcher
  module Forms
    class AddAnswer < Dry::Validation::Contract

      params do
        required(:type).filled(:integer)
        required(:difficulty).filled(:integer)
        required(:freetime).filled(:integer)
        required(:emotion).filled(:integer)
      end

      rule(:type) do
        if value.nil?
          key.failure('you must answer Q1')
        end
      end

      rule(:difficulty) do
        if value.nil?
          key.failure('you must answer Q2')
        end
      end

      rule(:freetime) do
        if value.nil?
          key.failure('you must answer Q3')
        end
      end

      rule(:emotion) do
        if value.nil?
          key.failure('you must answer Q4')
        end
      end
    end
  end
end