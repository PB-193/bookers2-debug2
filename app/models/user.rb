class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :books , dependent: :destroy
  has_many :favorites , dependent: :destroy
  has_many :book_comments , dependent: :destroy
  
  #「リレーション」
  # 下記active_relationshipsはアソシエーションが繋がっているテーブル名である
  # class_nameは実際のモデルの名前:Relationship
  # foreign_keyは外部キーとして何を持つかを表しています。

  #「has_many :テーブル名, through: :中間テーブル名」 の形を使って、テーブル同士が中間テーブルを通じてつながっていることを表現します。(followerテーブルとfollowedテーブルのつながりを表す）
  # 例えば、下記followersにfollowedを入れてしまうと、followedテーブルから中間テーブルを通ってfollowerテーブルにアクセスすることができなくなってしまいます。
  # これを防ぐために下記followersには架空のテーブル名を、zzzは実際にデータを取得しにいくテーブル名を書きます。
  #この結果、@user.上のfollowersとすることでそのユーザーがフォローしている人orフォローされている人の一覧を表示することができるようになります。

  # 自分がフォローされる（被フォロー）側の関係性
  has_many :reverse_of_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  # 被フォロー関係を通じて参照→自分をフォローしている人
  has_many :followers, through: :reverse_of_relationships, source: :follower
  
  # 自分がフォローする（与フォロー）側の関係性
  has_many :relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  # 与フォロー関係を通じて参照→自分がフォローしている人
  has_many :followings, through: :relationships, source: :followed



  has_one_attached :profile_image

  validates :name, length: { minimum: 2, maximum: 20 }, uniqueness: true
  validates :introduction, length: {maximum: 50} 
  
  def get_profile_image
    (profile_image.attached?) ? profile_image : 'no_image.jpg'
  end
  
  def follow(user)
    relationships.create(followed_id: user.id)
  end
  #(user)はなくてもいいが、可読性を上げるために記載するべき　※この場合、ユーザがフォロしているかどうか判定する意味である
  def unfollow(user)
    relationships.find_by(followed_id: user.id).destroy
  end
  # このメソッドでは、自分自身(self)が持っているrelationshipsという関連付けされたオブジェクトから、
  # followed_idが引数で指定されたユーザーのIDと一致するレコードを探しています。そのレコードをfind_byメソッドで取得し、destroyメソッドで削除しています。

  def following?(user)
    followings.include?(user)
  end
  #followingsという自分がフォローしているユーザーの集合に対して、include?メソッドを用いて、引数で渡されたユーザーが含まれているかどうかを判定しています。含まれている場合はtrueを、含まれていない場合はfalseを返します。


  #検索メソッド　検索分岐の
  
  def self.search_for(content, method)
    if method == 'perfect'
      User.where(name: content)
    elsif method == 'forward'
      User.where('name LIKE ?', content + '%')
    elsif method == 'backward'
      User.where('name LIKE ?', '%' + content)
    else
      User.where('name LIKE ?', '%' + content + '%')
    end
  end

end
