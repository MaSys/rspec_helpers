RSpec.shared_examples 'belongs_to relations' do |excluded_columns|
  excluded_columns = [excluded_columns] unless excluded_columns
  excluded_columns = [excluded_columns] unless excluded_columns.is_a? Array
  excluded_columns.map! { |e| e.to_s }
  described_class.column_names.each do |c|
    next unless c.ends_with?('_id')
    next if excluded_columns.include? c
    relation = c.gsub('_id', '')
    next if relation.ends_with?('able')
    it { is_expected.to belong_to(relation.to_sym) }
  end
end
