module HasRelationship
  module Base    
    def has_relationship(types, options={})
      types = [types] unless types.kind_of?(Array)

      types.each do |type|
        class_name = options[:class_name] ? options[:class_name].classify : type.to_s.classify
        base_class = class_name.constantize.base_class.name.to_s
    
        # default relationship: Class1_Class2, where Class1 is the class of this class, 
        #   Class2 is the class of that this class has a relationship with
        relationship = "#{self.to_s}_#{class_name}"    
      
        unless options[:singular].present?
          as = options[:as] ? options[:as].to_s : type.to_s
        
          options[:singular] = (as.pluralize != as) 
        end
  
        if options[:as]
          resource_name = options[:as].to_sym
          relationship = "#{self.to_s}_#{options[:as].to_s.classify}"
        elsif options[:singular]
          resource_name = type.to_s.tableize.singularize.to_sym
        else
          resource_name = type.to_s.tableize.to_sym
        end
    
        relationship = options[:relationship] if options[:relationship] 
        
        relationships = relationship.kind_of?(Array) ? relationship : [relationship]
        
        relationship_through = options[:singular] ? "relationship_through_#{relationships.join("_").to_s.tableize.singularize}".to_sym : "relationship_through_#{relationships.join("_").to_s.tableize}".to_sym

        HasRelationship::Relationship.class_eval do
          before_validation do
            self.relation2 = self.send("relation2_#{class_name.downcase}") unless self.relation2.present? or self.send("relation2_#{class_name.downcase}").nil?
          end
        end
      
        class_eval do
          through_conditions = (relationship.kind_of?(Array) ? nil : {:relationship => relationship})
          
          if options[:singular]
            has_one relationship_through, :as => :relation1, :dependent => :destroy, :class_name => "HasRelationship::Relationship", 
                                          :conditions => through_conditions
            has_one resource_name, :through => relationship_through, :class_name => class_name, 
                                   :source => :relation2, :source_type => base_class, 
                                   :conditions => ["relationships.relation2_type = ? and relationships.relationship in (?)", base_class, relationships], :select => options[:select]
          else
            has_many relationship_through, :as => :relation1, :dependent => :destroy, :class_name => "HasRelationship::Relationship", 
                                           :conditions => through_conditions
            has_many resource_name, :through => relationship_through, :readonly => false, :class_name => class_name, 
                                    :source => :relation2, :source_type => base_class, 
                                    :conditions => ["relationships.relation2_type = ? and relationships.relationship in (?)", base_class, relationships], :select => options[:select]
          end
        end
      end
    end
    
    def has_inverse_relationship(types, options={})
      types = [types] unless types.kind_of?(Array)

      types.each do |type|
        class_name = options[:class_name] ? options[:class_name].classify : type.to_s.classify
        base_class = class_name.constantize.base_class.name.to_s
    
        # default relationship: Class2_Class1, where Class1 is the class of this class, 
        #   Class2 is the class of that this class has a relationship with
        relationship = "#{class_name}_#{self.to_s}"
      
        unless options[:singular].present?
          as = options[:as] ? options[:as].to_s : type.to_s
          options[:singular] = (as.pluralize != as) 
        end
  
        if options[:as]
          resource_name = options[:as].to_sym
          relationship = "#{options[:as].to_s.classify}_#{self.to_s}"
        elsif options[:singular]
          resource_name = type.to_s.tableize.singularize.to_sym
        else
          resource_name = type.to_s.tableize.to_sym
        end
    
        relationship = options[:relationship] if options[:relationship] 
        
        relationships = relationship.kind_of?(Array) ? relationship : [relationship]
        
        relationship_through = options[:singular] ? "inverse_relationship_through_#{relationships.join("_").to_s.tableize.singularize}".to_sym : "inverse_relationship_through_#{relationships.join("_").to_s.tableize}".to_sym

        HasRelationship::Relationship.class_eval do
          before_validation do
            self.relation1 = self.send("relation1_#{class_name.downcase}") unless self.relation1.present? or self.send("relation1_#{class_name.downcase}").nil?
          end
        end
      
        class_eval do
          through_conditions = (relationship.kind_of?(Array) ? nil : {:relationship => relationship})
          
          if options[:singular]
            has_one relationship_through, :as => :relation2, :dependent => :destroy, :class_name => "HasRelationship::Relationship", 
                                          :conditions => through_conditions
            has_one resource_name, :through => relationship_through, :class_name => class_name, 
                                   :source => :relation1, :source_type => base_class, 
                                   :conditions => ["relationships.relation1_type = ? and relationships.relationship in (?)", base_class, relationships], :select => options[:select]
          else
            has_many relationship_through, :as => :relation2, :dependent => :destroy, :class_name => "HasRelationship::Relationship", 
                                           :conditions => through_conditions
            has_many resource_name, :through => relationship_through, :readonly => false, :class_name => class_name, 
                                    :source => :relation1, :source_type => base_class, 
                                    :conditions => ["relationships.relation1_type = ? and relationships.relationship in (?)", base_class, relationships], :select => options[:select]
          end
        end
      end
    end
  end
end
