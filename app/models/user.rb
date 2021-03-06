class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable

  has_many :papers
  has_many :corrections, dependent: :destroy

  def has_corrections?
    if Correction.where(user: self).where("grade = 1.0").count > 0
      return true
    else
      return false
    end
  end

  def self.available_correctors(ids)
    User.where("id NOT IN (?)", ids)
  end

  def self.find_grade(corrector, paper_id)
    @grade ||= corrector.corrections.where("paper_id = ?", paper_id).first.grade
  end

  def calculate_score
    self.score = Paper.where('user_id = ? and grade != 0', id).average(:grade).to_f
    self.save
  end

end
