require 'has_internal_help'

describe HasInternalHelp do
  describe 'modules included in spec_helper' do
    subject { HasInternalHelp.new }
    it 'specs can access instance methods from the module' do
      expect(help_from_globally_included_instance_method).to be(:available)
    end
    it 'production code can not reach these methods' do
      expect { subject.try_globally_included_instance_method }.to raise_error(NameError,
          start_with("undefined local variable or method `help_from_globally_included_instance_method'"))
    end
  end

  describe 'modules included in other spec files' do
    it 'specs can not reach their methods' do
      expect { help_from_locally_included_instance_method }.to raise_error(NameError,
          start_with("undefined local variable or method `help_from_locally_included_instance_method'"))
    end
  end

  describe 'helper methods defined in the spec context' do
    subject { HasInternalHelp.new }
    before(:each) { expect(help_from_spec_method).to be(:available) }
    after(:each) { expect(help_from_spec_method).to be(:available) }

    it 'specs can access these methods' do
      expect(help_from_spec_method).to be(:available)
    end
    it 'production code can not access these methods' do
      expect { subject.try_spec_method }.to raise_error(NameError,
          start_with("undefined local variable or method `help_from_spec_method'"))
    end

    def help_from_spec_method
      :available
    end
  end
end