require "rails_helper"

RSpec.shared_examples "Reports required methods" do |method, action|
  before do 
    sign_in trainee
  end

  context "incorrect user" do
    before do
      another_trainee = FactoryBot.create :trainee
      another_report = FactoryBot.create :report, user: another_trainee, course: course
      send(method, action, params: {id: another_report, report: attributes_for(:report)})
    end

    it{expect(response).to redirect_to reports_path}
  end

  context "valid report" do
    before do
      send(method, action, params: {id: report, report: attributes_for(:report)})
    end

    it{expect(assigns(:report)).to eq(report)}
  end

  context "invalid report" do
    before do
      send(method, action, params: {id: -1, report: attributes_for(:report)})
    end

    it{expect(flash[:danger]).to eq I18n.t("report_not_found")}

    it{expect(response).to redirect_to reports_path}
  end
end

RSpec.describe ReportsController, type: :controller do
  let(:trainee){FactoryBot.create :trainee}
  let(:supervisor){FactoryBot.create :supervisor}
  let(:course){FactoryBot.create :course}
  let!(:enrollment){FactoryBot.create :enrollment, course: course, user: trainee}
  let!(:supervision){FactoryBot.create :supervision, course: course, user: supervisor}
  let!(:reports){FactoryBot.create_list :report, 1, user: trainee, course: course}
  let(:report){FactoryBot.create :report, user: trainee, course: course}

  describe "GET #index" do
    context "trainee gets reports" do
      before do
        sign_in trainee
        get :index, params: {filter_date: {filter_date: Time.now}}
      end

      it{expect(assigns(:reports)).to eq(reports.to_a.group_by(&:date))}

      it{expect(response).to render_template(:index)}
    end

    context "supervisor gets reports" do
      before do
        sign_in supervisor
        get :index, params: {filter_date: {filter_date: Time.now}}
      end

      it{expect(assigns(:reports)).to eq(reports.to_a.group_by(&:date))}

      it{expect(response).to render_template(:index)}
    end
  end

  describe "GET #new" do
    before do
      sign_in trainee
      get :new
    end

    it{expect(assigns(:report)).to be_a_new(Report)}

    it{expect(response).to render_template(:new)}
  end

  describe "POST #create" do
    before{sign_in trainee}

    context "with valid attributes" do
      before do
        post :create, params: {report: build(:report, user: trainee, course: course).attributes}
      end

      subject{post :create, params: {report: build(:report, user: trainee, course: course).attributes}}

      it{expect{subject}.to change {Report.count}.by(1)}

      it{expect(flash[:success]).to eq I18n.t("reports.create.success_reported")}

      it{expect(response).to redirect_to reports_path}
    end

    context "with invalid attributes" do
      before do
        post :create, params: {report: build(:invalid_report, user: trainee, course: course).attributes}
      end

      subject{post :create, params: {report: build(:invalid_report, user: trainee, course: course).attributes}}

      it{expect{subject}.to_not change {Report.count}}

      it{expect(flash[:error]).to eq I18n.t("reports.create.fail_reported")}

      it{expect(response).to render_template(:new)}
    end
  end

  describe "GET #edit" do
    before{sign_in trainee}

    context "required methods" do
      it_behaves_like "Reports required methods", :get, :edit
    end

    it do
      get :edit, params: {id: report}
      expect(response).to render_template(:edit)
    end
  end

  describe "PATCH #update" do
    before{sign_in trainee}

    context "required methods" do
      it_behaves_like "Reports required methods", :patch, :update
    end

    context "with valid attributes" do
      before do
        patch :update, params: {id: report, report: attributes_for(:report, today_task: "task")}
        report.reload
      end

      it{expect(report.today_task).to eq("task")}

      it{expect(flash[:success]).to eq I18n.t("reports.update.success_updated")}

      it{expect(response).to redirect_to reports_path}
    end

    context "with invalid attributes" do
      before do
        patch :update, params: {id: report, report: attributes_for(:report, today_task: nil)}
        report.reload
      end

      it{expect(report.today_task).to_not eq(nil)}

      it{expect(flash[:error]).to eq I18n.t("reports.update.fail_updated")}

      it{expect(response).to render_template(:edit)}
    end
  end

  describe "DELETE #destroy" do
    before{sign_in trainee}

    context "required methods" do
      it_behaves_like "Reports required methods", :delete, :destroy
    end

    context "destroy successfully" do
      it do
        report
        expect{delete :destroy, params: {id: report}}
               .to change {Report.count}.by(-1)
      end

      it do
        delete :destroy, params: {id: report, format: :html}
        expect(flash[:success]).to eq I18n.t("reports.destroy.success_destroy")
      end

      it do
        delete :destroy, params: {id: report, format: :html}
        expect(response).to redirect_to reports_path
      end
    end

    context "destroy failed" do
      let(:another_report) {FactoryBot.create :report, user: trainee, course: course}

      before do
        allow_any_instance_of(Report).to receive(:destroy).and_return(false)
        delete :destroy, params: {id: another_report.id, format: :html}
      end

      it do
        expect(controller).to set_flash[:danger]
      end

      it do
        expect(response).to redirect_to reports_path
      end
    end
  end
end
