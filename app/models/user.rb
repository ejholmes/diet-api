require 'securerandom'

class User < ActiveRecord::Base
  attr_accessible :email

  # Validations
  validates :email, presence: true, uniqueness: true
  validates :token, presence: true

  # Associations
  has_many :feeds
  has_many :items, through: :feeds

  before_validation do
    self.token = SecureRandom.hex
  end

  def self.authenticate(token)
    User.where(token: token).first
  end

  def subscribe_to(url)
    Subscription.new(url, user: self).subscribe
  end

  def entity
    Entity.new(self)
  end

  class Entity < Grape::Entity
    expose :email
    expose :token
  end
end
