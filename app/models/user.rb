class User < ApplicationRecord
  CREATE_ATTRS = %i(name email gender role
    password password_confirmation).freeze
  UPDATE_ATTRS = %i(name email gender date_of_birth address
    password password_confirmation).freeze
  PASSWORD_ATTRS = %i(password password_confirmation).freeze

  enum gender: {unknown: 0, male: 1, female: 2}, _prefix: :gender
  enum role: {trainee: 0, supervisor: 1, admin: 2}, _prefix: :role

  attr_accessor :remember_token, :activation_token, :reset_token

  has_one :trainee_info, dependent: :destroy
  has_many :enrollments, dependent: :destroy
  has_many :supervisions, dependent: :destroy
  has_many :statuses, dependent: :destroy
  has_many :courses, through: :enrollments
  has_many :subjects, through: :statuses,
            source: :finishable, source_type: Subject.name
  has_many :tasks, through: :statuses,
            source: :finishable, source_type: Task.name

  before_save :downcase_email
  after_create :create_trainee

  validates :name, :role, presence: true
  validates :email, presence: true,
            format: {with: Settings.user.email.valid_regex},
            uniqueness: {case_sensitive: false}
  validates :name, :email, :address,
            length: {maximum: Settings.string.length.max}
  validates :password, presence: true,
            length: {minimum: Settings.user.password.length.min},
            allow_nil: true

  validate :check_user_role, on: :create

  has_secure_password

  class << self
    def digest string
      check = ActiveModel::SecurePassword.min_cost
      cost = check ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
      BCrypt::Password.create(string, cost: cost)
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def remember
    self.remember_token = User.new_token
    update_attribute :remember_digest, User.digest(remember_token)
  end

  def authenticated? attribute, token
    digest = send("#{attribute}_digest")
    return false if digest.nil?

    BCrypt::Password.new(digest).is_password?(token)
  end

  def forget
    update_attribute :remember_digest, nil
  end

  def create_trainee
    create_trainee_info! if role_trainee?
  end

  def check_user_role
    return unless role_trainee? && role_supervisor?

    errors.add :role, :not_permitted_role
  end

  def create_supervision course_id
    supervision = Supervision.new course_id: course_id
    supervisions << supervision
  end

  private

  def downcase_email
    email.downcase!
  end
end
