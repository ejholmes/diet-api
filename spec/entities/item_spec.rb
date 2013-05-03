require 'spec_helper'

describe Item::Entity do
  it { should expose(:id) }
  it { should expose(:title) }
  it { should expose(:link) }
  it { should expose(:read) }
  it { should expose(:pub_date) }
  it { should expose(:feed_id) }
  it { should expose(:description).when(type: :full) }
end