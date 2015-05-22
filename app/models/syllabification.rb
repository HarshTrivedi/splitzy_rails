class Syllabification < ActiveRecord::Base
  belongs_to :word
  belongs_to :user
end
