class User < ActiveRecord::Base
  attr_accessor :login
  include VanitizeUrl
  rolify
  extend FriendlyId
  friendly_id :username, use: [:slugged, :finders]
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :username, :presence => true, :uniqueness => { :case_sensitive => false }

  has_one :profile, :dependent => :destroy
  accepts_nested_attributes_for :profile

  has_many :blog_posts, :dependent => :destroy
  has_many :pages, :dependent => :destroy

  def full_name
    "#{profile.first_name} #{profile.last_name}"
  end

  def should_generate_new_friendly_id?
    slug.blank? || username_changed?
  end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions.to_hash).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      where(conditions.to_hash).first
    end
  end

  private

end
