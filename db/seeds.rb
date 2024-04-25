require "net/http"
require "open-uri"
require "bigdecimal"
require "json"

Category.destroy_all
OrderItem.destroy_all
Product.destroy_all
Order.destroy_all
Customer.destroy_all
Province.destroy_all

# Total time to run: ~0.5 minutes.

# I couldn't find any type of limiting option for requests to the API.
api_urls = ["https://api.nookipedia.com/nh/fish",
            "https://api.nookipedia.com/nh/bugs",
            "https://api.nookipedia.com/nh/sea"]

# This website contains a list of all province and territory tax rates.
# Quebec's QST is listed as PST. This list is used to populate province data.
province_web_scraping = "https://www.retailcouncil.org/resources/quick-facts/sales-tax-rates-by-province/"

# Reusing this method from my intro project.
# This method takes a url for a request and returns the data in JSON format.
def request_data(url)
  uri = URI(url)
  api_key = ENV['API_KEY']

  headers = {"X-API-KEY" => api_key,
             "Accept-Version" => "1.7.0"}

  response = Net::HTTP.get(uri, headers)
  formatted_response = JSON.parse(response)
end

def create_category(word)
  category = Category.find_or_create_by!(name: word)
end

# Populate categories.
api_urls.each do |url|
  data_creatures = request_data(url)

  # Find the index of the last slash to collect the category word.
  last_slash = url.rindex("\/") + 1
  url_category = url[last_slash..-1]

  main_category = create_category(url_category.capitalize)

  # Limit the amount of creatures registered through a take method.
  data_creatures.take(34).each do |creature|
    # Populate Products. The api prices are slightly ridiculous in a real life case.
    new_product = Product.find_or_create_by!(name:           creature["name"].capitalize,
                                             description:    creature["catchphrases"][0],
                                             price:          creature["sell_nook"] / 10,
                                             stock_quantity: rand(1..10),
                                             on_sale:        rand(11) < 1)

    # Associate the product with both of its categories.
    new_product.categories << main_category

    # Some creatures don't have rarity, so this category is only created
    # and associated if it exists.
    unless creature["rarity"].blank?
      rarity_category = create_category(creature["rarity"])
      new_product.categories << rarity_category
    end

    # Find and assign each image
    image_url = creature["render_url"]
    uri = URI.parse(image_url)
    image = URI.open(uri)

    new_product.image.attach(io: image, filename: File.basename(image_url, ".png"), content_type: "image/png")
  end
end

# Populate Provinces through web scraping.
province_page_html = URI.open(province_web_scraping)
province_page_doc = Nokogiri::HTML(province_page_html)

provinces_selector = "#maincontent > div.container.page-layout > div.col-lg-8.offset-lg-2.page-content > div > article > div.table-mobile > table > tbody tr"
province_table_data = province_page_doc.css(provinces_selector)

# Iterate through each table row to find provinces and tax rates.
province_table_data.each do |province|
  # Collect information.
  province_name = province.at_css("td:nth-child(1)").content
  pst_content = province.at_css("td:nth-child(3)").content
  gst_content = province.at_css("td:nth-child(4)").content
  hst_content = province.at_css("td:nth-child(5)").content

  # If no value exists, set the tax rate to 0.
  # Use BigDecimal to avoid math error for Quebec.
  pst = pst_content.blank? ? 0 : BigDecimal(pst_content.chop) / 100
  gst = gst_content.blank? ? 0 : BigDecimal(gst_content.chop) / 100
  hst = hst_content.blank? ? 0 : BigDecimal(hst_content.chop) / 100

  Province.create!(name: province_name,
                   pst:  pst,
                   gst:  gst,
                   hst:  hst)
end

AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password') if Rails.env.development?