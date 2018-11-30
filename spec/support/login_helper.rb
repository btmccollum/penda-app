module LoginHelper

  def client_signup
    fill_in("client[username]", :with => "test01")
    fill_in("client[email]", :with => "test01@test.com")
    fill_in("client[first_name]", :with => "John")
    fill_in("client[last_name]", :with => "Tester")
    fill_in("client[password]", :with => "123")
    fill_in("client[password_confirmation]", :with => "123")
    click_button('Submit')
  end

  def business_signup
    fill_in("business[username]", :with => "biztest01")
    fill_in("business[email]", :with => "biztest01@test.com")
    fill_in("business[first_name]", :with => "Bizness")
    fill_in("business[last_name]", :with => "Man")
    fill_in("business[password]", :with => "123")
    fill_in("business[password_confirmation]", :with => "123")
    click_button('Submit')
  end

  def client_login
    fill_in("email", :with => "test01@test.com")
    fill_in("password", :with => "123")
    click_button('Log In')
  end

  def business_login
    fill_in("email", :with => "biztest01@test.com")
    fill_in("password", :with => "111111")
    click_button('Log In')
  end

  def create_client_user 
    @clienttest = User.create(
        username: "doodle", 
        email: "test@test.com", 
        first_name: "dudley", 
        last_name: "brown", 
        password: "123456", 
        password_confirmation: "123456", 
        type: "Client"
        )
  end

  def create_business_user
    @biztest = User.create(
        username: "testbiz", 
        email: "biztest01@test.com", 
        first_name: "Jane", 
        last_name: "Doe", 
        password: "111111", 
        password_confirmation: "111111", 
        type: "Business"
    )
  end
end