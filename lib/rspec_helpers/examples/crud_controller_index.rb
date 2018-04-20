RSpec.shared_examples 'CRUD Controller index' do
  model_str = described_class.name.demodulize.gsub('Controller', '')
  model = model_str.singularize.constantize
  columns = model.column_names.clone
  columns.delete('deleted_at')

  describe 'GET #index' do
    it 'Should return list' do
      get :index
      expect(js_res[:data].count).to eq 1
      res = js_res[:data][0]
      columns.each do |c|
        expect(res.key?(c.to_sym)).to be true
      end
    end
  end
end
