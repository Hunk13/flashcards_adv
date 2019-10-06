require 'super_memo'

class Card < ActiveRecord::Base
  belongs_to :user
  belongs_to :block
  before_validation :set_review_date_as_now, on: :create
  validate :texts_are_not_equal
  validates :original_text, :translated_text, :review_date, :user_id,
            :block_id, :interval, :repeat, :efactor, :quality, :attempt,
            presence: true

  mount_uploader :image, CardImageUploader

  scope :pending, -> { where('review_date <= ?', Time.now).order(Arel.sql('RANDOM()')) }
  scope :repeating, -> { where('quality < ?', 4).order(Arel.sql('RANDOM()')) }

  def check_translation(user_translation)
    distance = Levenshtein.distance(full_downcase(translated_text),
                                    full_downcase(user_translation))

    sm_hash = SuperMemo.algorithm(interval, repeat, efactor, attempt, distance, 1)

    if distance <= 1
      sm_hash.merge!({ review_date: Time.now + interval.to_i.days, attempt: 1 })
      update(sm_hash)
      { state: true, distance: distance }
    else
      sm_hash.merge!({ attempt: [attempt + 1, 5].min })
      update(sm_hash)
      { state: false, distance: distance }
    end
  end

  protected

  def set_review_date_as_now
    self.review_date = Time.now
  end

  def texts_are_not_equal
    if full_downcase(original_text) == full_downcase(translated_text)
      errors.add(:original_text, I18n.t("duplicate_error"))
    end
  end

  def full_downcase(str)
    str.mb_chars.downcase.to_s.squeeze(' ').lstrip
  end
end
