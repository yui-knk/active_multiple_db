module ActiveMultipleDb
  # Prepend +ActiveRecordMigrationExtension+ to +ActiveRecord::Migration+
  # Methods of this module *do not* call +super+, so override these method of
  # +ActiveRecord::Migration+.
  # See: https://github.com/rails/rails/pull/21353 and
  # https://github.com/rails/rails/blob/v4.2.1/activerecord/lib/active_record/migration.rb
  if ActiveRecord::VERSION::STRING == '4.2.1'
    module ActiveRecordMigrationExtension
      # Override +migrate+ method
      def migrate(direction)
        return unless respond_to?(direction)

        case direction
        when :up   then announce "migrating"
        when :down then announce "reverting"
        end

        time   = nil
        connection_class.connection_pool.with_connection do |conn|
          time = Benchmark.measure do
            exec_migration(conn, direction)
          end
        end

        case direction
        when :up   then announce "migrated (%.4fs)" % time.real; write
        when :down then announce "reverted (%.4fs)" % time.real; write
        end
      end

      # Define +connection_class+ method
      def connection_class
        ActiveRecord::Base
      end

      # Override +connection+ method
      def connection
        @connection || connection_class.connection
      end
    end
  else
    module ActiveRecordMigrationExtension
    end
  end
end
