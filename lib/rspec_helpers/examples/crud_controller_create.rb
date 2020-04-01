RSpec.shared_examples 'CRUD Controller create' do
  model_str = described_class.name.demodulize.gsub('Controller', '')
  model = model_str.singularize.constantize
  model_name = model.name.underscore
  columns = model.column_names.clone
  columns.delete('deleted_at')
  validator = model.validators.first

  describe 'POST #create' do
    context 'with valid params' do
      before do
        attrs = build(model_name).attributes
        post :create, params: { "#{model_name}" => attrs }
      end

      it 'creates resource' do
        res = js_res[:data]
        expect(res.key?(:id)).to be true
      end

      columns.each do |c|
        it "returns #{c} value" do
          res = js_res[:data]
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

    if validator
      context 'with invalid params' do
        before do
          @column = validator.attributes.first
          attrs = build(model_name).attributes
          attrs[@column.to_s] = nil

          post :create, params: { "#{model_name}" => attrs}
        end

        it 'Should return error' do
          if validator.is_a? ActiveRecord::Validations::PresenceValidator
            expect(
              js_res[:errors][@column.to_sym]
            ).to include I18n.t('errors.messages.blank')
          # else
          #   puts "unkown validator #{validator.class.name}"
          end
        end

        it 'returns meta' do
          expect(js_res).to have_key :meta
        end
      end
    end
  end
end
