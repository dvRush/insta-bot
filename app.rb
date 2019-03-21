require 'pry'
require 'capybara/dsl'
require 'selenium-webdriver'
require 'chromedriver/helper'

Chromedriver.set_version "2.35"
Capybara.register_driver(:headless_chrome) do |app|
  Capybara::Selenium::Driver.new(
    app,
    browser: :chrome,
    desired_capabilities: {
      chromeOptions: {
        args: %w[headless disable-gpu no-sandbox]
      }
    }
  )
end

Capybara.configure do |config|
  config.default_driver    = :headless_chrome
  config.javascript_driver = :headless_chrome
  config.default_max_wait_time = 5
end

class InstaBot
  include Capybara::DSL

  def start
    visit 'http://example.com'

    page.driver.save_screenshot('./ss.png')
  end

  def self.start
    new.start
  end
end

MyDriver.start
