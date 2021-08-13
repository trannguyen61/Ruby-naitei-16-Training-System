class User < ApplicationRecord
  POST_ATTRS = %i(name email gender
    password password_confirmation).freeze
  PASSWORD_ATTRS = %i(password password_confirmation).freeze

  enum gender: {unknown: 0, male: 1, female: 2}, _prefix: :gender
  enum role: {trainee: 0, supervisor: 1, admin: 2}, _prefix: :role

  attr_accessor :remember_token, :activation_token, :reset_token

  has_one :trainee_info, dependent: :destroy
  has_many :enrollments, dependent: :destroy
  has_many :statuses, dependent: :destroy
  has_many :courses, through: :enrollments
  has_many :subjects, through: :statuses,
            source: :finishable, source_type: Subject.name
  has_many :tasks, through: :statuses,
            source: :finishable, source_type: Task.name

  before_save :downcase_email
  before_create :create_activation_digest
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

  has_secure_password

  def create_trainee
    create_trainee_info! if role_trainee?
  end
end
