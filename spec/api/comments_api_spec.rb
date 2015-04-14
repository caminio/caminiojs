# require 'spec_helper'

# describe Caminio::V1::Comments do

#   include APIHelper

#   classname = "comment"
#   pluralized_classname = classname.pluralize

#   before :each do
#     create_user_and_set_header
#     set_class classname
#   end

#   describe "GET /#{pluralized_classname}" do
#     it "returns #{classname}s json" do
#       get_test
#     end
#   end

#   describe "GET /#{pluralized_classname}/:id" do
#     it "returns #{classname} json" do
#       get_id_test
#     end
#   end

#   describe "POST /#{pluralized_classname}" do
#     it "creates a #{classname}" do
#       post_error_400 'comment is missing' 
#       post_attr( { comment: { title: "a comment", content: "the discription" } } )
#       post_test
#     end
#   end

#   describe "PUT /#{pluralized_classname}/:id" do
#       it "updates a #{classname}" do
#         put_attr({ comment: { title: "another title" } })
#         put_test
#       end
#   end

#   describe "DELETE /#{classname}/:id" do
#     it "deletes a #{classname}" do
#       delete_test
#     end
#   end

# end

