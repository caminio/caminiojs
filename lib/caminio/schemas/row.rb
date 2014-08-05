module Caminio
  module Schemas
    module Row
      COLUMNS = {
        deleted_at: :datetime,
        deleted_by: :integer,
        position: [ :integer, { default: 99999 } ],
        updated_by: :integer,
        created_by: :integer,
        organizational_unit_id: :integer,
        status: [ :boolean, { default: 'draft' } ]
      }

      def self.included(base)
        ActiveRecord::ConnectionAdapters::Table.send :include, TableDefinition
        ActiveRecord::ConnectionAdapters::TableDefinition.send :include, TableDefinition
        ActiveRecord::ConnectionAdapters::AbstractAdapter.send :include, Statements
        ActiveRecord::Migration::CommandRecorder.send :include, CommandRecorder
      end

      module Statements
        def add_caminio_row(table_name)
          COLUMNS.each_pair do |column_name, column_arr|
            add_column(table_name, "#{column_name}",
                       Caminio::Schemas::Row.get_column_type(column_arr),
                       Caminio::Schemas::Row.get_column_opts(column_arr) )
          end
        end

        def remove_caminio_row(table_name)
          COLUMNS.each_pair do |column_name, column_type|
            remove_column(table_name, "#{column_name}")
          end
        end

      end

      module TableDefinition
        def caminio_row
          COLUMNS.each_pair do |column_name, column_arr|
            column("#{column_name}",
                   Caminio::Schemas::Row.get_column_type(column_arr),
                   Caminio::Schemas::Row.get_column_opts(column_arr) )
          end
        end
      end

      module CommandRecorder
        def add_caminio_row(*args)
          record(:add_attachment, args)
        end

        private

        def invert_add_caminio_row(args)
          [:remove_attachment, args]
        end
      end

      def self.get_column_type( column_arr )
        return column_arr.is_a?(Array) ? column_arr[0] : column_arr
      end

      def self.get_column_opts( column_arr )
        return column_arr.is_a?(Array) ? column_arr[1] : {}
      end

    end
  end
end
