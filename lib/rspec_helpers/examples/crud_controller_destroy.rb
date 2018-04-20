RSpec.shared_examples 'CRUD Controller destroy' do
  model_str = described_class.name.demodulize.gsub('Controller', '')
  model = model_str.singularize.constantize
  model_name = model.name.underscore
  columns = model.column_names.clone
  columns.delete('deleted_at')

  describe 'DELETE #destroy' do
    if model.new.respond_to? :deleted_at
      it 'Should soft destroy resource' do
        obj = create(model_name)
        expect(model.count).to eq 1
        expect(model.only_deleted.count).to eq 0
        delete :destroy, params: { id: obj.id }
        expect(model.count).to eq 0
        expect(model.only_deleted.count).to eq 1
      end
    else
      it 'Should destroy resource' do
        obj = create(model_name)
        expect(model.count).to eq 1
        delete :destroy, params: { id: obj.id }
        expect(model.count).to eq 0
      end
    end
  end
end
