class Class
  def deep_clonable
    include DeepClonable::InstanceMethods
    extend  DeepClonable::ClassMethods
  end
end

module DeepClonable
  module InstanceMethods
    def clone
      cloned_object = super
      cloned_object.clone_fields
      cloned_object
    end
    
    def dup
      cloned_object = super
      cloned_object.clone_fields
      cloned_object
    end

    # You can override clone_fields in your class to do deep clone in place.
    # As it is, all Arrays and Hashes are deep cloned.
    def clone_fields
      instance_variables.each do |variable|
        value = instance_variable_get(variable)
        if value.kind_of?(Array) or value.kind_of?(Hash) or value.kind_of?(DeepClonable::InstanceMethods)
          instance_variable_set(variable, value.clone)
        end
      end
    end
  end

  module ClassMethods
    # Use this to define cloning version of the given in-place methods.
    #
    # This method supports a common idiom where you create in-place and 
    # cloning versions of most operations. This method allows you to 
    # define only the in-place version (with the trailing bang (!),
    # that part is important) and specify the cloning versions by name
    # using this method.
    def clone_method(clone_method_name, method_name = nil)
      clone_method_name = clone_method_name.to_s.gsub(/\!$/,'')
      method_name ||= "#{clone_method_name}!"
      class_eval %{
        def #{clone_method_name}(*args)
          object = self.clone
          object.#{method_name}(*args)
          if block_given?
            yield object
          else
            object
          end
        end
      }
    end
  end
end
