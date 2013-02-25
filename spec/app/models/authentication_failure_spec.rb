describe AccountRight::AuthenticationFailure do

  it "should be a standard Ruby exception" do
    AccountRight::AuthenticationFailure.new.should be_an(Exception)
  end

end
