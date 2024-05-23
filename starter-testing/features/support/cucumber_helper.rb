module CucumberHelpers
  def help_from_cucumber_module
    :available
  end
end

World(CucumberHelpers)
