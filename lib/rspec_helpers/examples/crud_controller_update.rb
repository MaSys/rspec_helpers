RSpec.shared_examples 'CRUD Controller update' do
  model_str = described_class.name.demodulize.gsub('Controller', '')
  model = model_str.singularize.constantize
  model_name = model.name.underscore
  columns = model.column_names.clone
  columns.delete('deleted_at')
  validator = model.validators.first

  describe 'PUT #update' do
    it 'Should update resource' do
      obj = create(model_name)
      column = model.columns.select { |c| c.type == :string }[0]
      put :update, params: {
        id: obj.id,
        model_name.to_s => { column.name.to_s => 1 }
      }
      res = js_res[:data]
      expect(res[column.name.to_sym].to_s).to eq 1.to_s
    end

    if validator
      it 'Should return error' do
        column = validator.attributes.first
        obj = create(model_name)

        put :update, params: {
          id: obj.id,
          model_name.to_s => { column.to_s => nil }
        }

        presence = validator.is_a? ActiveRecord::Validations::PresenceValidator
        raise 'unkown validator' unless presence
        expect(
          js_res[:errors][column.to_sym]
        ).to include I18n.t('errors.messages.blank')
      end
    end
  end
end
