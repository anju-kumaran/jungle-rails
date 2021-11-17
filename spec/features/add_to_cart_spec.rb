require 'rails_helper'

RSpec.feature "User clicks the Add button to add a product to cart", type: :feature do
  before :each do
    @category = Category.create! name: 'Apparel'

    10.times do |n|
      @category.products.create!(
        name:  Faker::Hipster.sentence(3),
        description: Faker::Hipster.paragraph(4),
        image: open_asset('apparel1.jpg'),
        quantity: 10,
        price: 64.99
      )

    end
  end

  
    # it block
    scenario "User clicks Add and My Cart will update to 'My Cart(1)'" do
      # ACT
      visit root_path

      #VERIFY
      expect(page).to have_content("My Cart (0)")
  
      within(".product:nth-of-type(1)") { click_button "Add" }
  
      expect(page).to_not have_content("My Cart (0)")
      
      expect(page).to have_content("My Cart (1)")
    end
end
