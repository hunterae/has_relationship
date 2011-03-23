module HasRelationship
  class Relationship < ::ActiveRecord::Base #:nodoc:

    belongs_to :relation1, :polymorphic => true
    belongs_to :relation2, :polymorphic => true
  
    before_create do
      self.relationship = self.relation1.class.to_s + "_" + self.relation2.class.to_s if self.relationship.blank?
    end
  end
end
