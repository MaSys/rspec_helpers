RSpec.shared_examples 'CRUD Controller index' do
  model_str = described_class.name.demodulize.gsub('Controller', '')
  model = model_str.singularize.constantize
  model_name = model.name.underscore
  columns = model.column_names.clone
  columns.delete('deleted_at')
  RspecHelpers.devise_attrs.each { |k| columns.delete(k) }

  describe 'GET #index' do
    it 'Should return list' do
      create model_name
      get :index
      expect(js_res[:data].count).to eq 1
      res = js_res[:data][0]
      columns.each do |c|
        expect(res.key?(c.to_sym)).to be true
      end
    end

    it 'returns meta' do
      expect(js_res[:meta]).to have_key :copyright
      expect(js_res[:meta]).to have_key :authors
      expect(js_res[:meta]).to have_key :jsonapi
    end
  end
end
