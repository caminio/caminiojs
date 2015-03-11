module Caminio

  module V1

    class Contacts < Grape::API

      default_format :json
      helpers Caminio::AuthHelper
      helpers ContactHelper

      before { authenticate! }

      #
      # POST /
      #
      desc "create a new contact"
      params do
        requires :contact, type: Hash do
          optional :organization
          optional :firstname
          optional :lastname
          optional :degree
          optional :gender
          optional :phone
          requires :email
        end
      end
      post do
        customer = get_customer!
        location = Location.where( id: params.contact[:location_id] ).first
        error! 'NoParentIdGiven', 400 unless customer
        contact = get_contact! customer
        present :contact, contact, with: TicketeerContactEntity
        present :location, location, with: LocationEntity
        present :customer, customer, with: TicketeerCustomerEntity
      end

      #
      # PUT /:id
      #
      desc "update an existing contact"
      params do
        requires :contact, type: Hash do
          optional :organization
          optional :firstname
          optional :lastname
          optional :degree
          optional :gender
          optional :email
          optional :phone
          optional :billing
          optional :shipping
          optional :location_id 
        end
        requires :customer_id
      end
      put '/:id' do
        authenticate!
        check_email_address!
        customer = TicketeerCustomer.where(id: params.customer_id).first
        location = Location.where( id: params.contact[:location_id] ).first
        contact = customer.contacts.where( id: params.id ).first
        error! "TicketeerContactNotFound", 404 unless contact
        contact.update_attributes( declared(params)[:contact] )
        present :contact, contact.reload, with: TicketeerContactEntity
        present :location, location, with: LocationEntity
        present :customer, customer, with: TicketeerCustomerEntity
      end

      #
      # DELETE /:id
      #
      params do
        requires :customer_id
      end
      desc "delete an contact"
      formatter :json, lambda{ |o,env| "{}" }
      delete '/:id' do
        authenticate!
        customer = TicketeerCustomer.where(id: params.customer_id).first
        contact = customer.contacts.where( id: params.id ).first
        error! "TicketeerContactNotFound", 404 unless contact
        error!("DeletionFailed",500) unless contact.destroy
      end

    end
  end
end