class JobsController < ApplicationController

    helper_method :job_card_style
    # before_action :authenticate_user!

    def show
      id = params[:id]
      @job = Job.find(id)
    end

    def index

      @jobs = current_user.jobs

      @jobs = @jobs.where(priority: params[:priority]) if params[:priority].present?
      @jobs = @jobs.where(final_decision: params[:final_decision]) if params[:final_decision].present?
      @jobs = @jobs.where(online_assessment_status: params[:online_assessment_status]) if params[:online_assessment_status].present?
      @jobs = @jobs.where(interview_status: params[:interview_status]) if params[:interview_status].present?

      @jobs = @jobs.where('UPPER(company_title) LIKE UPPER(?)', "#{params[:search]}%") if params[:search].present?

      _, _, @oa_action_required, @interview_action_required = calculate_oa_and_interview_dates
      @jobs = @jobs.where(company_title: @oa_action_required) if params[:task_list].present? && params[:task_list] == "OA Pending"
      @jobs = @jobs.where(company_title: @interview_action_required) if params[:task_list].present? && params[:task_list] == "Interview Upcoming"
      @jobs = @jobs.where(company_title: @oa_action_required + @interview_action_required) if params[:task_list].present? && params[:task_list] == "Both"

      @companies_with_oa_deadlines, @companies_with_interviews_due, _, _= calculate_oa_and_interview_dates

      @applied_jobs = @jobs.where(online_assessment_status: ["Pending", "Not yet received", "N/A", ""], interview_status: ["Scheduled", "Not scheduled", "N/A", ""], final_decision: ["Waiting"])
      @applied_jobs = @applied_jobs.where.not(date_applied: Date.new(1, 1, 1))

      @completed_oa_jobs = @jobs.where(online_assessment_status: ["Complete"], interview_status: ["Scheduled", "Not scheduled", "N/A", ""], final_decision: ["Waiting"])
      @completed_interviews_jobs = @jobs.where(interview_status: "Complete", final_decision: ["Waiting"])
      @heard_back_jobs = @jobs.where(final_decision: ["Rejected", "Received Offer"])

      priority_ranking = ['Low', 'Medium', 'High']
      final_decision_ranking = ['Waiting', 'Rejected', 'Received Offer']

      @sorting_by = params[:sort_jobs]

      if @sorting_by.present?
        if @sorting_by == 'Company Title: A-Z'
          @applied_jobs = @applied_jobs.order(company_title: :asc)
          @completed_oa_jobs = @completed_oa_jobs.order(company_title: :asc)
          @completed_interviews_jobs = @completed_interviews_jobs.order(company_title: :asc)
          @heard_back_jobs = @heard_back_jobs.order(company_title: :asc)

        elsif @sorting_by == 'Company Title: Z-A'
          @applied_jobs = @applied_jobs.order(company_title: :desc)
          @completed_oa_jobs = @completed_oa_jobs.order(company_title: :desc)
          @completed_interviews_jobs = @completed_interviews_jobs.order(company_title: :desc)
          @heard_back_jobs = @heard_back_jobs.order(company_title: :desc)

        elsif @sorting_by == 'Priority: Low-High'
          @applied_jobs = @applied_jobs.sort_by{|job| priority_ranking.index(job.priority)}
          @completed_oa_jobs = @completed_oa_jobs.sort_by{|job| priority_ranking.index(job.priority)}
          @completed_interviews_jobs = @completed_interviews_jobs.sort_by{|job| priority_ranking.index(job.priority)}
          @heard_back_jobs = @heard_back_jobs.sort_by{|job| priority_ranking.index(job.priority)}

        elsif @sorting_by == 'Priority: High-Low'
          @applied_jobs = @applied_jobs.sort_by{|job| priority_ranking.index(job.priority)}.reverse
          @completed_oa_jobs = @completed_oa_jobs.sort_by{|job| priority_ranking.index(job.priority)}.reverse
          @completed_interviews_jobs = @completed_interviews_jobs.sort_by{|job| priority_ranking.index(job.priority)}.reverse
          @heard_back_jobs = @heard_back_jobs.sort_by{|job| priority_ranking.index(job.priority)}.reverse

        elsif @sorting_by == 'Final Decision'
          @applied_jobs = @applied_jobs.sort_by{|job| final_decision_ranking.index(job.final_decision)}
          @completed_oa_jobs = @completed_oa_jobs.sort_by{|job| final_decision_ranking.index(job.final_decision)}
          @completed_interviews_jobs = @completed_interviews_jobs.sort_by{|job| final_decision_ranking.index(job.final_decision)}
          @heard_back_jobs = @heard_back_jobs.sort_by{|job| final_decision_ranking.index(job.final_decision)}

        elsif @sorting_by == 'Date Applied'
          @applied_jobs = @applied_jobs.order(date_applied: :asc)
          @completed_oa_jobs = @completed_oa_jobs.order(date_applied: :asc)
          @completed_interviews_jobs = @completed_interviews_jobs.order(date_applied: :asc)
          @heard_back_jobs = @heard_back_jobs.order(date_applied: :asc)

        end
      end

      render :index
    end

    def new
      # default: render 'new' template
    end

    def create
        @job = current_user.jobs.new(job_params)

       if job_params[:company_title].blank? || job_params[:job_title].blank? || job_params[:date_applied].blank? || (Date.parse(job_params[:date_applied])) > Date.current || (!job_params[:online_assessment_deadline].blank? && (Date.parse(job_params[:online_assessment_deadline])) < (Date.parse(job_params[:date_applied]))) || (!job_params[:interview_date].blank? && (Date.parse(job_params[:interview_date])) < (Date.parse(job_params[:date_applied])))
         flash[:alert_company_title] = job_params[:company_title].blank? ? "Company cannot be empty." : nil
         flash[:alert_job_title] = job_params[:job_title].blank? ? "Job Title cannot be empty." : nil
         flash[:alert_date_applied] = job_params[:date_applied].blank? ? "Date Applied cannot be empty." : nil
         flash[:alert_date_applied_future] = (!job_params[:date_applied].blank? && Date.parse(job_params[:date_applied]) > Date.current) ? "Date Applied must not be in the future." : nil
         flash[:oa_deadline_issue] = (!job_params[:date_applied].blank? && !job_params[:online_assessment_deadline].blank? && ((Date.parse(job_params[:online_assessment_deadline]))) < (Date.parse(job_params[:date_applied]))) ? "Online Assessment Deadline must be after Date Applied" : nil
         flash[:interview_date_issue] = (!job_params[:date_applied].blank? && !job_params[:interview_date].blank? && ((Date.parse(job_params[:interview_date]))) < (Date.parse(job_params[:date_applied]))) ? "Interview Date must be after Date Applied." : nil

         render :new and return
       end

       if @job.save
         flash[:notice] = "Job application for #{job_params[:company_title]} was successfully created."

         redirect_to jobs_path
       end
     end

    def edit
      @job = current_user.jobs.find(params[:id])
    end

    def update
      @job = current_user.jobs.find(params[:id])


      if job_params[:company_title].blank? || job_params[:job_title].blank? || job_params[:date_applied].blank? || (Date.parse(job_params[:date_applied])) > Date.current || (!job_params[:online_assessment_deadline].blank? && (Date.parse(job_params[:online_assessment_deadline])) < (Date.parse(job_params[:date_applied]))) || (!job_params[:interview_date].blank? && (Date.parse(job_params[:interview_date])) < (Date.parse(job_params[:date_applied])))
        flash[:alert_company_title] = job_params[:company_title].blank? ? "Company cannot be empty." : nil
        flash[:alert_job_title] = job_params[:job_title].blank? ? "Job Title cannot be empty." : nil
        flash[:alert_date_applied] = job_params[:date_applied].blank? ? "Date Applied cannot be empty." : nil
        flash[:alert_date_applied_future] = (!job_params[:date_applied].blank? && Date.parse(job_params[:date_applied]) > Date.current) ? "Date Applied must not be in the future." : nil
        flash[:oa_deadline_issue] = (!job_params[:date_applied].blank? && !job_params[:online_assessment_deadline].blank? && ((Date.parse(job_params[:online_assessment_deadline]))) < (Date.parse(job_params[:date_applied]))) ? "Online Assessment Deadline must be after Date Applied" : nil
        flash[:interview_date_issue] = (!job_params[:date_applied].blank? && !job_params[:interview_date].blank? && ((Date.parse(job_params[:interview_date]))) < (Date.parse(job_params[:date_applied]))) ? "Interview Date must be after Date Applied." : nil

        render :edit and return
      end

      @job.update_attributes!(job_params)
      flash[:notice] = "Job application for #{@job.company_title} was successfully updated."
      redirect_to job_path(@job)
    end

    def destroy
      @job = current_user.jobs.find(params[:id])
      @job.destroy
      flash[:notice] = "Job application for #{@job.company_title} was successfully deleted."
      redirect_to jobs_path
    end

    def job_card_style(job)
      if job.final_decision == 'Received Offer'
        'border-color: #6aaf6a; border-width: 3px;'
      elsif job.final_decision == 'Rejected'
        'border-color: #FF4F4B; border-width: 3px;'
      else
        ''
      end
    end

    private
    # Making "internal" methods private is not required, but is a common practice.
    # This helps make clear which methods respond to requests, and which ones do not.
    def job_params
      params.require(:job).permit(:company_title, :job_title, :skills, :application_status, :date_applied, :online_assessment_status, :online_assessment_deadline, :interview_status, :interview_date, :final_decision, :priority, :location, :confidence_rating_oa, :confidence_rating_interview, :interview_notes, :oa_notes)
    end

    def calculate_oa_and_interview_dates
      companies_with_oa_deadlines = []
      companies_with_interviews_due = []
      oa_AR = []
      interview_AR = []

      @jobs.each do |job|
        if job.online_assessment_deadline.present? && Date.current <= job.online_assessment_deadline && job.online_assessment_status != 'Complete'
          oa_AR << job.company_title
          if job.online_assessment_deadline < 3.days.from_now
            companies_with_oa_deadlines << job.company_title
          end
        end

        if job.interview_date.present? && Date.current <= job.interview_date && job.interview_status != 'Complete'
          interview_AR << job.company_title
          if job.interview_date < 3.days.from_now
            companies_with_interviews_due << job.company_title
          end
        end
      end

      [companies_with_oa_deadlines, companies_with_interviews_due, oa_AR, interview_AR]
    end



  end
