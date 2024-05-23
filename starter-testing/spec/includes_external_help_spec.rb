require 'includes_external_help'
require 'support/locally_included_module'

RSpec.configure { |config| config.include(LocallyIncludedModule) }

describe IncludesExternalHelp do
  describe 'modules included in spec_helper' do
    subject { IncludesExternalHelp.new }
    it 'specs can access instance methods from the module' do
      expect(help_from_globally_included_instance_method).to be(:available)
    end
    it 'production code can not reach these methods' do
      expect { subject.try_globally_included_instance_method }.to raise_error(NameError,
          start_with("undefined local variable or method `help_from_globally_included_instance_method'"))
    end
  end

  describe 'modules included in this file' do
    it 'specs can access instance methods from the module' do
      expect(help_from_locally_included_instance_method).to be(:available)
    end
    it 'production code can not reach these methods' do
      expect { subject.try_locally_included_instance_method }.to raise_error(NameError,
          start_with("undefined local variable or method `help_from_locally_included_instance_method'"))
    end
  end
end