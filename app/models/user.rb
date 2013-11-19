class User
  include Mongoid::Document
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  devise :omniauthable, :omniauth_providers => [:facebook]

  ## Database authenticatable
  field :email,                   :type => String, :default => ""
  field :encrypted_password,      :type => String, :default => ""

  # Facebook
  field :provider,                :type => String
  field :access_token,            :type => String
  field :uid,                     :type => String
  field :name,                    :type => String
  field :picture,                 :type => String
  field :country,                 :type => String

  ## Recoverable
  field :reset_password_token,    :type => String
  field :reset_password_sent_at,  :type => Time

  ## Rememberable
  field :remember_created_at,     :type => Time

  ## Trackable
  field :sign_in_count,           :type => Integer, :default => 0
  field :current_sign_in_at,      :type => Time
  field :last_sign_in_at,         :type => Time
  field :current_sign_in_ip,      :type => String
  field :last_sign_in_ip,         :type => String

  ## Data
  field :position,                :type => Array, :default => []

  ## Confirmable
  # field :confirmation_token,   :type => String
  # field :confirmed_at,         :type => Time
  # field :confirmation_sent_at, :type => Time
  # field :unconfirmed_email,    :type => String # Only if using reconfirmable

  ## Lockable
  # field :failed_attempts, :type => Integer, :default => 0 # Only if lock strategy is :failed_attempts
  # field :unlock_token,    :type => String # Only if unlock strategy is :email or :both
  # field :locked_at,       :type => Time

  POSITION_OPTIONS = ["Goalkeeper", "Defence", "Midfield", "Attack"]

  before_validation do |model|
    model.position.reject!(&:blank?) if model.position
  end

  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    unless user
      facebook_user = FbGraph::User.fetch(:me, access_token: auth.credentials.token)

      user = User.create!(name:facebook_user.name,
                          access_token: facebook_user.access_token.to_s,
                          provider:"facebook",
                          country: ( facebook_user.location.present? ? facebook_user.location.name.split(", ").last : "Israel"),
                          picture: facebook_user.picture,
                          uid:facebook_user.identifier,
                          email:facebook_user.email,
                          password:Devise.friendly_token[0,20])
    end
    user
  end
end
