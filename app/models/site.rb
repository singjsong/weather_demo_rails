class Site < ApplicationRecord
  BILLING_STATUSES = %w(paid unpaid).freeze

  validates :name, presence: true
  validates :billing_status, inclusion: BILLING_STATUSES
end
