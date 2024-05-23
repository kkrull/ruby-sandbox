class Bare
  def try_globally_included_instance_method
    help_from_globally_included_instance_method
  end

  def try_globally_included_class_method
    GloballyIncludedModule.help_from_globally_included_class_method
  end
end