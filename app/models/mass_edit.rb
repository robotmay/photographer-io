class MassEdit
  extend ActiveModel::Naming
  include ActiveModel::Conversion

  attr_accessor :photograph_ids, :collection_ids, :action

  def initialize(attributes = {})
    attributes ||= {}
    attributes.each do |key, value|
      self.send("#{key}=", value)
    end
  end

  def photograph_ids
    @photograph_ids ||= []
    @photograph_ids.map(&:to_i)
  end

  def collection_ids
    @collection_ids ||= []
    @collection_ids.map(&:to_i)
  end

  def persisted?
    false
  end

  def self.actions
    [
      ['Delete', 'delete']
    ]
  end
end
