class Class
  def deep_clonable
    include DeepClonable::InstanceMethods
    extend  DeepClonable::ClassMethods
  end
end

module DeepClonable
  module InstanceMethods
    def clone
      cloned_object = dup
      yield(cloned_object) if block_given?
      frozen? ? cloned_object.freeze : cloned_object
    end

    def dup
      cloned_object = super()
      cloned_object.update_vars(deep_vars, :dup)
      cloned_object
    end

    alias old_freeze freeze

    def freeze
      update_vars(deep_vars, :freeze)
      old_freeze
    end

    # You can override deep_vars in your class to specify which instance_variables should be deep cloned.
    # As it is, all Arrays and Hashes are deep cloned.
    def deep_vars
      instance_variables.select do |var|
        value = instance_variable_get(var)
        value.kind_of?(Array) or value.kind_of?(Hash) or value.kind_of?(DeepClonable::InstanceMethods)
      end
    end

    def update_vars(vars, method)
      vars.each do |var|
        value = instance_variable_get(var)
        instance_variable_set(var, value.send(method))
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
        def #{clone_method_name}(*args, &block)
          self.clone do |object|
            object.#{method_name}(*args)
            block ? block.call(object) : object
          end
        end
      }
    end
  end
end
