module Surus
  module JSON
    class ThroughScopeBuilder < AssociationScopeBuilder
      def scope
        #e.g. "join user_things on user_things.thing_id=things.id and user_things.user_id = users.id"
        sql = <<-SQL
          join #{join_table}
          on #{join_table}.#{association_foreign_key}=#{association_table}.#{association_primary_key}
          and #{join_table}.#{foreign_key} = #{primary_class}.#{primary_key}
        SQL
        association.klass.joins(sql)
      end

      def join_table
        connection.quote_table_name association.through_reflection.name
      end

      def primary_key
        connection.quote_column_name association.through_reflection.inverse_of.klass.primary_key
      end

      def association_foreign_key
        connection.quote_column_name association.association_foreign_key
      end

      def foreign_key
        connection.quote_column_name association.through_reflection.foreign_key
      end

      def primary_class
        connection.quote_table_name association.through_reflection.inverse_of.table_name
      end

      def association_table
        connection.quote_table_name association.klass.table_name
      end

      def association_primary_key
        connection.quote_column_name association.association_primary_key
      end

    end
  end
end
