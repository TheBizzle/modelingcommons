require 'spec_helper'

describe AccountController do

  def mock_person(stubs={})
    @mock_person ||= mock_model(Person, stubs)
  end

  describe "new" do 
    it "should be possible to get a registration form" do 
      get :new
      response.should render_template("account/_user_agreement")
    end

  end

  describe "login" do 
    it "should be possible to get the login page" do 
      get :login
      response.should render_template('login')
    end
  end

  describe "login_action" do 

    before(:each) do 
      @request.env["HTTP_REFERER"] = '/account/login'
    end

    it "should not be possible to login with a blank username" do 

      post :login_action, :email_address => '', :password => 'password'

      response.should redirect_to(:controller => :account, :action => :login)
      flash[:notice].should == "You must provide an e-mail address and password in order to log in."
    end

    it "should not be possible to login with an unknown username" do 

      post :login_action, :email_address => 'foo@barbaz.com', :password => 'password'

      response.should redirect_to(:controller => :account, :action => :login)
      flash[:notice].should == "Sorry, but no user exists with that e-mail address and password.  Please try again."
    end


    it "should not be possible to login with a blank password" do 

      post :login_action, :email_address => 'reuven@lerner.co.il', :password => ''

      response.should redirect_to(:controller => :account, :action => :login)
      flash[:notice].should == "You must provide an e-mail address and password in order to log in."
    end

    it "should not be possible to login with a bad password" do 

      Person.stub(:find_by_email_address).and_return(mock_person(:salt => 'abc', :password => 'aaa'))

      post :login_action, :email_address => 'reuven@lerner.co.il', :password => 'password'

      response.should redirect_to(:controller => :account, :action => :login)
      flash[:notice].should == "Sorry, but no user exists with that e-mail address and password.  Please try again."
    end

    it "should be possible to login with a good password" do 
      Person.stub(:find_by_email_address).and_return(mock_person(:salt => 'abc', 
                                                                 :password => 'password',
                                                                 :first_name => 'Reuven',
                                                                 :last_name => 'Lerner'))
      Person.stub(:encrypted_password).and_return('password')

      post :login_action, :email_address => 'reuven@lerner.co.il', :password => 'password'

      response.should redirect_to(:controller => :account, :action => :mypage)
      flash[:notice].should == "Welcome back to the Commons, Reuven!"
    end
  end

  
  describe "mypage" do 
    it "going to personal page without being logged in sends to login" do 
      get :mypage
      response.should redirect_to(:controller => :account, :action => :login)
    end

  end

  describe "create" do 

    before(:each) do 
      @request.env["HTTP_REFERER"] = '/account/new'
    end

    it "should not create a new person without required fields" do 
      people_before = Person.count
      post :create
      Person.count.should == people_before
    end
  end

end