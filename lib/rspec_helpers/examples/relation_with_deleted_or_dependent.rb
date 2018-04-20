RSpec.shared_examples 'uniqueness scoped' do |column, scope|
  describe column.to_s do
    it 'should be valid if not exist' do
      scoped_factory = create scope.to_s.gsub('_id', '').to_sym
      scoped_factory1 = create scope.to_s.gsub('_id', '').to_sym

      klass = described_class.to_s.underscore

      create klass.to_sym,
             column.to_s => 'MaSys',
             scope.to_s.gsub('_id', '') => scoped_factory

      factory = build klass.to_sym,
                      column.to_s => 'MaSys',
                      scope.to_s.gsub('_id', '') => scoped_factory1

      expect(factory.valid?).to be true
    end

    it 'should not be valid if exist' do
      scoped_factory = create scope.to_s.gsub('_id', '').to_sym

      klass = described_class.to_s.underscore

      create klass.to_sym,
             column.to_s => 'MaSys',
             scope.to_s.gsub('_id', '') => scoped_factory

      factory = build klass.to_sym,
                      column.to_s => 'MaSys',
                      scope.to_s.gsub('_id', '') => scoped_factory

      expect(factory.valid?).to be false
    end
  end
end
