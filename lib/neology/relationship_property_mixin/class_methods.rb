module Neology

  module RelationshipPropertyMixin

    module ClassMethods

      def _class_name
        self.name
      end

      def relationship_properties_hash
        @relationship_properties_hash ||= { }
      end

      def property property_name, options= nil
        #p "defining relationship property #{property_name} with options #{options}"
        self.relationship_properties_hash[property_name] = options if options
        define_relationship_property_setter property_name.to_s
        define_relationship_property_getter property_name.to_s
      end

      def define_relationship_property_setter property_name
        #p "defining relationship property setter for property #{property_name}"
        send :define_method, "#{property_name}=".to_sym do |value|
          old_value = self.inner_node["data"][property_name]
          if (value != old_value)
            self.inner_node["data"][property_name] = value
            $neo_server.set_relationship_properties(inner_node, self.inner_node["data"])
            self.class.update_relationship_index(self.inner_node, property_name, old_value, value) if self.class.is_indexed?(property_name)
          end
        end
      end

      def define_relationship_property_getter property_name
        #p "defining relationship property getter for property #{property_name}"
        send :define_method, property_name.to_sym do
          self.inner_node["data"] = $neo_server.get_relationship_properties(self.inner_node)
          self.inner_node["data"][property_name.to_s]
        end
      end

    end

  end

end