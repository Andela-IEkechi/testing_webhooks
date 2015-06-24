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
    it "sets a flash message if the project is blocked" do
      get :show, @params
      expect(flash[:alert]).to eq("#{@project.to_s} can not be accessed due to outstanding payment.")
    end

    it "redirects if the project is blocked" do
      get :show, @params
      expect(response).to redirect_to projects_path
    end

    it "allows access if the project is not blocked" do
      @user.account.unblock!
      get :show, @params
      expect(response).to render_template("show")
    end
  end

  context "member" do
    before(:each) do
      @project.user_id = other_user.id
      @project.memberships << member
      @project.save
    end

    it "sets a flash message if the project is blocked" do
      @project.user.account.block!
      get :show, @params
      expect(flash[:notice]).to eq("#{@project.to_s} is currently unavailable.")
    end

    it "redirects if the project is blocked" do
      @project.user.account.block!
      get :show, @params
      expect(response).to redirect_to projects_path
    end

    it "allows access if the project is not blocked" do
      @project.user.account.unblock!
      get :show, @params
      expect(response).to render_template("show")
    end
  end
end

