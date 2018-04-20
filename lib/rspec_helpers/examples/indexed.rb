RSpec.shared_examples 'indexed' do |excluded_columns|
  # Indexes
  excluded_columns = [excluded_columns] unless excluded_columns.is_a? Array

  described_class.column_names.each do |c|
    next if excluded_columns.include? c
    next if c.ends_with?('able_id')
    next unless c.ends_with?('_id')
    it { is_expected.to have_db_index(c.to_sym) }
  end
end
