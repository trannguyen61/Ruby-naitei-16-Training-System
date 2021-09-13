require "rails_helper"
include SessionsHelper

RSpec.describe TasksController, type: :controller do
  let(:trainee){FactoryBot.create :trainee}
  let(:supervisor){FactoryBot.create :supervisor}
  let(:course){FactoryBot.create :course_with_subjects_tasks,
    subjects_count: 2, tasks_count: 2}
  let(:subject){course.subjects.first}
  let(:enrollment){FactoryBot.create :enrollment, course: course, user: trainee}
  let(:subjects){course.subjects}
  let(:tasks){course.tasks}
  let!(:supervision){FactoryBot.create :supervision, course: course, user: supervisor}

  before :each do
    sign_in supervisor
  end

  describe "POST #create" do
    context "with valid attributes" do
      before do
        post :create, params: {task: build(:task, subject: subject).attributes}
      end

      it{expect(flash[:success]).to eq I18n.t("tasks.success_create")}

      it{expect(response).to redirect_to subject_path subject.id}
    end

    context "with invalid attributes" do
      before do
        post :create, params: {task: build(:invalid_task, subject: subject).attributes}
      end

      it{expect(controller).to set_flash[:danger]}

      it{expect(response).to redirect_to subject_path subject.id}
    end
  end

  describe "PATCH #update" do
    context "invalid task" do
      before do
        patch :update, params: {id: -1, task: attributes_for(:task)}
      end

      it{expect(flash[:danger]).to eq I18n.t("tasks.error.invalid_task")}

      it{expect(response).to redirect_to courses_path}
    end

    context "with valid attributes" do
      before do
        patch :update, params: {id: tasks.first, task: attributes_for(:task)}
        tasks.first.reload
      end

      it{expect(flash[:success]).to eq I18n.t("tasks.update.success_update")}
    end

    context "with invalid attributes" do
      before do
        patch :update, params: {id: tasks.first, task: attributes_for(:task, name: "")}
        tasks.first.reload
      end

      it{expect(flash[:danger]).to eq I18n.t("tasks.update.fail_update")}

      it{expect(response).to render_template(:edit)}
    end
  end

  describe "DELETE #destroy" do
    context "when destroy success" do
      before do
        delete :destroy, params: {id: tasks.first.id}
      end

      it{expect {delete :destroy, params: {id: tasks.last.id}}.to change(Task, :count).by(-1)}

      it{expect(flash[:success]).to eq I18n.t("tasks.destroy.success_destroy")}
    end

    context "when destroy fail" do
      let(:another_task) {FactoryBot.create(:task, subject: subject, id: 200)}

      before do
        allow_any_instance_of(Task).to receive(:destroy).and_return(false)
        delete :destroy, params: {id: another_task.id}
      end

      it{expect{delete :destroy, params: {id: another_task.id}}.to_not change {Task.count}}

      it{expect(flash[:danger]).to eq I18n.t("tasks.destroy.fail_destroy")}
    end
  end
end
