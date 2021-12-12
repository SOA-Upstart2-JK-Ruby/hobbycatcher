# frozen_string_literal: true

module Views
  # View for a single question entity
  class Question
    def initialize(question, index = nil)
      @question    = question
      @index    = index
    end

    def entity
      @question
    end

    def id
      @question.id
    end

    def index_str
      "question[#{@index}]"
    end

    def description
      @question.description
    end

    def answerA
      @question.answerA
    end

    def answerB
      @question.answerB
    end

    def type
      @question.button_name
    end
  end
end
