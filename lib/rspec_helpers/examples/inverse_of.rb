RSpec.shared_examples 'inverse of association' do |excluded|
  excluded = [] unless excluded
  excluded = [excluded] unless excluded.is_a? Array
  excluded.map!(&:to_sym)

  described_class.reflect_on_all_associations(:belongs_to).each do |relation|
    next if excluded.include? relation.name
    next if relation.options[:polymorphic]
    next if relation.options[:as]

    it relation.name.to_s do
      expect(relation.options[:inverse_of]).to_not be nil

      class_name = relation.options[:class_name]
      if class_name
        klass = class_name.to_s.singularize.classify.constantize
        rel = klass.reflect_on_all_associations(:has_many).detect do |r|
          r.name == relation.options[:inverse_of]
        end
        expect(rel).not_to be nil
      else
        expect(relation.options[:inverse_of]).to eq(
          described_class.name.pluralize.underscore.to_sym
        )
      end
    end
  end

  described_class.reflect_on_all_associations(:has_many).each do |relation|
    next if excluded.include? relation.name
    next if relation.name == :versions
    next if relation.options[:polymorphic]
    next if relation.options[:as]

    it relation.name.to_s do
      expect(relation.options[:inverse_of]).to_not be nil

      if relation.options[:class_name]
        klass = relation.options[:class_name].to_s.singularize.classify.constantize
        rels = klass.reflect_on_all_associations(:belongs_to)
        rel = rels.detect do |r|
          r.name == relation.options[:inverse_of]
        end
        if !rel
          rels = klass.reflect_on_all_associations(:has_many)
          rel = rels.detect do |r|
            r.name == relation.options[:inverse_of]
          end
        end
        expect(rel).to_not be nil

      elsif relation.options[:through]

        source = relation.options[:source]
        if source
          klass = source.to_s.singularize.classify.constantize
        else
          klass = relation.name.to_s.singularize.classify.constantize
        end

        rels = klass.reflect_on_all_associations(:has_many)
        rel = rels.detect do |r|
          r.name == relation.options[:inverse_of]
        end
        expect(rel).to_not be nil

      else
        klass = relation.name.to_s.singularize.classify.constantize
        rels = klass.reflect_on_all_associations(:belongs_to)
        rel = rels.detect do |r|
          r.name == relation.options[:inverse_of]
        end
        expect(rel).to_not be nil
      end
    end
  end
end
