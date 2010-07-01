module AssociatedAccountHelpers      
  protected
  def generate_account_types_to_show
    @account_types_to_show = []

    @account_types_to_show << AssociatedAccountType.new(:name=>"eventcasts", :abbreviation=>"EC") if logged_in_user.ec_username.nil?

  	AssociatedAccountType.all.each do |account_type| 				
  		@account_types_to_show << account_type if (!logged_in_user.has_account_type(account_type.id))
  	end    
  end
end