class CustomerFilesController < ApplicationController

  def index
    @customer_files = (1..3).collect { |i| CustomerFile.new(name: "Mock API #{i}") }
    respond_to do |format|
      format.json  { render :json => @customer_files.to_json }
    end
  end

end
