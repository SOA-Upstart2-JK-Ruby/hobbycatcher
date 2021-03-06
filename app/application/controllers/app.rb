# frozen_string_literal: true

require 'roda'
require 'slim'
require 'slim/include'
require 'yaml'

# :reek:RepeatedConditiona
module HobbyCatcher
  # Web App
  class App < Roda
    plugin :halt
    plugin :flash
    plugin :all_verbs # recognizes HTTP verbs beyond GET/POST (e.g., DELETE)
    plugin :render, engine: 'slim', views: 'app/presentation/views_html'
    plugin :public, root: 'app/presentation/public'
    plugin :assets, path: 'app/presentation/assets',
                    css: 'style.css', js: 'table_row.js'

    use Rack::MethodOverride # for other HTTP verbs (with plugin all_verbs

    # rubocop:disable Metrics/BlockLength
    route do |routing|
      routing.assets # load CSS
      routing.public

      # GET /
      routing.root do
        # Get cookie viewer's previously seen test history
        session[:watching] ||= []
        viewable_hobbies = Views::HobbiesList.new(session[:watching])
        view 'home', locals: { hobbies: viewable_hobbies }
      end

      routing.on 'test' do
        routing.is do
          routing.post do
            routing.redirect 'test'
          end

          routing.get do
            result = Service::ShowTest.new.call

            if result.failure?
              flash[:error] = result.failure
              routing.redirect '/'
            else
              questions = result.value!
              viewable_questions = Views::QuestionsList.new(questions)
            end

            view 'test', locals: { questions: viewable_questions }
          end
        end
      end

      routing.on 'history' do
        routing.post do
          hobby = routing.params['delete']
          delete_item = nil
          session[:watching].each do |item|
            delete_item = item if item.updated_at.to_s == hobby
          end
          session[:watching].delete(delete_item)

          routing.redirect '/history'
        end

        routing.is do
          routing.get do
            # Load previously viewed hobbies
            result = Service::ListHistories.new.call(session[:watching])

            if result.failure?
              flash[:error] = result.failure
              viewable_hobbies = []
            else
              hobbies = result.value!
              flash.now[:notice] = 'Catch your hobby first to see history.' if hobbies.empty?

              viewable_hobbies = Views::HobbiesList.new(hobbies)
            end

            view 'history', locals: { hobbies: viewable_hobbies }
          end
        end
      end

      routing.on 'suggestion' do
        routing.is do
          # POST /introhobby/
          routing.post do
            url_request = Forms::AddAnswer.new.call(routing.params)

            if url_request.failure?
              flash[:error] = 'Seems like you did not answer all of the questions'
              response.status = 400
              routing.redirect '/test'
            end

            answer = [url_request[:type], url_request[:difficulty], url_request[:freetime], url_request[:emotion]]
            result = Service::GetAnswer.new.call(answer)
            hobby = result.value!

            # Add new record to watched set in cookies
            session[:watching].insert(0, hobby.answers).uniq!
            # Redirect viewer to project page
            routing.redirect "suggestion/#{hobby.answers.id}"
          end
        end

        routing.on String do |hobby_id|
          # GET /introhoppy/hoppy
          routing.get do
            result = Service::ShowSuggestion.new.call(hobby_id)
            if result.failure?
              flash[:error] = result.failure
              routing.redirect '/'
            else
              suggestions = result.value!

              viewable_hobby = Views::Suggestion.new(suggestions)
            end

            view 'suggestion', locals: { hobby: viewable_hobby }
          end
        end
      end
    end
    # rubocop:enable Metrics/BlockLength
  end
end
