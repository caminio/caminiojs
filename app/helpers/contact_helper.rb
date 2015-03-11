module ContactHelper
    
  def get_contact! customer
    contacts = customer.ticketeer_contacts
    contact = contacts.where( email: params.ticketeer_contact.email ).first
    if contact == nil
      contact = contacts.new( declared( params )[:ticketeer_contact] ) 
      error!({ error: 'SavingFailed', details: contact.errors.full_messages}, 422) unless contact.save
    else
      contact.update_attributes( declared(params)[:ticketeer_contact] )
    end
    contact
  end

  def get_customer! 
    if params.ticketeer_customer_id
      TicketeerCustomer.where(id: params.ticketeer_customer_id).first
    else
      customer = find_contact_by_email
      customer = TicketeerCustomer.new() unless customer
      customer
    end
  end

  def check_email_address!
    error!({ error: 'EmailAlreadyTaken' }, 400 ) unless find_contact_by_email.nil?
  end

  def find_contact_by_email
    TicketeerCustomer.elem_match( ticketeer_contacts: { email: params.ticketeer_contact.email }).first
  end

end