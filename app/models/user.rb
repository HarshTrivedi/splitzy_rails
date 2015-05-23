class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
        :recoverable, :rememberable, :trackable, :validatable
  has_many :syllabifications

  def words
  		self.syllabifications.map{|syllabification| syllabification.word}.compact.uniq
  end

end
