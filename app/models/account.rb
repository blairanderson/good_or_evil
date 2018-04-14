class Account < ActiveRecord::Base
  belongs_to :user
  has_many :lists
  validates_uniqueness_of :name, scope: [:user_id]

  attachment :header_image

  extend FriendlyId

  friendly_id :name, use: :scoped, scope: [:user]

  enum({
      host_status: {empty: 0, added: 1, confirmed: 2}
    })

  def self.hosts
    Account.where.not(host: nil).pluck(:host, :id).to_h
  end

  def self.slugs
    Account.pluck(:slug, :id).to_h
  end

  def confirm_domain

  end

  def update_domain_info
    update!(domain_info: fetch_domain_info)
  end

  def fetch_domain_info
    raise(ArgumentError.new("HOST is required!")) if host.blank?
    heroku.domain.info('aawbuilder', host)
  end

  def heroku
    @heroku ||= PlatformAPI.connect_oauth(ENV.fetch('HEROKU_AUTH'))
  end

  # PUBLIC STUFF!
  def google_tag_manager
    nil
  end

  def lists_per_page
    25
  end

  def links
    []
  end

  def nav_title
    name
  end

  def header_subtitle
    nil
  end
end
