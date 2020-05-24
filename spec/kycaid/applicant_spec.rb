# frozen_string_literal: true

RSpec.describe KYCAID::Applicant do
  context "succesfully created applicant" do
    let(:valid_applicant) do
      {
        type: :PERSON,
        first_name: :John,
        last_name: :Baker,
        dob: "1986-05-03",
        residence_country: "GB",
        email: "john_baker@gmail.com"
      }
    end

    it "creates apllicant" do
      VCR.use_cassette("applicant", record: :new_episodes, :match_requests_on => [:method, :uri, :body]) do
        response = KYCAID::Applicant.create(valid_applicant)
        expect(response.applicant_id).to eq("72610deb0d62c54f9c2a0574ca7c1d27e1f8")
      end
    end
  end

  context "KYCAID validations" do
    it "validates first name" do
      VCR.use_cassette("applicant", :match_requests_on => [:body]) do
        response = KYCAID::Applicant.create(valid_applicant.except(:first_name))
        expect(response.errors.first["message"]).to eq("First name is required")
      end
    end

    it "validates type" do
      VCR.use_cassette("applicant", :match_requests_on => [:method, :uri, :body]) do
        response = KYCAID::Applicant.create({})
        expect(response.errors.first["message"]).to eq("Type of applicant is not valid")
      end
    end
  end
end
