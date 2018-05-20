RSpec.shared_examples 'CRUD Controller create' do
  model_str = described_class.name.demodulize.gsub('Controller', '')
  model = model_str.singularize.constantize
  model_name = model.name.underscore
  columns = model.column_names.clone
  columns.delete('deleted_at')
  validator = model.validators.first

  describe 'POST #create' do
    it 'Should create resource' do
      attrs = build(model_name).attributes

      post :create, params: { "#{model_name}" => attrs }
      res = js_res[:data]
      columns.each do |c|
        expect(res.key?(c.to_sym)).to be true
      end
    end

    if validator
      it 'Should return error' do
        column = validator.attributes.first
        attrs = build(model_name).attributes
        attrs[column.to_s] = nil

        post :create, params: { "#{model_name}" => attrs}

        if validator.is_a? ActiveRecord::Validations::PresenceValidator
          expect(
            js_res[:errors][column.to_sym]
          ).to include I18n.t('errors.messages.blank')
        else
          raise 'unkown validator'
        end
      end
    end
  end
end
