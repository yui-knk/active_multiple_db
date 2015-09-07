require 'active_support/concern'

module ActiveMultipleDb
  module TableNamePrefixer
    extend ActiveSupport::Concern

    module ClassMethods
      def inherited(kls)
        super
        # and not abstruct?
        kls.set_table_name_to_db1 if (kls != ::ActiveRecord::Base) && (kls.parent != ActsAsTaggableOn)
      end

      def set_table_name_to_db1
        db = self.connection_pool.spec.config[:database]
        @before_table_name_set_to_db1 = self.table_name
        self.table_name = "#{db}.#{@before_table_name_set_to_db1}"
      end

      def set_table_name_to_db2
        spec_name = "#{Rails.env}2"
        db = self.configurations[spec_name]["database"]
        self.table_name = "#{db}.#{@before_table_name_set_to_db1}"
      end
    end
  end
end
