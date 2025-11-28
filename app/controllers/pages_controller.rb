class PagesController < ApplicationController
  # skip_before_action :authenticate_user!, only: :home

  def home
  end

  def travelbook
    @barcelona = current_user.travel_books.joins(:activity).where(activity: {city: "Barcelona"})
    @new_york = current_user.travel_books.joins(:activity).where(activity: {city: "New York"})
    @tokyo = current_user.travel_books.joins(:activity).where(activity: {city: "Tokyo"})
  end

end
