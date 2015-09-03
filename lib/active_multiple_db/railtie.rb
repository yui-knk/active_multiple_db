require 'rails'

module ActiveMultipleDb
  class Railtie < ::Rails::Railtie
    initializer 'active_multiple_db' do
      ActiveSupport.on_load :active_record do
        require 'active_multiple_db/monkey/active_record/migration'
        require 'active_multiple_db/migration'
        require 'active_multiple_db/table_name_prefixer'
        ActiveRecord::Migration.send :prepend, ActiveMultipleDb::ActiveRecordMigrationExtension
        ActiveRecord::Migration.send :include, ActiveMultipleDb::Migration::SafelyYield
        ActiveRecord::Base.send :include, ActiveMultipleDb::TableNamePrefixer
      end
    end
  end
end
