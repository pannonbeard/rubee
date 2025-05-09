require_relative '../test_helper'

class MergBerg
  include Rubee::DatabaseObjectable
  attr_accessor :id, :foo, :bar
end

describe 'Database Objectable' do
  describe 'class methods' do
    it 'pluralizes class names' do
      _(MergBerg.pluralize_class_name).must_equal('mergbergs')
    end

    it 'retrieves accessor names' do
      accessors = MergBerg.accessor_names
      _(accessors).must_include(:id)
      _(accessors).must_include(:foo)
      _(accessors).must_include(:bar)
    end
  end
end
