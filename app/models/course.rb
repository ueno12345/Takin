class Course < ApplicationRecord
  has_many :assignments, dependent: :destroy
end
