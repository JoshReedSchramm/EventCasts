class GroupDatum < ActiveRecord::Base
  belongs_to :group_data_type
  belongs_to :group
  

end
