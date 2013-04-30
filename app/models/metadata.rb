class Metadata < ActiveRecord::Base
  include IdentityCache

  belongs_to :photograph

  validates :photograph_id, presence: true

  def extract_from_photograph
    
  end
end
