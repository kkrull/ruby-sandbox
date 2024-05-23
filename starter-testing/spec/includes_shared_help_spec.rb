require 'includes_shared_help'

describe IncludesSharedHelp do
  describe 'modules included in spec_helper' do
    subject { IncludesSharedHelp.new }
    it 'specs can access instance methods from the module' do
      expect(help_from_shared_module).to be(:available)
    end
    it 'production code can not reach these methods' do
      expect { subject.try_shared_module_method }.to raise_error(NameError,
          start_with("undefined local variable or method `help_from_shared_module'"))
    end
  end
end
