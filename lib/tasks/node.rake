namespace(:node) do

  task(:required) do
    AccountRightMobile::Node.installed!
  end

end

namespace(:npm) do

  desc "Updates npm packages when npm has been installed"
  task(:install) do
    AccountRightMobile::Npm.install_if_possible
  end

end
