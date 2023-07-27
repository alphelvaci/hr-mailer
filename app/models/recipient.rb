require 'net/http'
require 'json'

class Recipient < ApplicationRecord
    has_many :log_entries
    belongs_to :manager, class_name: "Recipient", optional: true

    validates :kolay_ik_id, presence: true
    validates :first_name, presence: true
    validates :last_name, presence: true
    validates :email, presence: true
    validates :birth_date, presence: true
    validates :employment_start_date, presence: true
    validates :is_active, exclusion: [nil]

    def self.active
        return Recipient.where(is_active: true)
    end

    def self.refresh_one kolay_ik_id
        if kolay_ik_id.blank?
            return nil
        end

        uri = URI("https://kolayik.com/api/v2/person/view/#{kolay_ik_id}")
        headers = {
            'Authorization': "Bearer #{Rails.application.credentials.kolayik_api_key}",
        }
        
        response = Net::HTTP.get_response(uri, headers)
        if response.code != '200'
            puts response.code
            return nil
        end

        response = JSON.parse(response.body)
        if response['error']
            puts response
            return nil
        end
        employee_data = response['data']['person']

        recipient = Recipient.find_or_initialize_by(kolay_ik_id: kolay_ik_id)
        recipient.first_name = employee_data['firstName']
        recipient.last_name = employee_data['lastName']
        recipient.email = employee_data['workEmail']
        recipient.birth_date = employee_data['birthday']
        recipient.employment_start_date = employee_data['employmentStartDate']
        recipient.is_active = (employee_data['status'] == 'active')
        recipient.manager = Recipient.refresh_one(employee_data['unitList'][0]['managerId'])
        if not recipient.save()
            puts "Error on #{kolay_ik_id}\n"
            return nil
        end

        return recipient    
    end

    def self.refresh_all
        kolay_ik_ids = []
        page = 1
        done = false
        until done
            uri = URI('https://kolayik.com/api/v2/person/list')
            form_data = "page=#{page}"
            headers = {
                'Authorization': "Bearer #{Rails.application.credentials.kolayik_api_key}",
                'Content-Type': 'application/x-www-form-urlencoded'
            }
            
            response = Net::HTTP.post(uri, form_data, headers)
            if response.code != '200'
                return false
            end

            response = JSON.parse(response.body)
            if response['error']
                return false
            end

            kolay_ik_ids += response['data']['items'].map { |item| item['id'] }
            done = (page == response['data']['lastPage'])
            page += 1
        end

        for id in kolay_ik_ids
            Recipient.refresh_one(id)
        end

        return true
    end
end
