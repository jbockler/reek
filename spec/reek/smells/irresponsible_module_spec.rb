require File.join(File.dirname(File.dirname(File.dirname(File.expand_path(__FILE__)))), 'spec_helper')
require File.join(File.dirname(File.dirname(File.dirname(File.dirname(File.expand_path(__FILE__))))), 'lib', 'reek', 'smells', 'irresponsible_module')
require File.join(File.dirname(File.expand_path(__FILE__)), 'smell_detector_shared')

include Reek::Smells

describe IrresponsibleModule do
  before(:each) do
    @bad_module_name = 'WrongUn'
    @detector = IrresponsibleModule.new('yoof')
  end

  it_should_behave_like 'SmellDetector'

  it "does not report a class having a comment" do
    src = <<EOS
# test class
class Responsible; end
EOS
    ctx = CodeContext.new(nil, src.to_reek_source.syntax_tree)
    @detector.examine(ctx)
    @detector.smells_found.should be_empty
  end
  it "reports a class without a comment" do
    src = "class #{@bad_module_name}; end"
    ctx = CodeContext.new(nil, src.to_reek_source.syntax_tree)
    @detector.examine(ctx)
    smells = @detector.smells_found.to_a
    smells.length.should == 1
    smells[0].smell_class.should == IrresponsibleModule::SMELL_CLASS
    smells[0].subclass.should == IrresponsibleModule::SMELL_SUBCLASS
    smells[0].lines.should == [1]
    smells[0].smell[IrresponsibleModule::MODULE_NAME_KEY].should == @bad_module_name
  end
  it "reports a class with an empty comment" do
    src = <<EOS
#
#
#  
class #{@bad_module_name}; end
EOS
    ctx = CodeContext.new(nil, src.to_reek_source.syntax_tree)
    @detector.examine(ctx)
    smells = @detector.smells_found.to_a
    smells.length.should == 1
    smells[0].smell_class.should == IrresponsibleModule::SMELL_CLASS
    smells[0].subclass.should == IrresponsibleModule::SMELL_SUBCLASS
    smells[0].lines.should == [4]
    smells[0].smell[IrresponsibleModule::MODULE_NAME_KEY].should == @bad_module_name
  end
end