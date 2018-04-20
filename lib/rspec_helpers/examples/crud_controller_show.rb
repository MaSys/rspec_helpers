RSpec.shared_examples 'CRUD Controller show' do
  model_str = described_class.name.demodulize.gsub('Controller', '')
  model = model_str.singularize.constantize
  model_name = model.name.underscore
  columns = model.column_names.clone
  columns.delete('deleted_at')

  describe 'GET #show' do
    it 'Should return record' do
      obj = create model_name
      get :show, params: { id: obj.id }
      res = js_res[:data]
      columns.each do |c|
        expect(res.key?(c.to_sym)).to be true
      end
    end
  end
end
