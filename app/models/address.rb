class PostcodeValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
      ukpc = UKPostcode.parse(value)
      unless ukpc.full_valid?
        record.errors[attribute] << "not recognised as a UK postcode"
      end
    end
end

class Address < ApplicationRecord
    validates :postcode, presence: true, postcode: true

    # override setter to normalise postcode
    def postcode=(str)
        super UKPostcode.parse(str).to_s
    end
end
