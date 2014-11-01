require 'net/https'
require 'json'

class Offer
	
	include ActiveModel::Model

	attr_accessor :api_key, :url , :uid , :pub0 , :page , :appid,:format, :device_id,:locale ,:ip , :offer_types ,:timestamp,:data,:response

	validates :uid, presence: true

	QUERY_ATTR = ["appid", "device_id", "format", "ip", "locale", "offer_types","timestamp", "page", "pub0", "uid"]

	def initialize(attributes = {})
		config = YAML.load_file(File.join(::Rails.root, 'config', 'fyber.yml'))
		raise "Fyber api config file not found or empty!" if config.blank?
		config.each do |k, v|
			self.send("#{k}=", v) if self.respond_to?(k)
		end
		super
		# puts "#{self.class.name} initialize: #{self.attributes.inspect}"
	end

	def search
		self.timestamp = Time.now.to_i
		uri = URI(url)
		query_params = base_query_hash.merge(generate_hashkey(base_query_string([self.api_key])))
		uri.query = URI.encode_www_form(query_params)
		self.response = Net::HTTP.get_response(uri)
		self.data = self.response.try(:body)
		unless req_valid = success_and_valid?
			self.errors.add(:base,self.data["message"]) unless self.data.blank?
		end	
		return req_valid
	end	
	
	def success_and_valid?
		self.response.is_a?(Net::HTTPSuccess) && self.response["x-sponsorpay-response-signature"].eql?(generate_hashkey(self.response.body + self.api_key)["hashkey"])
	end

	def data=(value)
		@data = JSON.parse(value) || {} 
	end	

	def offers
		@data["offers"] || []
	end

	def attributes
		self.as_json
	end

	def persisted?
		false
	end

	private

	def query_attributes
		self.attributes.select{|k,v| QUERY_ATTR.include? k}
	end

	def generate_hashkey(query_params)
		{"hashkey" => Digest::SHA1.hexdigest(query_params).downcase}
	end

	def base_query_hash
		Hash[query_attributes.sort]
	end

	def base_query_string(options = [])
		(base_query_hash.inject([]){|arr,k| arr << k.join('=')} + options).join('&')
	end

end