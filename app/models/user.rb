class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable, omniauth_providers: %i[google_oauth2]

  def self.from_omniauth(access_token)
    data = access_token.info
    user = User.where(email: data["email"]).first

    # Create a new user if one doesn't exist
    unless user
      user = User.create(
        email: data["email"],
        password: Devise.friendly_token[0, 20], # Generate a random password
        name: data["name"]
      )
    end

    user
  end
end
