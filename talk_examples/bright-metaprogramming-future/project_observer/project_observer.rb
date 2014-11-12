class ProjectObserver < ActiveRecord::Observer
  def after_update(project)
    case
    when project.milestone_changed?
      Mailer.send_later :milestone_changed, project.owner, project
    when project.name_changed?
      Mailer.send_later :name_changed, project.owner, project
    when project.description_changed?
      Mailer.send_later :description_changed, project.owner, project
    when project.target_build_day_changed?
      Mailer.send_later :target_build_day_changed, project.owner, project
    end
  end
end