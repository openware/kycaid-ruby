# frozen_string_literal: true

RSpec.describe KYCAID::Applicant do
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

  let(:applicant_id) { "0463284c08cdf5449b297b65f570994edba4" }

  context "succesfully created applicant" do
    it "creates applicant" do
      VCR.use_cassette("applicant", record: :new_episodes) do
        response = KYCAID::Applicant.create(valid_applicant)
        expect(response.applicant_id).to eq(applicant_id)
      end
    end
  end

  context "KYCAID validations" do
    it "validates type" do
      VCR.use_cassette("applicant") do
        valid_applicant.delete(:type)
        response = KYCAID::Applicant.create(valid_applicant)
        expect(response.errors.first["message"]).to eq("Type of applicant is not valid")
      end
    end

    it "validates presence of first name" do
      VCR.use_cassette("applicant", :match_requests_on => [:body]) do
        valid_applicant.delete(:first_name)
        response = KYCAID::Applicant.create(valid_applicant)
        expect(response.errors.first["message"]).to eq("First name is required")
      end
    end

    it "validates presence of last name" do
      VCR.use_cassette("applicant") do
        valid_applicant.delete(:last_name)
        response = KYCAID::Applicant.create(valid_applicant)
        expect(response.errors.first["message"]).to eq("Last name is required")
      end
    end

    it "validates presence of dob" do
      VCR.use_cassette("applicant") do
        valid_applicant.delete(:dob)
        response = KYCAID::Applicant.create(valid_applicant)
        expect(response.errors.first["message"]).to eq("Date of birth is required")
      end
    end

    it "validates dob format" do
      VCR.use_cassette("applicant") do
        valid_applicant[:dob] = "05-03-1886"
        response = KYCAID::Applicant.create(valid_applicant)
        expect(response.errors.first["message"]).to eq("Day of birth is not valid")
      end
    end

    it "validates presence of residence country" do
      VCR.use_cassette("applicant") do
        valid_applicant.delete(:residence_country)
        response = KYCAID::Applicant.create(valid_applicant)
        expect(response.errors.first["message"]).to eq("Country of residence is required")
      end
    end

    it "validates residence country format" do
      VCR.use_cassette("applicant") do
        valid_applicant[:residence_country] = "Andorra"
        response = KYCAID::Applicant.create(valid_applicant)
        expect(response.errors.first["message"]).to eq("Country of residence is not valid")
      end
    end

    it "validates presence of email" do
      VCR.use_cassette("applicant") do
        valid_applicant.delete(:email)
        response = KYCAID::Applicant.create(valid_applicant)
        expect(response.errors.first["message"]).to eq("Email is required")
      end
    end
  end

  context "get applicant" do
    it 'returns applicant info' do
      VCR.use_cassette("applicant") do
        response = KYCAID::Applicant.fetch(applicant_id)
        expect(response.applicant_id).to eq(applicant_id)
        expect(response.first_name).to eq(valid_applicant[:first_name].to_s)
        expect(response.last_name).to eq(valid_applicant[:last_name].to_s)
        expect(response.dob).to eq(valid_applicant[:dob].to_s)
        expect(response.residence_country).to eq(valid_applicant[:residence_country].to_s)
        expect(response.email).to eq(valid_applicant[:email].to_s)
      end
    end
  end
end
