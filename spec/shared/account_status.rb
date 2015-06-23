shared_examples("account_status") do
  subject(:other_user)  {create(:user)}
  subject(:member)      {create(:membership, :user_id => @user.id)}

  before(:each) do
    @user.account.block!
  end

  context "owner" do
    before(:each) do
      @project.user_id = @user.id
      @project.save
    end
    it "should return a flash message if the project is blocked" do
      get :show, @params
      flash[:alert].should =~ /Project can not be accessed due to outstanding payment./i
    end

    it "should redirect if the project is blocked" do
      @project.user_id = @user.id
      get :show, @params
      response.should be_redirect
    end

    it "should allow access if the project is not blocked" do
      @user.account.unblock!
      @project.user_id = @user.id
      get :show, @params
      response.should render_template("show")
    end
  end

  context "member" do
    before(:each) do
      @project.user_id = other_user.id
      @project.memberships<< member
      @project.save
    end
    it "should return a flash message if the project is blocked" do      
      get :show, @params
      flash[:notice].should =~ /Project is currently unavailable./i
    end

    it "should redirect if the project is blocked" do
      get :show, @params
      response.should be_redirect
    end

    it "should allow access if the project is not blocked" do
      @project.user.account.unblock!
      get :show, @params
      response.should render_template("show")
    end
  end
end