module Rubee
  module Hookable
    def self.included(base)
      base.extend(ClassMethods)
      base.include(InstanceMethods)
    end

    module ClassMethods
      def before(method, handler, **options)
        hooks = Module.new do
          define_method(method) do |*args, &block|
            if conditions_met?(options[:if], options[:unless])
              handler.respond_to?(:call) ? handler.call : send(handler)
            end

            super(*args, &block)
          end
        end
        prepend hooks
      end

      def after(method, handler, **options)
        hooks = Module.new do
          define_method(method) do |*args, &block|
            result = super(*args, &block)

            if conditions_met?(options[:if], options[:unless])
              handler.respond_to?(:call) ? handler.call : send(handler)
            end

            result
          end
        end
        prepend hooks
      end

      def around(method, handler, **options)
        hooks = Module.new do
          define_method(method) do |*args, &block|
            if conditions_met?(options[:if], options[:unless])
              if handler.respond_to?(:call)
                handler.call { super(*args, &block) }
              else
                send(handler) { super(*args, &block) }
              end
            else
              super(*args, &block)
            end
          end
        end
        prepend hooks
      end
    end

    module InstanceMethods
      private

      def conditions_met?(if_condition = nil, unless_condition = nil)
        return true if if_condition.nil? && unless_condition.nil?

        if_condition_result = true
        if_condition_result =
          if if_condition.nil?
            true
          elsif if_condition.respond_to?(:call)
            if_condition.call
          elsif respond_to?(if_condition)
            send(if_condition)
          end

        unless_condition_result = true
        unless_condition_result =
          if unless_condition.nil?
            false
          elsif unless_condition.respond_to?(:call)
            unless_condition.call
          elsif respond_to?(unless_condition)
            send(unless_condition)
          end

        if_condition_result && !unless_condition_result
      end
    end
  end
end
