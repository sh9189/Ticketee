class Admin::ProjectsController < Admin::ApplicationController
  def new
    @project = Project.new
  end

  def destroy
    @project = Project.find(params[:id])
    @project.destroy

    flash[:notice] = "Project has been deleted."
    redirect_to projects_path
  end

  def create
    @project = Project.new(project_params)
    if @project.save
      redirect_to @project, notice: "Project has been created."
    else
      flash.now[:alert] = "Project has not been created."
      render "new"
    end
  end

  private

  def project_params
    params.require(:project).permit(:name, :description)
  end

end
