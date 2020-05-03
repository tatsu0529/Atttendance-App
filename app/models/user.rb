class User < ApplicationRecord
  has_many :attendances, dependent: :destroy
  # remember_tokenと言う仮想の属性を作成する
  attr_accessor :remember_token
  #selfはユーザーオブジェクトを指している
  before_save { self.email = email.downcase }
  
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 100 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: true
  validates :affiliation, length: { in: 2..30 }, allow_blank: true
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
  
  validate :user_name_and_email_is_needed_to_edit
  
  # 渡された文字列のハッシュ値を返す
  def User.digest(string)
    cost = 
      if ActiveModel::SecurePassword.min_cost
        BCrypt::Engine::MIN_COST
      else
        BCrypt::Engine.cost
      end
    BCrypt::Password.create(string, cost: cost)
  end
  
  # ランダムなトークンを返す
  def User.new_token
    SecureRandom.urlsafe_base64
  end
  
  # 永続セッションのためハッシュ化したトークンをデータベースに記憶する
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end
  
  # トークンがダイジェストと一致すればtrueを返す
  def authenticated?(remember_token)
    # ダイジェストが存在しない場合はfalseを返して終了
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end 
  
  # ユーザーのログイン情報を破棄する
  def forget
    update_attribute(:remember_digest, nil)
  end
  
  def self.import(file)
  CSV.foreach(file.path,encoding: 'Shift_JIS:UTF-8', headers: true) do |row|
    user = new
    user.attributes = row.to_hash.slice(*updatable_attributes)
    user.save
    end
  end

  # 更新を許可するカラムを定義
  def self.updatable_attributes
   [ "name", "email", "affiliation", "employee_number", "password"]
    # ["name",	"email",	"affiliation",	"employee number",	"uid",	"basic time",	"designed work start time", "designed work finish time", "superior", "admin",	"password"]
  end
  
  def user_name_and_email_is_needed_to_edit
    if name.blank? || email.blank?
      errors.add(:name, "必須項目が抜けています。")
    end 
  end 
end

