require "rails_helper"
include SessionsHelper

RSpec.shared_examples "Load Enrollment" do |method, action|
  context "valid enrollment" do
    before do
      send(method, action, params: {id: enrollment})
    end

    it{expect(assigns(:enrollment)).to eq(enrollment)}
  end

  context "invalid enrollment" do
    before do
      send(method, action, params: {id: -1})
    end

    it{expect(flash[:danger]).to eq I18n.t("data_not_found")}
    it{expect(response).to redirect_to courses_path}
  end
end

RSpec.describe EnrollmentsController, type: :controller do
  let(:trainee){FactoryBot.create :trainee}
  let(:another_trainee){FactoryBot.create :trainee}
  let(:supervisor){FactoryBot.create :supervisor}
  let(:course){FactoryBot.create :course}
  let!(:enrollment){FactoryBot.create :enrollment, course: course, user: trainee}
  let!(:supervision){FactoryBot.create :supervision, course: course, user: supervisor}
  before{sign_in supervisor}
  describe "GET #show" do
    context "must load enrollment first" do
      it_behaves_like "Load Enrollment", :get, :show
    end

    context "load enrollment succesfully" do
      before do
        get :show, params: {id: enrollment}
      end
      it{expect(response).to render_template(:show)}
    end
  end

  describe "POST #create" do
    context "with invalid course" do
      before do
        post :create, params: {course_id: -1}
      end
      it{expect(flash[:danger]).to eq I18n.t("courses.invalid_course")}

      it{expect(response).to redirect_to courses_path}
    end

    context "with incorrect supervisor" do
      before do
        another_course = FactoryBot.create :course
        post :create, params: {course_id: another_course}
      end

      it{expect(flash[:danger]).to eq I18n.t("subjects.error.no_permission")}

      it{expect(response).to redirect_to courses_path}
    end

    context "with incorrect supervisor" do
      before do
        another_course = FactoryBot.create :course
        post :create, params: {course_id: another_course}
      end

      it{expect(flash[:danger]).to eq I18n.t("subjects.error.no_permission")}

      it{expect(response).to redirect_to courses_path}
    end

    context "with invalid email" do
      before do
        post :create, params: {course_id: course, email: ""}
      end

      it{expect(flash[:danger]).to eq I18n.t("not_found")}

      it{expect(response).to redirect_to course}
    end

    context "with incorrect supervisor" do
      before do
        another_course = FactoryBot.create :course

        post :create, params: {course_id: another_course}
      end

      it{expect(flash[:danger]).to eq I18n.t("subjects.error.no_permission")}

      it{expect(response).to redirect_to courses_path}
    end

    context "create successfully" do
      before do
        post :create, params: {course_id: course, email: another_trainee.email}
      end

      it{expect(flash[:success]).to eq I18n.t("add_member_success")}

      it{expect(response).to redirect_to course}
    end

    context "create unsuccessfully" do
      before do
        post :create, params: {course_id: course, email: supervisor.email}
      end

      it{expect(response).to redirect_to course}
    end

    context "Add duplicated member" do
      before do
        post :create, params: {course_id: course, email: trainee.email}
      end

      it{expect(flash[:danger]).to eq I18n.t("member_added")}
      it{expect(response).to redirect_to course}
    end
  end

  describe "DELETE #destroy" do
    context "must load enrollment first" do
      it_behaves_like "Load Enrollment", :delete, :destroy
    end

    context "destroy unsuccessfully" do
      let(:another_enrollment){FactoryBot.create :enrollment, course: course,
                                                 user: another_trainee}
      before do
        allow_any_instance_of(Enrollment).to receive(:destroy).and_return(false)
        delete :destroy, params: {id: another_enrollment.id, format: :html}
      end

      it do
        expect(flash[:danger]).to eq I18n.t("delete_member_fail")
      end

      it do
        expect(response).to redirect_to course
      end
    end

    context "destroy successfully" do

      before do
        delete :destroy, params: {id: enrollment.id, format: :html}
      end

      it do
        expect(flash[:success]).to eq I18n.t("delete_member_success")
      end

      it do
        expect(response).to redirect_to course
      end
    end
  end
end
