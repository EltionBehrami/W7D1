class User < ApplicationRecord 
    validates :username, :password_digest, :session_token, presence: true 
    validates :username, :session_token, uniqueness: true 
    validates :password, length: {minimum: 6, allow_nil: true}

    before_validation :ensure_session_token 
    attr_reader :password 

    def ensure_session_token 
        self.session_token ||= self.generate_unique_session_token
    end 

    def password=(password)
        @password = password 

        password_digest = BCrypt::Password.create(password)
    end 

    def is_password?(password) 
        password_object = BCrypt::Password.new(password_digest)
        password_object.is_password?(password)
    end 

    def self.find_by_credentials(username, password)
        user = User.find_by(username: username)
        if user && user.is_password?(password)
            user 
        else 
            nil
        end 
    end 

    def reset_session_token!
        session_token = self.generate_unique_session_token
        session_token.save! 
        session_token 
    end 

    private 

    def generate_unique_session_token
        SecureRandom::urlsafe_base64
    end 



end 