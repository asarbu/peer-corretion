class Paper < ActiveRecord::Base
    belongs_to :user
    has_many :corrections, dependent: :destroy
    has_attached_file :paper_file
    validates_attachment_content_type :paper_file, content_type: /(.*).[doc|txt|docx|pdf]/

    def grade_it
      grade = Correction.where(user_id: user_id).average(:grade)
      save
    end

end
