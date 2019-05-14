class Team < ApplicationRecord
  include FriendlyId
  friendly_id :name

  validates :name, presence: true, uniqueness: true

  validate :is_owner_teammember, on: :change_owner
  # with_options on: :change_owner do
  #   validate :is_owner_teammember on: :change_owner
  # end

  belongs_to :owner, class_name: 'User', foreign_key: :owner_id
  has_many :assigns, dependent: :destroy
  has_many :members, through: :assigns, source: :user
  has_many :articles, dependent: :destroy
  has_many :agendas, dependent: :destroy
  has_many :users, foreign_key: :keep_team_id
  mount_uploader :icon, ImageUploader

  def invite_member(user)
    assigns.create(user: user)
  end

  def invite_member_based_on_email(email)
    user = User.find_by(email: email.downcase)

    if user.present?
      assigns.create(user: user)
    else
      #「assigns.create」の先で失敗する（＝Assignレコードにエラーメッセージ格納して返す）こともあるので、
      #こちらの失敗でも【Assignレコードにエラーメッセージ格納して返す】
      assigns = Assign.new
      assigns.errors.add(" ","メールアドレスに該当するユーザーが存在しません")
      return assigns
    end

  end

  def is_owner_teammember
    if Team.find(id).members.find_by(id:owner_id).nil?
      errors.add(" ","チームメンバーでない方をリーダーにしようとしています。")
    end

  end

end
