class WorkExperiencesController < ApplicationController
    before_action :authenticate_user!
    before_action :set_work_experience, only: %i[edit update destroy]

    def new
       @work_experience = current_user.work_experiences.new 
    end

    def edit; end

    def create
        @work_experience = current_user.work_experiences.new(work_experiences_params)
        respond_to do |format|
            if @work_experience.save
                format.turbo_stream { render turbo_stream: turbo_stream.append('work_experience_item', partial: 'work_experiences/work_experience', locals: { work_experience: @work_experience }) }
            else
                format.turbo_stream { render turbo_stream: turbo_stream.replace('remote_modal', partial: 'shared/turbo_modal', locals: { form_partial: 'work_experiences/form', modal_title: "Add new work experience" }) }
            end
        end
    end

    def update 
        respond_to do |format|
            if @work_experience.update(work_experiences_params)
                format.turbo_stream { render turbo_stream: turbo_stream.replace('work_experience_item_#{ @work_experience.id }', partial: 'work_experiences/work_experience', locals: { work_experience: @work_experience }) }
            else
                format.turbo_stream { render turbo_stream: turbo_stream.replace('remote_modal', partial: 'shared/turbo_modal', locals: { form_partial: 'work_experiences/form', modal_title: "Edit work experience" }) }
            end
        end
    end

    def destroy
        respond_to do |format|
            @work_experience.destroy
            format.turbo_stream { render turbo_stream: turbo_stream.remove("work_experience_item_#{@work_experience.id}") }
        end
    end

    private

        def set_work_experience
            @work_experience = current_user.work_experiences.find(params[:id])
        end

        def work_experiences_params
            params.require(:work_experience).permit(:start_date, :end_date, :job_title, :employment_type, :location, :location_type, :currently_working_here, :description, :company, :user_id)
        end
end