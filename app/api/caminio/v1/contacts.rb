module Caminio

  module V1

    class Contacts < Grape::API

      default_format :json
      helpers Caminio::AuthHelper
      helpers ContactHelper

      before { authenticate! }

      #
      # GET /
      #
      desc "lists all ticketeer_customers"
      get '/' do
        present :contacts, Contact.all, with: ContactEntity
      end

      #
      # GET /:id
      #
      desc "returns ticketeer_customer with :id"
      get '/:id' do
        contact = Contact.find params.id
        error!('NotFound',404) unless contact
        present :contact, contact, with: ContactEntity
      end

      #
      # POST /
      #
      desc "create a new contact"
      params do
        requires :contact, type: Hash do
          optional :company
          optional :firstname
          optional :lastname
          optional :degree
          optional :gender
          optional :phone
          requires :email
        end
      end
      post do
        contact = Contact.new( declared( params )[:contact] )
        error!({ error: 'SavingFailed', details: contact.errors.full_messages}, 422) unless contact.save
        present :contact, contact, with: ContactEntity
      end

      #
      # PUT /:id
      #
      desc "update an existing contact"
      params do
        requires :contact, type: Hash do
          optional :company
          optional :firstname
          optional :lastname
          optional :degree
          optional :gender
          optional :phone
          optional :email
        end
      end
      put '/:id' do        
        contact = Contact.find params.id
        error!('NotFound',404) unless contact
        contact.update_attributes( declared(params)[:contact] )
        present :contact, contact, with: ContactEntity
      end

      #
      # DELETE /:id
      #
      desc "delete an contact"
      formatter :json, lambda{ |o,env| "{}" }
      delete '/:id' do
        contact = Contact.find params.id
        error!('NotFound',404) unless contact
        error!("DeletionFailed",500) unless contact.destroy
      end

    end
  end
end