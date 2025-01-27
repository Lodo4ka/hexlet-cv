# frozen_string_literal: true

class Resume::Comment < ApplicationRecord
  include Resume::CommentRepository
  validates :content, presence: true, length: { minimum: 10, maximum: 400 }

  belongs_to :resume
  belongs_to :user
  has_many :notifications, as: :resource, dependent: :destroy

  def to_s
    content
  end

  def send_new_comment_email
    return nil unless resume.user.can_send_email? && resume.user.resume_mail_enabled

    ResumeCommentMailer.with(comment: self).new_comment_email.deliver_later
  end
end
