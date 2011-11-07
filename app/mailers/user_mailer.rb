class UserMailer < ActionMailer::Base
  default :from => "noreply@manistone.net"
  
  def welcome_email(user)
	@user = user
	mail(:to => user.email, :subject => "Welcome to Manistone") do |format|
		format.text
	end
  end
  
  def activation_email(user, activation_url)
    @user = user
	@activation_url = activation_url
	mail(:to => user.email, :subject => "Activate your Manistone account") do |format|
		format.text
	end
  end

  def password_reset_email(user, password_reset_url)
    @user = user
    @password_reset_url = password_reset_url

    mail(:to => user.email, :subject => "Manistone password reset") do |format|
      format.text
    end
  end
end
