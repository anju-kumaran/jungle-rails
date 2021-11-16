require 'rails_helper'

RSpec.describe Product, type: :model do

  let(:category) {
    Category.new(name: "Apparel")
  }
  subject {
    category.products.new(
      name: "Baby frock",
      description: "This is a nice frock.",
      image: "frockImg",
      price_cents: 820,
      quantity: 50,
    )
  }

  describe "Validations" do
    it "saves successfully with valid attributes" do
      expect(subject).to be_valid
      expect(subject.errors.full_messages).to be_empty
    end

    it "fails to save without a name" do
      subject.name = nil
      expect(subject).to_not be_valid
      expect(subject.errors.full_messages).to include "Name can't be blank"
    end
    it "fails to save without a price" do
      subject.price_cents = nil
      expect(subject).to_not be_valid
      expect(subject.errors.full_messages).to include "Price can't be blank"
    end

    it "fails to save without a quantity" do
      subject.quantity = nil
      expect(subject).to_not be_valid
      expect(subject.errors.full_messages).to include "Quantity can't be blank"
    end

    it "fails to save without a category" do
      product = Product.create(
        name: "Baby frock",
        price_cents: 820,
        quantity: 50,
      )
      expect(product).to_not be_valid
      expect(product.errors.full_messages).to include "Category can't be blank"
    end

  end
end

