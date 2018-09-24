require 'sinatra/activerecord'
require 'pg'

set :database, 'postgresql:rumblr'

class User < ActiveRecord::Base
  has_many :posts, dependent: :destroy
  has_one :profile, dependent: :destroy
end

class Profile < ActiveRecord::Base
  belongs_to :user
end

class Post < ActiveRecord::Base
  belongs_to :user
end

class Comments < ActiveRecord::Base
  has_one :user
  has_one :post
end
