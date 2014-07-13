module Caminio
  module Schemas
    module WebObject
      COLUMNS = {
        deleted_at: :datetime,
        position: [ :integer, { default: 99999 } ],
        updated_by: :integer,
        created_by: :integer,
        status: [ :boolean, { default: 'draft' } ]
      }

      def self.included(base)
        ActiveRecord::ConnectionAdapters::Table.send :include, TableDefinition
        ActiveRecord::ConnectionAdapters::TableDefinition.send :include, TableDefinition
        ActiveRecord::ConnectionAdapters::AbstractAdapter.send :include, Statements
        ActiveRecord::Migration::CommandRecorder.send :include, CommandRecorder
      end

      module Statements
        def add_caminio_web_object(table_name)
          COLUMNS.each_pair do |column_name, column_arr|
            add_column(table_name, "#{column_name}",
                       Caminio::WebObject.get_column_type(column_arr),
                       Caminio::WebObject.get_column_opts(column_arr) )
          end
        end

        def remove_caminio_web_object(table_name)
          COLUMNS.each_pair do |column_name, column_type|
            remove_column(table_name, "#{column_name}")
          end
        end

      end

      module TableDefinition
        def caminio_web_object
          COLUMNS.each_pair do |column_name, column_arr|
            column("#{column_name}",
                   Caminio::WebObject.get_column_type(column_arr),
                   Caminio::WebObject.get_column_opts(column_arr) )
          end
        end
      end

      module CommandRecorder
        def add_caminio_web_object(*args)
          record(:add_attachment, args)
        end

        private

        def invert_add_caminio_web_object(args)
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
