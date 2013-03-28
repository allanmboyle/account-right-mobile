describe WelcomeController, type: :controller do

  describe "#index" do

    it "should render the single page application view" do
      get :index

      response.should render_template("index")
    end

  end

end
