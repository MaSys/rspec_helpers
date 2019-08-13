RSpec.shared_examples 'CRUD Controller show' do
  model_str = described_class.name.demodulize.gsub('Controller', '')
  model = model_str.singularize.constantize
  model_name = model.name.underscore
  columns = model.column_names.clone
  columns.delete('deleted_at')

  describe 'GET #show' do
    before do
      obj = create model_name
      get :show, params: { id: obj.id }
    end

    it 'Should return record' do
      res = js_res[:data]
      columns.each do |c|
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
