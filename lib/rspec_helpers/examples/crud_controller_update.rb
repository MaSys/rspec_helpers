RSpec.shared_examples 'CRUD Controller update' do
  model_str = described_class.name.demodulize.gsub('Controller', '')
  model = model_str.singularize.constantize
  model_name = model.name.underscore
  columns = model.column_names.clone
  columns.delete('deleted_at')
  validator = model.validators.first

  describe 'PUT #update' do
    context 'with valid params' do
      before do
        options = {}
        options[:owner] = user if defined?(is_owner)
        options[:user] = user if defined?(is_user)

        obj = create model_name, options
        @column = model.columns.select{|c| c.type === :string}[0]
        put :update, params: { id: obj.id, "#{model_name}" => { "#{@column.name}" => 1 } }
      end

      it 'Should update resource' do
        res = js_res[:data]
        res = res[:attributes] if res.key?(:attributes)
        expect(res[@column.name.to_sym].to_s).to eq 1.to_s
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
          options = {}
          options[:owner] = user if defined?(is_owner)
          options[:user] = user if defined?(is_user)

          obj = create model_name, options

          put :update, params: { id: obj.id, "#{model_name}" => { "#{@column}" => nil } }
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
