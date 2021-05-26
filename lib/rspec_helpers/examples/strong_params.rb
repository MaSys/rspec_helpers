RSpec.shared_examples 'strong params' do |relations, excluded|
  model_str = described_class.name.demodulize.gsub('Controller', '')
  model = model_str.singularize.constantize

  excluded = [excluded] unless excluded.is_a? Array
  relations ||= []
  column_names = model.column_names.clone
  columns_to_delete = %w[id created_at updated_at deleted_at]
  columns_to_delete.each { |k| column_names.delete(k) }
  RspecHelpers.devise_attrs.each { |k| column_names.delete(k) }
  excluded.each { |k| column_names.delete(k) }

  RspecHelpers.attach_columns.each do |a|
    column_names.each do |c|
      column_names.delete(c) if c.end_with? a
    end
  end

  describe model.name.pluralize + 'Controller' do
    before do
      @attrs = build(model.name.underscore).attributes
      relations.each do |r|
        if r.end_with? '_attributes'
          model_name = r.gsub('_attributes', '')
          @attrs[r] = build(model_name).attributes
          @attrs[r][:id] = 1
          @attrs[r][:_destroy] = 1
        elsif r.end_with? '_ids'

          model_name = r.gsub('_ids', '')
          @attrs[r] = [create(model_name).id]

        else
          raise 'Relation not supported!'
        end
      end

      column_names.each do |c|
        if c.end_with? '_file_name'
          cn = c.gsub('_file_name', '')
          @attrs[cn] = File.new("#{Rails.root}/public/apple-touch-icon.png")
        elsif c.end_with? '_id'
          @attrs[c] = 1
        end
      end

      h = {}
      h[model.name.underscore] = @attrs
      @params = ActionController::Parameters.new(h)
      c = described_class.new
      c.params = @params
      @permitted = c.send(:resource_params)
    end

    column_names.each do |c|
      it 'permits ' + c do
        if c.end_with? '_file_name'
          cn = c.gsub('_file_name', '')
          expect(@permitted.key?(cn)).to be true
        else
          expect(@permitted.key?(c)).to be true
        end
      end
    end

    relations.each do |r|
      context r do
        if r.end_with? '_attributes'
          r_model = r.gsub('_attributes', '').camelize.constantize
          model_name = r.gsub('_attributes', '')
          r_columns = r_model.column_names.clone
          columns_to_delete.each { |k| r_columns.delete(k) }
          r_columns.delete(model_name + 'able_type')
          r_columns.delete(model_name + 'able_id')
          r_columns << 'id'
          r_columns << '_destroy'
          r_columns.each do |cn|
            it 'permits ' + cn do
              expect(@permitted[r.to_sym][cn]).to_not be_nil
            end
          end

        elsif r.end_with? '_ids'

          it 'permits ' + r do
            expect(@permitted[r.to_sym].count).to eq 1
          end

        else
          raise 'Relation not supported!'
        end
      end
    end
  end
end
