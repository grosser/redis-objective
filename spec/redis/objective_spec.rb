require 'rubygems'

$LOAD_PATH << 'lib'
require 'redis/objective'

REDIS = Redis.new

REDIS['xxx'] = '1'
REDIS['xxx'].should == '1'

describe "Redis.objective" do
  before do
    REDIS.flushdb
  end

  describe :get do
    before do
      REDIS.objective.set('x',[1,2])
    end

    it 'works through []' do
      REDIS.objective['x'].should == [1,2]
    end

    it 'works through get' do
      REDIS.objective.get('x').should == [1,2]
    end

    it 'does crash with nil' do
      REDIS.objective.get('unknown').should == nil
    end
  end

  describe :set do
    it 'works through []' do
      REDIS.objective['x'] = [1,2]
      REDIS.objective['x'].should == [1,2]
    end

    it 'works through set' do
      REDIS.objective.set('x', [1,2])
      REDIS.objective['x'].should == [1,2]
    end

    it 'works through set_with_expire' do
      pending 'my local redis server des not support this...'
      REDIS.objective.set_with_expire('x', [1,2], 1)
      REDIS.objective['x'].should == [1,2]
      sleep 1
      REDIS.objective['x'].should == nil
    end

    it 'does not set nil' do
      REDIS.objective['x'] = nil
      REDIS['x'].should == nil
    end

    it 'overwrites when setting nil' do
      REDIS.objective['x'] = [1,2]
      REDIS.objective['x'] = nil
      REDIS['x'].should == nil
    end

    it 'returns the set value' do
      REDIS.objective.set('x',[1,2]).should == [1,2]
      REDIS.objective.set('x',nil).should == nil
    end
  end

  describe :mapped_mget do
    before do
      REDIS.objective['xx'] = [1,2]
      REDIS.objective['xy'] = [3,4]
    end

    it 'gets objective' do
      REDIS.objective.mapped_mget('xx','xy').should == {'xx' => [1,2], 'xy' => [3,4]}
    end

    it 'does not crash with nil' do
      REDIS.objective.mapped_mget('xx','unknown').should == {'xx' => [1,2]}
    end

    it 'works with mget' do
      REDIS.objective.mget('xx','unknown').should == {'xx' => [1,2]}
    end
  end

  describe :mapped_mset do
    it 'sets objective' do
      REDIS.objective.mapped_mset('xx' => [1,2], 'xy' => [3,4])
      REDIS.objective['xx'].should == [1,2]
      REDIS.objective['xy'].should == [3,4]
    end

    it 'sets with nested array' do
      REDIS.objective.mapped_mset([['xx', [1,2]], ['xy', [3,4]]])
      REDIS.objective['xx'].should == [1,2]
      REDIS.objective['xy'].should == [3,4]
    end

    it 'sets with flat array' do
      REDIS.objective.mapped_mset('xx', [1,2], 'xy', [3,4])
      REDIS.objective['xx'].should == [1,2]
      REDIS.objective['xy'].should == [3,4]
    end

    it 'sets with mset' do
      REDIS.objective.mset('xx', [1,2], 'xy', [3,4])
      REDIS.objective['xx'].should == [1,2]
      REDIS.objective['xy'].should == [3,4]
    end

    it 'can set nil' do
      REDIS.objective.mset('xx', [1,2], 'xy', nil)
      REDIS.objective['xx'].should == [1,2]
      REDIS.objective['xy'].should == nil
    end

    it 'deletes keys that are set to nil'
  end

  it 'has a version' do
    Redis::Objective::VERSION.should =~ /^\d+\.\d+\.\d+$/
  end
end