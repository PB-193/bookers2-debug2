class Book < ApplicationRecord
  
  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy

  
  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end

  validates :title,presence: true
  validates :body,{presence: true, length:{maximum: 200} }
  
def self.search_for(content, method)
  if method == 'perfect'
    Book.where('title = ?', content.to_s)
  elsif method == 'forward'
    Book.where('title LIKE ?', content.to_s + '%')
  elsif method == 'backward'
    Book.where('title LIKE ?', '%' + content.to_s)
  else
    Book.where('title LIKE ?', '%' + content.to_s + '%')
  end
end

  
end
