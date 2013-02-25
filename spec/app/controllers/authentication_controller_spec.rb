describe AuthenticationController, type: :controller do

  describe "#live_login" do

    describe "POST" do

      describe "when a json response is requested" do

        describe "and credentials are provided" do

          before(:each) do
            @initial_live_login_base_uri_setting = AccountRightMobile::Application.config.live_login["base_uri"]
          end

          after(:each) do
            AccountRightMobile::Application.config.live_login["base_uri"] = @initial_live_login_base_uri_setting
          end

          describe "and authentication is enabled" do

            let(:credentials) do
              { username: "someUsername", password: "somePassword" }
            end

            let(:live_user) { double("LiveUser").as_null_object }

            before(:each) do
              AccountRightMobile::Application.config.live_login["base_uri"] = "some uri"

              AccountRight::LiveUser.stub!(:new).and_return(live_user)
            end

            it "should create a live user with the credentials" do
              AccountRight::LiveUser.should_receive(:new).with(credentials).and_return(live_user)

              post_live_login
            end

            describe "when the live user login is successful" do

              before(:each) do
                live_user.stub!(:login).and_return(access_token: "someAccessToken", refresh_token: "someRefreshToken")
              end

              it "should respond with status of 200" do
                post_live_login

                response.status.should eql(200)
              end

              it "should respond with body containing the access and refresh token" do
                post_live_login

                response.body.should eql({ access_token: "someAccessToken", refresh_token: "someRefreshToken" }.to_json)
              end

            end

            describe "when the live user login is unsuccessful" do

              before(:each) do
                live_user.stub!(:login).and_raise(AccountRight::AuthenticationFailure)
              end

              it "should respond with a status of 400" do
                post_live_login

                response.status.should eql(400)
              end

            end

            describe "when an error occurs during the live user login" do

              before(:each) do
                live_user.stub!(:login).and_raise(AccountRight::AuthenticationError)
              end

              it "should respond with a status of 500" do
                post_live_login

                response.status.should eql(500)
              end

            end

          end

          describe "and authentication is disabled" do

            let(:credentials) do
              {}
            end

            before(:each) { AccountRightMobile::Application.config.live_login.delete("base_uri") }

            it "should respond with status of 200" do
              post_live_login

              response.status.should eql(200)
            end

            it "should respond with an empty body" do
              post_live_login

              response.body.should eql("")
            end

          end

          def post_live_login
            post :live_login, credentials.merge(format: :json)
          end

        end

      end

    end

  end

end
