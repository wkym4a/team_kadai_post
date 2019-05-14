class Agenda < ApplicationRecord
  validates :title, length: { minimum: 1, maximum: 20 }
  belongs_to :team
  belongs_to :user
  has_many :articles, dependent: :destroy
end
