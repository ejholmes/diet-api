module GrapeEntityExampleGroup
  def self.included(base)
    base.class_eval do
      let(:options) { {} }
      let(:object)  { double('object') }
      let(:entity)  { described_class.new(object, options) }
      subject       { entity }
    end
  end

  RSpec.configure do |config|
    config.include self, example_group: { describes: lambda { |described| described < Grape::Entity } }
  end

  RSpec::Matchers.define :expose do |exposure|
    chain :as do |attribute|
      @attribute = attribute
    end

    match do |entity|
      attribute = @attribute ? @attribute : exposure
      entity.object.stub(attribute).and_return(Object.new)
      expect(entity.serializable_hash[exposure]).to be entity.object.send(attribute)
    end
  end
end
