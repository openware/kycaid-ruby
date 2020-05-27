# frozen_string_literal: true

RSpec.describe KYCAID::Address do
  let(:temp_file) { open('spec/fixtures/passport.jpg') }
  let(:content_type) { "jpg" }
  let(:original_filename) {"foo.jpg"}

  let(:document_params) do
    {
      tempfile: temp_file,
      file_extension: content_type,
      file_name: original_filename
    }
  end

  let(:address_params) do
    {
      type: :REGISTERED,
      country: :GB,
      state_or_province: :Westminster,
      city: :London,
      postal_code: "SW1A 2AB",
      street_name: "Downing St",
      building_number: "10",
    }
  end

  let(:address_id_registered) { "62213e920028b54dd628a0e87594437efbc8" }

  let(:applicant_id) { "d669a7d60cc595473c296e97b0aa60af20de" }

  context "succesfully created applicant" do
    it "creates address with registered type" do
      VCR.use_cassette("address", record: :new_episodes) do
        response = KYCAID::Address.create(address_params.merge(applicant_id: applicant_id, front_file: document_params))
        expect(response.address_id).to eq(address_id_registered)
      end
    end
  end

  context "KYCAID validations" do
    it "validates type" do
      VCR.use_cassette("address") do
        address_params.delete(:type)
        response = KYCAID::Address.create(address_params.merge(applicant_id: applicant_id))
        expect(response.errors.first["message"]).to eq("Type of address is not valid")
      end
    end

    it "validates presence of first name" do
      VCR.use_cassette("address", :match_requests_on => [:body]) do
        address_params[:country] = "Andorra"
        response = KYCAID::Address.create(address_params.merge(applicant_id: applicant_id))
        expect(response.errors.first["message"]).to eq("Country of residence is not valid")
      end
    end
  end
end
