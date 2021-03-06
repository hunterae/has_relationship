class HasRelationshipMigration < ActiveRecord::Migration
  def self.up        
    create_table :relationships do |t|
      t.column :relation1_id, :integer
      t.column :relation1_type, :string
      
      t.column :relation2_id, :integer
      t.column :relation2_type, :string
      
      t.column :relationship, :string
      
      t.column :created_at, :datetime
    end
    
    add_index :relationships, [:relation1_id, :relation1_type]
    add_index :relationships, [:relation2_id, :relation2_type]
    add_index :relationships, [:relationship]
  end
  
  def self.down
    drop_table :relationships
  end
end
