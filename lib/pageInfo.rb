module InfoHunter
  # Provides access to pageInfo data
  class PageInfo
    def initialize(info_data)
      @pageInfo = info_data
    end

    def id
      @pageInfo['id']
    end
    
    def name
      @pageInfo['name']
    end
    
    def category
      @pageInfo['category']
    end

    def profile
      @pageInfo['profile']
    end

    def followers
      @pageInfo['followers']
    end

    def rating
      @pageInfo['rating']
    end

    def website
      @pageInfo['website']
    end

    def location
      @pageInfo['location']
    end

    def about
      @pageInfo['about']
    end
  end
end