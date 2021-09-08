class Ability
  include CanCan::Ability

  def initialize user
    case user.role.to_sym
    when :supervisor
      can :create, Course
      supervisor_manage_course_subject_task user
      can :manage, Enrollment
      can :index, Report
      cannot %i(new create edit update destroy), Report
    when :trainee
      can %i(index show), Course
      can :show, Subject
      can :manage, Report
      can :show, Enrollment
    end
  end

  def supervisor_manage_course_subject_task user
    can :manage, Course do |course|
      course.supervisors.include? user
    end
    can :manage, Subject do |subject|
      subject.course.supervisors.include? user
    end
    can :manage, Task do |task|
      task.course.supervisors.include? user
    end
  end
end
