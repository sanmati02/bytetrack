class CompanyTitlesController < ApplicationController
    def index
        @company_titles = []

        @users = User.all
        @users.each do |user|
            user.jobs.each do |job|
              @company_titles.append(job.company_title)
            end
        end
        @company_titles = @company_titles.uniq

        @term_to_match = params[:term]
        @company_titles = @company_titles.select { |title| title.match?(/^#{Regexp.escape(@term_to_match)}/i) }
        render json: @company_titles
    end
end
