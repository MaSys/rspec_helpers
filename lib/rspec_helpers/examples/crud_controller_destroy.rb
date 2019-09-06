RSpec.shared_examples 'CRUD Controller destroy' do
  model_str = described_class.name.demodulize.gsub('Controller', '')
  model = model_str.singularize.constantize
  model_name = model.name.underscore
  columns = model.column_names.clone
  columns.delete('deleted_at')

  describe 'DELETE #destroy' do
    before do
      options = {}
      options[:owner] = user if defined?(is_owner)
      options[:user] = user if defined?(is_user)

      @instance = create model_name, options
      delete :destroy, params: { id: @instance.id }
    end

    if model.new.respond_to? :deleted_at

      it 'soft destroys resource' do
        expect(model.count).to eq 0
        expect(model.only_deleted.count).to eq 1
      end

    else

      it 'destroys resource' do
        expect(model.count).to eq 0
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
