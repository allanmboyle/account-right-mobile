namespace(:node) do

  task(:required) do
    AccountRightMobile::Build::Node.installed!
  end

end

namespace(:npm) do

  desc "Updates npm packages when npm has been installed"
  task(:install) do
    AccountRightMobile::Build::Npm.install_if_possible
  end

end
