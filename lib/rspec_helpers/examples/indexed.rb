RSpec.shared_examples 'indexed' do |excluded_columns|
  # Indexes
  excluded_columns = [excluded_columns] unless excluded_columns.is_a? Array
  excluded_columns.map!(&:to_s)

  relations = described_class.reflect_on_all_associations :belongs_to
  relations.each do |relation|
    relation_name = relation.name.to_s

    foreign_key = relation.options[:foreign_key]
    column = foreign_key || (relation_name + '_id')

    if relation.options[:polymorphic]
      it { is_expected.to have_db_index([:"#{relation_name}_type", column]) }
    else
      it { is_expected.to have_db_index(column) }
    end
  end

  described_class.column_names.each do |c|
    next if excluded_columns.include? c
    next if c.ends_with?('able_id')
    next if described_class.column_names.include?("#{c.gsub('_id', '')}_type")
    next unless c.ends_with?('_id')
    it { is_expected.to have_db_index(c.to_sym) }
  end
end
