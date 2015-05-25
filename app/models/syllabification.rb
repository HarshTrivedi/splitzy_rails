class Syllabification < ActiveRecord::Base
  belongs_to :word , :counter_cache => true
  belongs_to :user

  validates :word, :presence => true

end
