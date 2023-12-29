class JobTitlesController < ApplicationController
    def index
        @job_titles = []

        @users = User.all
        @users.each do |user|
            user.jobs.each do |job|
              @job_titles.append(job.job_title)
            end
        end
        @job_titles = @job_titles.uniq

        term_to_match = params[:term]
        @job_titles = @job_titles.select { |title| title.match?(/^#{Regexp.escape(term_to_match)}/i) }

        render json: @job_titles
    end
end