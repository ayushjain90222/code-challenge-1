class Company < ApplicationRecord
	before_save :add_state_city #By zipcode if zipcode is valid add state and city and if zipcode is not correct it will give error
  has_rich_text :description
	validates :email,
          format: {
              message: 'must contain domain @getmainstreet.com or blank email is allowed',
              with: /\A[\w+-.]+@getmainstreet.com\z/i
          }, allow_blank: true #email blank allowed and or include @getmainstreet.com it is valid otherwise it will give error

	def add_state_city
		state_city_data = ZipCodes.identify(self.zip_code)
		if state_city_data.present?
			self.state = state_city_data[:state_code]
			self.city = state_city_data[:city]
		else
			 errors.add(:zip_code,"not valid. Please enter correct value")
			 raise ActiveRecord::RecordInvalid.new(self)
		end
 end
end
