class GroupDataType < ActiveRecord::Base
  has_many :group_data
  
  def GroupDataType.description
    GroupDataType.find_by_name("description")
  end
end
