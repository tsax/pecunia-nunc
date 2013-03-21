class Subscriber < ActiveRecord::Base
  attr_accessible :active, :email, :name, :token
end
