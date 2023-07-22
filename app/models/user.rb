class User < ApplicationRecord

    validates :account_name,
    uniqueness: true,
    length: {maximum: 64, too_long: "%{attribute}は%{count}文字以下で入力してください"},
    format: {with: /\A[a-zA-Z0-9]+\z/, message: "%{attribute}は半角英数字で入力してください"},
    presence: true
    validates :password,
    format: {with: /\A[a-zA-Z0-9]+\z/, message: "%{attribute}は半角英数字で入力してください"}
    has_secure_password
end