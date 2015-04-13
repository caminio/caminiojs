module APIHelper

  def set_class classname
    @classname = classname
    @url_object = create(class_sym)
  end

  def get_user_id
    @current_user.id
  end

  def get_organization_id
    @current_user.organizations.first.id
  end

  def class_sym 
    @classname.to_sym
  end

  def class_plural_sym
    pluralized_classname.to_sym
  end

  def set_header user
    @current_user = user
    header 'Authorization', "Bearer #{user.aquire_api_key.token}"
    header 'Organization-id', user.organizations.first.id
  end

  def set_request_store
    RequestStore.store['current_user_id'] = get_user_id
    RequestStore.store['organization_id'] = get_organization_id
  end

  def create_user_and_set_header
    user = create(:user) 
    set_header user
  end

  def post_error_400 error
    @post_error_400 = error
  end

  def post_attr attributes
    @post_attr = attributes
  end

  def put_attr attributes
    @put_attr = attributes
  end

  def pluralized_classname 
    @classname.pluralize
  end

  def get_url
    "v1/"+pluralized_classname
  end

  def get_id_url
    get_url + "/#{@url_object.id}"
  end

  def get_test
    get get_url
    expect( last_response.status ).to be == 200
    expect( json ).to have_key(class_plural_sym)
  end

  def get_id_test
    get get_id_url
    expect( last_response.status ).to be == 200
    expect( json ).to have_key(class_sym)
    expect( json[@classname] ).to have_key(:id)
  end

  def post_test
    post get_url 
    expect( last_response.status ).to be == 400
    expect( json.error ).to be == @post_error_400 
    post get_url, @post_attr 
    expect( last_response.status ).to be == 201 
    expect( json ).to have_key class_sym
  end

  def put_test
    put get_id_url, @put_attr
    expect( last_response.status ).to eq(200)
    @put_attr[class_sym].each_pair do |key, value|
      if value.inspect.match(/BSON::ObjectId/)
        expect( json[class_sym][key] ).to match /#{value}/
      else
        expect( json[class_sym][key] ).to eq value
      end
    end
  end

  def delete_test
    delete get_id_url
    expect( last_response.status ).to be == 200 
    expect( json ).to eq({})
  end

end