class Micropost < ApplicationRecord
  CONTENT_ATTRIBUTES = %i(content image).freeze

  belongs_to :user
  has_one_attached :image do |attach|
    attach.variant :display,
                   resize_to_limit: [Settings.digit_200, Settings.digit_200]
  end

  validates :content, presence: true, length: {maximum: Settings.digit_140}
  validates :image, content_type: {in: Settings.image_types,
                                   message: I18n.t("microposts.image.valid")},
                    size: {less_than: Settings.max_image_size.megabytes,
                           message: I18n.t("microposts.image.limit_size",
                                           size: Settings.max_image_size)}

  scope :newest, ->{order created_at: :desc}
end
