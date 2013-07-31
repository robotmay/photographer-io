class MassEdit
  extend ActiveModel::Naming
  include ActiveModel::Conversion

  attr_accessor :photograph_ids, :collection_ids, :action, :user

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

  def photographs
    user.photographs.where(id: photograph_ids)
  end

  def collections
    user.collections.where(id: collection_ids)
  end

  def persisted?
    false
  end

  def action
    case
    when collection_ids.size > 0
      'collections'
    else
      @action
    end
  end

  def self.actions
    [
      ['Delete', 'delete']
    ]
  end
end
