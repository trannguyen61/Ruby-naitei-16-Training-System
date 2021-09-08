require "rails_helper"
include SessionsHelper

RSpec.describe SubjectsController, type: :controller do
  let(:trainee){FactoryBot.create :trainee}
  let(:supervisor){FactoryBot.create :supervisor}
  let(:course){FactoryBot.create :course_with_subjects_tasks,
    subjects_count: 2, tasks_count: 2}
  let(:enrollment){FactoryBot.create :enrollment, course: course, user: trainee}
  let(:subjects){course.subjects}
  let!(:supervision){FactoryBot.create :supervision, course: course, user: supervisor}

  before :each do
    sign_in supervisor
  end

  describe "GET #show" do
    context "invalid subject" do
      before do
        get :show, params: {id: -1}
      end

      it{expect(flash[:danger]).to eq I18n.t("subjects.error.invalid_subject")}

      it{expect(response).to redirect_to courses_path}
    end

    context "valid subject" do
      it "assigns the requested contact to @subject" do
        get :show, params: {id: subjects.first.id}
        expect(assigns(:subject)).to eq(subjects.first)
      end

      it "renders the #show view" do
        get :show, params: {id: subjects.first.id}
        expect(response).to render_template :show
      end
    end
  end

  describe "POST #create" do
    context "with valid attributes" do
      before do
        post :create, params: {subject: build(:subject, course: course).attributes}
      end

      it{expect(flash[:success]).to eq I18n.t("subjects.create.success_create")}

      it{expect(response).to redirect_to course_path course.id}
    end

    context "with invalid attributes" do
      before do
        post :create, params: {subject: build(:invalid_subject, course: course).attributes}
      end

      it{expect(controller).to set_flash[:danger]}

      it{expect(response).to redirect_to course_path course.id}
    end
  end

  describe "PATCH #update" do
    context "with valid attributes" do
      before do
        patch :update, params: {id: subjects.first, subject: attributes_for(:subject)}
        subjects.first.reload
      end

      it{expect(flash[:success]).to eq I18n.t("subjects.update.success_updated")}

      it{expect(response).to redirect_to course}
    end

    context "with invalid attributes" do
      before do
        patch :update, params: {id: subjects.first, subject: attributes_for(:subject, length: 0)}
        subjects.first.reload
      end

      it{expect(flash[:danger]).to eq I18n.t("subjects.update.fail_update")}

      it{expect(response).to render_template(:edit)}
    end
  end

  describe "DELETE #destroy" do
    context "when destroy success" do
      before do
        delete :destroy, params: {id: subjects.first.id}
      end

      it{expect {delete :destroy, params: {id: subjects.last.id}}.to change(Subject, :count).by(-1)}

      it{expect(flash[:success]).to eq I18n.t("subjects.destroy.success_destroy")}
    end

    context "when destroy fail" do
      let(:another_subject) {FactoryBot.create(:subject, course: course, id: 200)}

      before do
        allow_any_instance_of(Subject).to receive(:destroy).and_return(false)
        delete :destroy, params: {id: another_subject.id}
      end

      it{expect{delete :destroy, params: {id: another_subject.id}}.to_not change {Subject.count}}

      it{expect(flash[:danger]).to eq I18n.t("subjects.destroy.fail_destroy")}
    end
  end
end
