class Account < ActiveRecord::Base
  belongs_to :user
  has_many :lists
  has_many :account_invitations
  has_many :memberships
  has_many :members, through: :memberships, source: :user
  validates_uniqueness_of :name, scope: [:user_id]

  attachment :header_image

  extend FriendlyId

  friendly_id :name, use: :scoped, scope: [:user]

  # THESE ARE ENUMS, CANNOT BE CHANGED
  FONTS = {
    system_sans_serif: 0,
    sans_serif: 1,
    serif: 2,
    system_serif: 3,
    code: 4,
    courier: 5,
    helvetica: 6,
    avenir: 7,
    athelas: 8,
    georgia: 9,
    times: 10,
    bodoni: 11,
    calisto: 12,
    garamond: 13,
    baskerville: 14,
  }

  enum host_status: {empty: 0, added: 1, confirmed: 2}
  as_enum :header_font, FONTS, source: :header_font, prefix: true, with: []
  as_enum :header_subtitle_font, FONTS, source: :header_subtitle_font, prefix: true
  as_enum :list_header_font, FONTS, source: :list_header_font, prefix: true

  def self.hosts
    Account.where.not(host: nil).pluck(:host, :id).to_h
  end

  def self.slugs
    Account.pluck(:slug, :id).to_h
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
  def lists_per_page
    25
  end

  def links
    []
  end

  def nav_title
    name
  end

  def disclosure_template
    list_affiliate_disclosure || <<-DEFAULT_DISCLOSURE_TEMPLATE
      <strong>{{site_name}}</strong> participates in affiliate programs. We may receive commissions
      if you purchase an item via links on this page to affiliate partner sites.
      Buying products through these links helps us grow and write better content in the
      future. <a href='/about'>Read more about what we do.</a>
    DEFAULT_DISCLOSURE_TEMPLATE
  end

  def disclosure
    @disclosure ||= Liquid::Template.parse(disclosure_template).render({
        'site_name' => name
      })
  end
end
