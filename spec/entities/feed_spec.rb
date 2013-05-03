require 'spec_helper'

describe Feed::Entity do
  it { should expose(:id) }
  it { should expose(:title) }
  it { should expose(:text) }
  it { should expose(:html_url) }
  it { should expose(:xml_url) }
  it { should expose(:favicon) }
  it { should expose(:last_update) }
  it { should expose(:unread).as(:unread_count) }
end