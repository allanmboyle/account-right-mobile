describe AccountRight::AuthenticationError do

  it "should be an standard Ruby exception" do
    AccountRight::AuthenticationError.new.should be_an(Exception)
  end

end
