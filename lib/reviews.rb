module InfoHunter
  # Provides access to review data
  class Reviews
    def initialize(review_data)
      @reviews = review_data
    end
  
    def sentiment
      @reviews['sentiment']
    end

    def ratings
      @reviews['ratings']
    end
  end
end