class PagesController < ApplicationController
  # skip_before_action :authenticate_user!, only: :home

  def home
  end

  def travelbook
    @saved_in_travelbook = TravelBook.all
  end

end
