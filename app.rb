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

  NSTAGRAM_ROOT_URL = 'https://www.instagram.com'.freeze

  attr_reader :login, :password

  def initialize(login, password)
    @login = login
    @password = password
  end

  def start
    # TODO
  end

  def sign_in
    visit INSTAGRAM_ROOT_URL

    click_on 'Log in'

    sleep 2
    fill_in 'Phone number, username, or email', with: login
    sleep 2
    fill_in 'Password', with: password
    sleep 2

    click_button 'Log in'
  end

  end

  def save_screenshot(filename='./ss.png')
    page.driver.save_screenshot(filename)
  end

  def self.start(login:, password:)
    new(login, password).start
  end
end
