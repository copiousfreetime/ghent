require 'spec_helper'
require 'fixme'

describe Ghent::VERSION do
  it 'should have a #.#.# format' do
    Ghent::VERSION.must_match( /\A\d+\.\d+\.\d+\Z/ )
    Ghent::VERSION.to_s.must_match( /\A\d+\.\d+\.\d+\Z/ )
  end
end
