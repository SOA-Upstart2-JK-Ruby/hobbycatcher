module InfoHunter
  # Provides access to post data
  class Posts
    def initialize(post_data)
      @posts = post_data
    end

    def id
      @posts['id']
    end

    def date
      @posts['date']
    end

    def message
      @posts['message']
    end
  end
end