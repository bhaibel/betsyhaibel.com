class ProjectObserver < ActiveRecord::Observer
  def after_update(project)
    [:milestone, :name, :description, :build_day].each do |attribute|
      if project.send "#{attribute}_changed?"
        Mailer.send_later "#{attribute}_changed", project.owner, project
      end
    end
  end
end
