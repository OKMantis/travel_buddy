class TravelBooksController < ApplicationController
  
  def destroy
    @travel_book = TravelBook.find(params[:id])
    @travel_book.destroy
    redirect_to travelbook_path(@travel_book)
  end
end
