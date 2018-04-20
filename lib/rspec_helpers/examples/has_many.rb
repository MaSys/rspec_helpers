RSpec.shared_examples 'has_many relations' do |excluded_columns, excluded_tables|
  # has_many relation.
  excluded_columns = [excluded_columns] unless excluded_columns.is_a? Array
  excluded_tables = [excluded_tables] unless excluded_tables.is_a? Array
  excluded_tables << 'schema_migrations'
  excluded_tables << 'ar_internal_metadata'

  ActiveRecord::Base.connection.data_sources.each do |table|
    next if excluded_tables.include? table
    constant = table.singularize.camelize.constantize
    next unless constant
    model = described_class.to_s.underscore
    constant.column_names.each do |c|
      next if excluded_columns.include? c
      next unless c == "#{model}_id"
      it { is_expected.to have_many(table.to_sym).inverse_of(model.to_sym) }
    end
  end
end
