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

  INSTAGRAM_ROOT_URL = 'https://www.instagram.com'.freeze

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

  def fetch_post_image(post_path)
    visit INSTAGRAM_ROOT_URL + post_path

    @image_url = Nokogiri::HTML.
      parse(page.body).
      xpath(".//main//article/div//img[@srcset]").
      attr('src').
      value

    File.open("image_post_#{post_path.to_s.gsub('/', '_')}.jpg", 'wb+') do |f|
      f.write open(@image_url).read
    end
  end

  def fetch_post_comments(post_path)
    visit INSTAGRAM_ROOT_URL + post_path

    loop do
      click_on 'Load more comments'
      sleep 1
    rescue Capybara::ElementNotFound
      break
    end

    @comments = Nokogiri::HTML.
      parse(page.body).
      xpath("//li[@role='menuitem'][position()>1]").map do |n_comment|
        n_comment.xpath("./div/div/div").children.map(&:text)
      end
  end

  def save_screenshot(filename='./ss.png')
    page.driver.save_screenshot(filename)
  end

  def self.start(login:, password:)
    new(login, password).start
  end
end
