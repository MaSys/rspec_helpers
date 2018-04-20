RSpec.shared_examples 'inverse of association' do |excluded|
  excluded = [excluded] unless excluded.is_a? Array

  described_class.reflect_on_all_associations(:belongs_to).each do |relation|
    next if excluded.include? relation.name
    next if relation.options[:polymorphic]
    next if relation.options[:as]

    it relation.name.to_s do
      expect(relation.options[:inverse_of]).to_not be nil
      expect(relation.options[:inverse_of]).to eq(
        described_class.name.pluralize.underscore.to_sym
      )
    end
  end

  described_class.reflect_on_all_associations(:has_many).each do |relation|
    next if excluded.include? relation.name.to_s
    next if relation.name == :versions
    next if relation.options[:polymorphic]
    next if relation.options[:as]

    it relation.name.to_s do
      expect(relation.options[:inverse_of]).to_not be nil

      # if relation.options[:through]
      #   expect(relation.options[:inverse_of]).to eq(
      #     described_class.name.pluralize.underscore.to_sym
      #   )
      # else
      #   expect(relation.options[:inverse_of]).to eq(
      #     described_class.name.underscore.to_sym
      #   )
      # end
    end
  end
end
