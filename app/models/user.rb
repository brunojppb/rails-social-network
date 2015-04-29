class User < ActiveRecord::Base

# Validations
  EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :name,  presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 }, format: { with: EMAIL_REGEX }, uniqueness: {case_sensitive: false}
  validates :password, length: { minimum: 6 }, allow_blank: true

  before_save { self.email.downcase! }
# Adds password and password confirmation
  has_secure_password

  attr_accessor :remember_token

  # Generate and update the remember digest
  def remember
    # store virtually the new token
    self.remember_token = User.new_token
    # save the hash digest of the token on the database
    self.update_attribute(:remember_digest, User.digest(self.remember_token))
  end

  def forget
    self.update_attribute(:remember_digest, nil)
  end

  # Check if the remember_token passed is the same of
  # the stored on the database
  def authenticated?(remember_token)
    return false if self.remember_digest.nil?
    BCrypt::Password.new(self.remember_digest) == remember_token
  end


  # Class methods
  # encrypt the string and return its hash digest
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # Generates a random token
  def User.new_token
    SecureRandom.urlsafe_base64
  end

end
