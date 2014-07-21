class Deck < ActiveRecord::Base
  belongs_to :user
  has_many :cards
  has_many :tags

  validates :title,
    presence: {message: "Title cannot be blank."}

  validates :subject,
    presence: {message: "Subject cannot be blank."}

end
