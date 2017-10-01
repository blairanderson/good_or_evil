def login
  # visit '/users/sign_up'
  # fill_in 'Email', with: 'a@a.com'
  # fill_in 'Password', with: '12345678'
  # fill_in 'Password confirmation', with: '12345678'
  # click_button 'Sign up'

  user = User.create(email: 'a@a.com', password: '12345678', password_confirmation: '12345678')
  login_as(user)
  return user
end