class User < ApplicationRecord
  before_save :downcase_email

  validates :name, presence: true, length: {maximum: Settings.max_name_length}
  validates :email, presence: true,
                    length: {maximum: Settings.max_email_length},
                    format: {with: Regexp.new(Settings.valid_email_regex, "i")},
                    uniqueness: true
  has_secure_password
  validates :password, presence: true,
                    length: {minimum: Settings.min_password_length}

  private

  def downcase_email
    email.downcase!
  end
end
