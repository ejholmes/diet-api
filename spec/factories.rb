FactoryGirl.define do
  sequence :email do |n|
    "email#{n}@factory.com"
  end

  factory :user do
    email
    password 'password'
  end

  factory :feed do
    user
    html_url { Faker::Internet.url }
    text { Faker::Lorem.paragraphs.join('\n') }
    title { Faker::Lorem.word }
    xml_url { Faker::Internet.url }
  end

  factory :item do
    description { Faker::Lorem.paragraphs.join('\n') }
    guid { Faker::Internet.url }
    link { Faker::Internet.url }
    pub_date { DateTime.now }
    title { Faker::Lorem.word }
  end
end
