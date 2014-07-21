class Card < ActiveRecord::Base
  belongs_to :deck

  validates :front,
    presence: {message: "Question cannot be blank."}

  validates :back,
    presence: {message: "Answer cannot be blank."}

end
