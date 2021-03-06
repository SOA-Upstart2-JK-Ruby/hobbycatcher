# frozen_string_literal: true

require_relative '../../helpers/acceptance_helper'
require_relative 'pages/home_page'
require_relative 'pages/test_page'
require_relative 'pages/suggestion_page'

describe 'Test Page Acceptance Tests' do
  include PageObject::PageFactory

  before do
    options = Selenium::WebDriver::Chrome::Options.new
    options.add_argument('--headless')
    DatabaseHelper.wipe_database
    @browser = Watir::Browser.new :chrome, options: options
  end

  after do
    @browser.close
  end

  describe 'See Test Questions and Answers' do
    it '(HAPPY) see the answer radio' do
      # GIVEN: user enter the test page
      visit HomePage do |page|
        page.catch_hobby
        @browser.url.include? 'test'
      end

      # THEN: should see test page elements
      visit TestPage do |page|
        _(page.questions.exists?).must_equal true
        _(page.see_result_element.present?).must_equal true
      end
    end
  end

  describe 'Answer the Questions' do
    it '(HAPPY) provide the correct hobby suggestion based on the test answer' do
      # GIVEN: user enter the test page
      visit HomePage do |page|
        page.catch_hobby
        @browser.url.include? 'test'
      end

      # WHEN: answer the question with the answers
      visit TestPage do |page|
        _(page.questions[0].answer1_element.click)
        _(page.questions[1].answer1_element.click)
        _(page.questions[2].answer1_element.click)
        _(page.questions[3].answer1_element.click)
        page.see_result
      end

      # THEN: they should see hobby suggestion
      visit(SuggestionPage, using_params: { hobby_id: HOBBY_ID }) do |page|
        page.url.include? 'suggestion/1'
        _(page.hobby_name).must_equal 'LION'
        _(page.category_name).must_equal 'Category: Dance'
      end
    end

    it '(BAD) should report error if user does not answer all the questions' do
      # GIVEN: user enter the test page
      visit HomePage do |page|
        page.catch_hobby
        @browser.url.include? 'test'
      end

      # WHEN: user does not answer all of the questions
      visit TestPage do |page|
        page.see_result

        # THEN: user should be on test page and see a warning message
        _(page.warning_message.downcase).must_include 'seems like you did not answer all of the questions'
      end
    end
  end
end
