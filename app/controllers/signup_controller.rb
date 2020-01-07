class SignupController < ApplicationController

  def step1
    @user = User.new
  end

  def step2
    @user = User.new
  end

  def step3
    session[:nickname] = user_params[:nickname]
    session[:email] = user_params[:email]
    session[:password] = user_params[:password]
    session[:password_confirmation] = user_params[:password_confirmation]
    session[:last_name] = user_params[:last_name]
    session[:family_name] = user_params[:family_name]
    session[:last_name_kana] = user_params[:last_name_kana]
    session[:family_name_kana] = user_params[:family_name_kana]
    session[:birthday_year] = user_params[:birthday_year]
    session[:birthday_month] = user_params[:birthday_month]
    session[:birthday_day] = user_params[:birthday_day]
    @user = User.new
  end

  def step4
    session[:phonenumber] = user_params[:phonenumber]
    @user = User.new
  end

  def step5
    @user = User.new
    session[:addresses_attributes] = params[:user][:addresses]
  end

  def create
    @user = User.new(
      nickname: session[:nickname], # sessionに保存された値をインスタンスに渡す
      email: session[:email],
      password: session[:password],
      password_confirmation: session[:password_confirmation],
      last_name: session[:last_name], 
      family_name: session[:family_name], 
      last_name_kana: session[:last_name_kana], 
      family_name_kana: session[:family_name_kana], 
      birthday_year: session[:birthday_year],
      birthday_month: session[:birthday_month],
      birthday_day: session[:birthday_day],
      phonenumber: session[:phonenumber],
    )
    @user.build_address(session[:addresses_attributes])
    if @user.save
      session[:id] = @user.id  # ここでidをsessionに入れることでログイン状態に持っていける。
      redirect_to complete_signup_signup_index_path
    else
      render '/signup/step1'
    end
  end

  def complete_signup
    sign_in User.find(session[:id]) unless user_signed_in?
  end

  private
  def user_params
    params.require(:user).permit(
      :nickname,
      :email,
      :password, 
      :password_confirmation, 
      :family_name,
      :last_name, 
      :family_name_kana, 
      :last_name_kana, 
      :birthday_year, 
      :birthday_month, 
      :birthday_day,
      :phonenumber,
      addresses_attributes: [:id, :postal, :prefecture, :city, :address, :building]
    )
  end

end