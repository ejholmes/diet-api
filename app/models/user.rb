require 'securerandom'

class User < ActiveRecord::Base
  attr_accessible :email

  # Validations
  validates :email, presence: true, uniqueness: true
  validates :token, presence: true

  # Associations
  has_many :feeds
  has_many :items, through: :feeds

  serialize :readability, Hash

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

  def readability
    @readability ||= Readability.new(read_attribute(:readability))
  end

  def entity
    Entity.new(self)
  end

  class Readability < Hash
    attr_reader :hash

    def initialize(hash)
      replace(hash || Hash.new)
    end

    def token
      credentials[:token]
    end

    def token=(token)
      credentials[:token] = token
    end

    def secret
      credentials[:secret]
    end

    def secret=(secret)
      credentials[:secret] = secret
    end

    def authorized?
      token.present? && secret.present?
    end

    def enabled?
      authorized? && self[:enabled]
    end

    def client
      @client ||= Readit::API.new token, secret
    end

  private

    def credentials
      self[:credentials] ||= Hash.new
    end

  end

  class Entity < Grape::Entity
    expose :email
    expose :token
  end
end
