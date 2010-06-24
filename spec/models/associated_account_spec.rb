require 'spec_helper'

describe AssociatedAccount do
  it "belong to associated account type " do
    association = AssociatedAccount.reflect_on_association(:associated_account_type)
    association.should_not be_nil
    association.macro.should == :belongs_to
  end
end
