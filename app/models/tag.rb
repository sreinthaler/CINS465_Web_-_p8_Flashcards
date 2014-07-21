class Tag < ActiveRecord::Base
  belongs_to :deck

  validates :tag_string,
    presence: {message: "Tag cannot be blank."}

end
