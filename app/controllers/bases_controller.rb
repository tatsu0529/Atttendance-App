class BasesController < ApplicationController
  
  def index
    @base = Base.all
  end
  
  def edit
  end 
  
end
