require 'securerandom'
require 'bcrypt'

class User < ActiveRecord::Base
  include Grape::Entity::DSL

  autoload :Readability, 'models/user/readability'

  attr_accessible :email, :password

  # Validations
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true

  # Associations
  has_many :feeds
  has_many :items, through: :feeds

  serialize :readability, Readability

  def subscribe_to(url)
    Subscription.new(url, user: self).subscribe
  end

  def entity
    Entity.new(self)
  end

  def password=(password)
    write_attribute(:password, password_digest(password)) if password.present?
  end

  def valid_password?(password)
    return false if password.blank?
    bcrypt = ::BCrypt::Password.new(self.password)
    password = ::BCrypt::Engine.hash_secret(password, bcrypt.salt)
    self.password == password
  end

  entity :email do
    expose :readability, using: User::Readability::Entity
  end

private

  # Digests the password using bcrypt.
  def password_digest(password)
    ::BCrypt::Password.create(password).to_s
  end

end
