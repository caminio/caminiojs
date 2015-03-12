require 'spec_helper'

describe Caminio::V1::Contacts do

  let!(:user){ create(:user) }

   describe "/contacts" do

    let!(:contact){ create(:contact) }

    before :each do
      @url = "v1/contacts"
      header 'Authorization', "Bearer #{user.aquire_api_key.token}"
      header 'Organization-id', user.organizations.first
    end

    it "returns ticketeer_customers json" do
      get @url
      expect( last_response.status ).to be == 200
      expect( json ).to have_key(:contacts)
      expect( json.contacts.length ).to eq(1)
    end

    describe "json return properties" do

      before :each do
        get "v1/contacts/#{contact.id}"
      end

      it{ expect( json ).to have_key(:contact) }
      it{ expect( json.contact ).to have_key(:id) }

    end

  end

  describe "POST /contacts", focus: true do

    before :each do
      @location = create(:location)
      header 'Authorization', "Bearer #{user.aquire_api_key.token}"
    end

    let(:url){ 'v1/contacts' }
    let(:error_400){ 'contact is missing, contact[email] is missing' }
    let(:post_attr){ { contact: { 
      firstname: "customer", 
      email: "test@test.com", 
      location_id: @location.id }
    }}

    # describe "requires" do

    #   it { post(url); expect( last_response.status ).to be == 400 }
    #   it { post(url); expect( json.error ).to be == error_400 }
    #   it { post(url, { contact: { } } ); expect( json.error ).to be == error_400 }
    #   it "email" do
    #     post(url, { contact: { 
    #       firstname: "customer" } } ); 
    #     expect( json.error ).to be == "contact[email] is missing"
    #   end

    # end

    describe "returns contact" do
      
      before :each do
        post url, post_attr
      end

      it{ expect( last_response.status ).to be == 201 }

      it{ expect( json ).to have_key :contact }
      # it{ expect( json ).to have_key :location }

      # it{ expect( json[:contact] ).to have_key :location_id }
      # it{ expect( json[:location] ).to have_key :id }
      # it{ expect( json[:location].street ).to eq(@location.street) }

    end

    # describe "looks for existing mail adresses" do

    #   before :each do
    #     @customer = create(:customer)
    #     @contact = @customer.contacts.create(firstname: "John", email: "test@test.com")
    #    post(url, { contact: { 
    #     firstname: "customer", 
    #     email: "test@test.com", 
    #     location_id: @location.id } } );
    #   end

    #   it{ expect( last_response.status ).to be == 201 }
    #   it{ expect( json[:customer].id ).to eq @customer.id.to_s }
    #   it{ expect( json[:contact].id ).to eq @contact.id.to_s }

    # end

  end

  describe "PUT /contacts/:id" do

    let(:contact){ create(:contact) }

    before :each do
      header 'Authorization', "Bearer #{user.aquire_api_key.token}"
      header 'Organization-id', user.organizations.first
    end

    describe "update" do

      describe "email" do

        let(:mail_address){ "t@test.com" }

        before :each do
          put "v1/contacts/#{contact.id}", { contact: { email: mail_address } }
        end

        it { expect( last_response.status ).to eq(200) }
        it { expect( json.contact.email ).to eq( mail_address ) }

      end

      describe "firstname" do

        let(:firstname){ "another customer" }

        before :each do
          put "v1/contacts/#{contact.id}", { contact: { firstname: firstname } }
        end

        it { expect( last_response.status ).to eq(200) }
        it { expect( json.contact.firstname ).to eq( firstname ) }

        # it { expect( last_response.status ).to eq(400) }
        # it { expect( json.error ).to eq( "EmailAlreadyTaken" ) }

      end

    end

  end

  describe "DELETE /contacts/:id" do

    let(:contact){ create(:contact) }

    before :each do
      header 'Authorization', "Bearer #{user.aquire_api_key.token}"
      header 'Organization-id', user.organizations.first
      delete "v1/contacts/#{contact.id}"
    end

    it{ expect( last_response.status ).to be == 200 }
    it{ expect( json ).to eq({}) }

  end

end

