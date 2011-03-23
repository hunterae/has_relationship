require "active_record"

$LOAD_PATH.unshift(File.dirname(__FILE__))

require "has_relationship/has_relationship"
require "has_relationship/relationship"

$LOAD_PATH.shift

if defined?(ActiveRecord::Base)
  ActiveRecord::Base.extend HasRelationship::Base
end
