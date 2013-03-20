require 'securerandom'

class User < ActiveRecord::Base
  attr_accessible :email

  # Validations
  validates :email, presence: true, uniqueness: true
  validates :token, presence: true

  # Associations
  has_many :feeds
  has_many :items, through: :feeds

  serialize :readability_access_token, Hash

  before_validation do
    self.token = SecureRandom.hex
  end

  def self.authenticate(token)
    User.where(token: token).first
  end

  def subscribe_to(url)
    Subscription.new(url, user: self).subscribe
  end

  def readability_authorized?
    readability_access_token.present?
  end

  def readability
    raise 'Readability not authorized' unless readability_authorized?
    @readability ||= Readit::API.new readability_access_token[:token], readability_access_token[:secret]
  end

  def entity
    Entity.new(self)
  end

  class Entity < Grape::Entity
    expose :email
    expose :token
  end
end
