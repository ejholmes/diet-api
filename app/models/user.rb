require 'securerandom'

class User < ActiveRecord::Base
  include Grape::Entity::DSL

  autoload :Readability, 'models/user/readability'

  attr_accessible :email, :password

  # Validations
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true
  validates :token, presence: true

  # Associations
  has_many :feeds
  has_many :items, through: :feeds

  serialize :readability, Readability

  before_validation on: :create do
    self.token = SecureRandom.hex
  end

  def subscribe_to(url)
    Subscription.new(url, user: self).subscribe
  end

  def entity
    Entity.new(self)
  end

  entity :email, :token do
    expose :readability, using: User::Readability::Entity
  end
end
