require 'securerandom'

class User < ActiveRecord::Base
  autoload :Readability, 'models/user/readability'

  attr_accessible :email

  # Validations
  validates :email, presence: true, uniqueness: true
  validates :token, presence: true

  # Associations
  has_many :feeds
  has_many :items, through: :feeds

  serialize :readability, Readability

  before_validation do
    self.token = SecureRandom.hex
  end

  def self.authenticate(token)
    return nil unless token.present?
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
