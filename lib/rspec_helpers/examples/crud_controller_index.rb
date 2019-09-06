RSpec.shared_examples 'CRUD Controller index' do
  model_str = described_class.name.demodulize.gsub('Controller', '')
  model = model_str.singularize.constantize
  model_name = model.name.underscore
  columns = model.column_names.clone
  columns.delete('deleted_at')
  RspecHelpers.devise_attrs.each { |k| columns.delete(k) }

  describe 'GET #index' do
    before do
      options = {}
      options[:owner] = user if defined?(is_owner)
      options[:user] = user if defined?(is_user)

      create model_name, options
      get :index
    end

    it 'returns list' do
      expect(js_res[:data].count).to eq 1
    end

    columns.each do |c|
      it "returns #{c} value" do
        res = js_res[:data][0]
        res = res[:attributes] if res.key?(:attributes)
        expect(res.key?(c.to_sym)).to be true
      end
    end

    it 'returns meta' do
      expect(js_res).to have_key :meta
    end

    it 'returns meta copyright' do
      expect(js_res[:meta]).to have_key :copyright
    end

    it 'returns meta authors' do
      expect(js_res[:meta]).to have_key :authors
    end

    it 'returns meta jsonapi' do
      expect(js_res[:meta]).to have_key :jsonapi
    end
  end
end
