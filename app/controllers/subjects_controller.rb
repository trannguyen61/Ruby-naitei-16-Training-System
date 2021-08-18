class SubjectsController < ApplicationController
  before_action :logged_in_user
  before_action :supervisor_user, except: %i(index)

  def index
    @subjects = Subject.newest_subject.page(params[:page])
                       .per Settings.subject.paginate
  end

  def new; end

  def create
    @subject = Subject.new subject_params
    if @subject.save
      flash[:success] = t ".success_create"
    else
      flash[:danger] = @subject.errors.full_messages.to_sentence
    end
    redirect_to course_path params[:subject][:course_id]
  end

  def edit; end

  def update; end

  def destroy; end

  private
  def subject_params
    params.require(:subject).permit Subject::POST_ATTRS
  end
end
