require 'securerandom'

class User < ActiveRecord::Base
  attr_accessible :email

  validates :email, presence: true, uniqueness: true
  validates :token, presence: true

  before_validation do
    self.token = SecureRandom.hex
  end

  def self.authenticate(token)
    User.where(token: token).first
  end

  def entity
    Entity.new(self)
  end

  class Entity < Grape::Entity
    expose :email
    expose :token
  end
end
