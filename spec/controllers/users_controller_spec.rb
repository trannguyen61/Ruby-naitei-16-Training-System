require "rails_helper"

RSpec.shared_examples "Users method correct_user" do |method, action|
  before do
    sign_in trainee
    another_trainee = FactoryBot.create :trainee
    send(method, action, params: {id: another_trainee, user: attributes_for(:trainee)})
  end

  it{expect(response).to redirect_to root_url}
end


RSpec.describe UsersController, type: :controller do
  let(:trainee){FactoryBot.create :trainee}
  let(:supervisor){FactoryBot.create :supervisor}

  describe "GET #new" do
    before do
      get :new
    end
    
    it{expect(assigns(:user)).to be_a_new(User)}

    it{expect(response).to render_template(:new)}
  end

  describe "POST #create" do
    context "with valid attributes" do
      let(:trainee_form) do
        build(:trainee).attributes
                        .merge({password: "123456", password_confirmation: "123456"})
      end

      subject{post :create, params: {user: trainee_form}}

      it{expect{subject}.to change {User.count}.by(1)}

      it do
        post :create, params: {user: trainee_form}
        expect(flash[:success]).to eq I18n.t("users.create.success_signup")
      end

      it do
        post :create, params: {user: trainee_form}
        expect(response).to redirect_to root_url
      end
    end

    context "with invalid attributes" do
      before do
        post :create, params: {user: build(:invalid_user).attributes}
      end

      subject{post :create, params: {user: build(:invalid_user).attributes}}

      it{expect{subject}.to_not change {User.count}}

      it{expect(flash[:error]).to eq I18n.t("users.create.fail_signup")}

      it{expect(response).to render_template(:new)}
    end
  end

  describe "GET #show" do
    before do
      sign_in trainee
      get :show, params: {id: trainee}
    end

    context "assigned correctly" do
      it{expect(assigns(:trainee).class).to eq(TraineeInfo)}
    end

    context "can't see other users" do
      before do
        get :show, params: {id: supervisor}
      end

      it{expect(flash[:danger]).to eq I18n.t("no_permission")}

      it{expect(response).to redirect_to root_url}
    end
  end

  describe "GET #edit" do
    before do
      sign_in trainee
      get :edit, params: {id: trainee}
    end

    it_behaves_like "Users method correct_user", :get, :edit

    it{expect(response).to render_template(:edit)}
  end

  describe "PATCH #update" do
    before{sign_in trainee}

    it_behaves_like "Users method correct_user", :patch, :update

    context "with valid attributes" do
      before do
        patch :update, params: {id: trainee, user: attributes_for(:trainee, name: "Name")}
        trainee.reload
      end

      it{expect(trainee.name).to eq("Name")}

      it{expect(flash[:success]).to eq I18n.t("users.update.profile_updated")}

      it{expect(response).to redirect_to edit_user_path(trainee)}
    end

    context "with invalid attributes" do
      before do
        patch :update, params: {id: trainee, user: attributes_for(:trainee, name: nil)}
        trainee.reload
      end

      it{expect(trainee.name).to_not eq(nil)}

      it{expect(flash[:danger]).to eq I18n.t("users.update.fail_updated")}

      it{expect(response).to render_template(:edit)}
    end

    context "update without password" do
      before do
        patch :update, params: {id: trainee, user: attributes_for(:trainee, name: "Name", password: nil)}
        trainee.reload
      end

      it{expect(trainee.name).to eq("Name")}

      it{expect(flash[:success]).to eq I18n.t("users.update.profile_updated")}

      it{expect(response).to redirect_to edit_user_path(trainee)}
    end
  end
end
