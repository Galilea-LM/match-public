# == Schema Information
#
# Table name: projects
#
#  id           :bigint(8)        not null, primary key
#  name         :string
#  description  :text
#  repositories :text
#  features     :text
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  match_id     :bigint(8)
#  team_id      :bigint(8)
#  score        :integer          default(0)
#

class Project < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  belongs_to :match
  belongs_to :team

  validate :belongs_to_project_match?
  validates :name, uniqueness: { case_sensitive: false }
  validates :name, :description, :features, presence: true

  has_many :feedbacks, as: :commentable, dependent: :destroy

  before_update :match_valid?

  def belongs_to_project_match?
    errors.add(:match_id, I18n.t('errors.no_project_match')) if match&.match_type != 'Project'
  end

  def match_valid?
    raise 'Project can only exist in project matches' if match.match_type != 'Project'
  end

  def should_generate_new_friendly_id?
    name_changed?
  end

  def users
    team.users
  end
end
