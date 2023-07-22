class User < ApplicationRecord
    has_secure_password

    validates :account_name,
    length: {maximum: 64, too_long: "%{attribute}は%{count}文字以下で入力してください"},
    presence: true
end