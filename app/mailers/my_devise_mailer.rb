class MyDeviseMailer < Devise::Mailer
  helper :application # gives access to all helpers defined within `application_helper`.
  include Devise::Controllers::UrlHelpers # Optional. eg. `confirmation_url`
  default template_path: 'devise/mailer' # to make sure that your mailer uses the devise views

  def invitation_instructions(resource, token, opts={})
    invited_by = resource.invited_by
    invited_by_email = invited_by.email
    invited_to_account = Account.joins(:memberships).where(memberships: {user_id: resource.id, created_by_id: invited_by.id}).limit(1).first.try(:name)
    opts[:subject] = "#{invited_to_account} Invitation from #{invited_by_email}"
    super
  end
end
