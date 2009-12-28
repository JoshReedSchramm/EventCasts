class CreateSearchTermsAndLinkTable < ActiveRecord::Migration
  def self.up
    create_table :search_terms do |t|
      t.string :term
      t.timestamps
    end

    create_table :events_search_terms do |e|
      e.integer :event_id
      e.integer :search_term_id
      e.timestamps
    end
  end

  def self.down
    drop_table :events_search_terms
    drop_table :search_terms
  end
end
