require 'active_support/callbacks'
require 'active_support/concern'

module ActiveMultipleDb
  module Migration
    module Callbacks
      extend ActiveSupport::Concern
      include ActiveSupport::Callbacks

      module Prepend
        def migrate(*args)
          run_callbacks(:migrate) do
            super
          end
        end
      end

      included do
        prepend Prepend
        define_callbacks :migrate

        set_callback :migrate, :before, :before_migration
        set_callback :migrate, :after,  :after_migration
        set_callback :migrate, :around, :around_migration

        def before_migration(*args, &block); end
        def after_migration(*args, &block); end
        def around_migration(*args, &block); yield; end
      end
    end

    module ConnectDb2
      extend ActiveSupport::Concern

      included do
        include Callbacks

        def around_migration(&block)
          connection_class.establish_connection :"#{Rails.env}2"
          yield
          connection_class.establish_connection :"#{Rails.env}"
        end
      end
    end

    module SafelyYield
      extend ActiveSupport::Concern

      module ClassMethods
        def safely_yield
          if ActiveMultipleDb.config.safely_yielding_environments.include? Rails.env
            yield
          end
        end
      end
    end
  end
end
