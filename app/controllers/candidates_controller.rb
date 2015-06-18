class CandidatesController < ApplicationController
  before_filter :get_candidate, only: [:show, :edit, :update]

  def new
    @candidate = Candidate.new
  end

  def create

  end

  def edit

  end

  def update

  end

  def index
    @candidates = Candidate.all
  end

  def show

  end

  private
    def get_candidate
      @candidate = Candidate.find(params[:id])
    end
end
