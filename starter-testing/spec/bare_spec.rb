require 'bare'

describe Bare do
  subject { Bare.new }
  describe 'modules included in spec_helper' do
    it 'specs can access instance methods from the module' do
      expect(help_from_globally_included_instance_method).to be(:available)
    end
    it 'specs can access class methods from the module' do
      expect(GloballyIncludedModule.help_from_globally_included_class_method).to be(:available)
    end
    it 'production code can not reach their instance methods' do
      expect { subject.try_globally_included_instance_method }.to raise_error(NameError,
          start_with("undefined local variable or method `help_from_globally_included_instance_method'"))
    end
    it 'production code can reach their class methods (so you should not use them)' do
      expect { subject.try_globally_included_class_method }.not_to raise_error
    end
  end

  describe 'modules included in other spec files' do
    it 'specs can not reach their methods' do
      expect { help_from_locally_included_instance_method }.to raise_error(NameError,
          start_with("undefined local variable or method `help_from_locally_included_instance_method'"))
    end
  end
end