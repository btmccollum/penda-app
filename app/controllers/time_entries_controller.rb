class TimeEntriesController < ApplicationController
    def new
        @time_entry = TimeEntry.new
    end

    def create
        binding.pry
    end

end
