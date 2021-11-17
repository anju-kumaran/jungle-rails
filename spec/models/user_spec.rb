require 'rails_helper'

RSpec.describe User, type: :model do
  subject {
    described_class.new(
      first_name: "Ann", 
      last_name: "Joe", 
      email: "ann@example.com", 
      password: "testing", 
      password_confirmation: "testing"
    )
  }
  describe "Validations" do
    it "saves successfully with valid attributes" do
      expect(subject).to be_valid
      expect(subject.errors.full_messages).to be_empty
    end
    it "fails to save without first name" do
      subject.first_name = nil
      expect(subject).to_not be_valid
      expect(subject.errors.full_messages).to include ("First name can't be blank")
    end
    it "fails to save without last name" do
      subject.last_name = nil
      expect(subject).to_not be_valid
      expect(subject.errors.full_messages).to include ("Last name can't be blank")
    end
    it "fails to save without an email" do
      subject.email = nil
      expect(subject).to_not be_valid
      expect(subject.errors.full_messages).to include ("Email can't be blank")
    end
    it "fails to save without pasword" do
      subject.password = nil
      expect(subject).to_not be_valid
      expect(subject.errors.full_messages).to include ("Password can't be blank")
    end
    it "fails to save without pasword confirmation" do
      subject.password_confirmation = nil
      expect(subject).to_not be_valid
      expect(subject.errors.full_messages).to include ("Password confirmation can't be blank")
    end
    it "fails to save when password and password_confirmation doesn't match" do
      subject.password_confirmation = "anothertesting"
      expect(subject).to_not be_valid
      expect(subject.errors.full_messages).to include ("Password confirmation and Password doesn't match")
    end
    it "fails to save when email isn't unique" do
      same_as_user = User.create(
        first_name: "Karen", 
        last_name: "Kim", 
        email: "ann@example.com", 
        password: "testing", 
        password_confirmation: "testing"
      )
      expect(subject).to_not be_valid
      expect(subject.errors.full_messages).to include ("Email already exist")
    end

    it "fails to save when password is shorter than 5 characters" do
      subject.password = "test"
      subject.password_confirmation = "test"
      expect(subject).to_not be_valid
      expect(subject.errors.full_messages).to include ("Password must be minimum is 5 characters length")
    end

    it "successfully save when password is exactly 5 characters" do
      subject.password = "tests"
      subject.password_confirmation = "tests"
      expect(subject).to be_valid
      expect(subject.errors.full_messages).to be_empty
    end
  end

  describe '.authenticate_with_credentials' do
    it "authenticates if credentials are valid" do
      subject.save!
      auth = User.authenticate_with_credentials(subject.email, subject.password)
      expect(auth).to eq subject
    end

    it "doesn't authenticate if email is incorrect" do
      subject.save!
      auth = User.authenticate_with_credentials("user@example.com", subject.password)
      expect(auth).to eq nil
    end

    it "doesn't authenticate if password is incorrect" do
      subject.save!
      auth = User.authenticate_with_credentials(subject.email, "wrong")
      expect(auth).to eq nil
    end

    it "authenticates when email is correct but whitespace around it" do
      subject.save!
      auth = User.authenticate_with_credentials("   " + subject.email + "  ", subject.password)
      expect(auth).to eq subject
    end

    it "authenticates when email is correct but wrong case" do
      subject.save!
      auth = User.authenticate_with_credentials("USEr@EXAMPLE.coM", subject.password)
      expect(auth).to eq subject
    end

  end
end