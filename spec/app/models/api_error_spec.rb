describe AccountRight::ApiError do

  it "should be an standard Ruby exception" do
    AccountRight::ApiError.new.should be_an(Exception)
  end

end
