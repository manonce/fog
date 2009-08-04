module Fog
  module AWS
    class S3

      class Bucket < Fog::Model

        attr_accessor :creation_date, :location, :name, :objects, :owner

        def initialize(attributes = {})
          remap_attributes(attributes, {
            'CreationDate'  => :creation_date,
            'Name'          => :name
          })
          super
          @objects ||= []
        end

        def delete
          connection.delete_bucket(name)
          true
        end

        def location
          @location ||= begin
            data = s3.get_bucket_location(name)
            data.body['LocationConstraint']
          end
        end

        def payer
          @payer ||= begin
            data = connection.get_request_payment(name)
            data.body['Payer']
          end
        end

        def payer=(new_payer)
          connection.put_request_payment(name, new_payer)
          @payer = new_payer
        end

        def save
          options = {}
          if @location
            options['LocationConstraint'] = @location
          end
          connection.put_bucket(name, options)
          true
        end

      end

    end
  end
end
