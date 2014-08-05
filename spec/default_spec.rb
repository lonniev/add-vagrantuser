require 'chefspec'

describe 'add-vagrantuser::default' do
  
  let(:chef_run) do
    runner = ChefSpec::ChefRunner.new('platform' => 'ubuntu', 'version'=> '12.04')
    runner.converge('add-vagrantuser::default')
  end
    
  it 'should include the add-vagrantuser recipe by default' do
    expect(chef_run).to include_recipe 'add-vagrantuser::default'
  end

end
