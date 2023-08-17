require 'net/http'
require 'json'

class Recipient < ApplicationRecord
  has_many :celebration_events
  belongs_to :manager, class_name: 'Recipient', optional: true

  validates :kolay_ik_id, :first_name, :last_name, :email, :birth_date, :employment_start_date, presence: true
  validates :is_active, exclusion: [nil]

  scope :active, -> { where(is_active: true) }

  def self.get_recipients_to_celebrate(reason, days_ahead)
    raise 'days_ahead cannot be more than 28' unless days_ahead <= 28
    raise 'reason must be birthday or work_anniversary' unless %w[birthday work_anniversary].include?(reason)

    date_field = reason == 'birthday' ? 'birth_date' : 'employment_start_date'

    Recipient.active.where(
      [
        "EXTRACT(MONTH FROM #{date_field}) = ? AND EXTRACT(DAY FROM #{date_field}) BETWEEN ? AND ?",
        Time.now.month,
        Time.now.day,
        Time.now.day + days_ahead
      ]
    ).or(  # In the case where days ahead extend into the next month
      Recipient.active.where(
        [
          "EXTRACT(MONTH FROM #{date_field}) = ? AND EXTRACT(DAY FROM #{date_field}) BETWEEN 0 AND ?",
          (Time.now.month + 1) % 12,
          Time.now.day + days_ahead - Time.days_in_month(Time.now.month)
        ]
      )
    )
  end

  def self.refresh_one(kolay_ik_id)
    return nil if kolay_ik_id.blank?

    uri = URI("https://kolayik.com/api/v2/person/view/#{kolay_ik_id}")
    headers = {
      'Authorization': "Bearer #{Rails.application.credentials.kolayik_api_key}"
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

    recipient = Recipient.find_or_initialize_by(kolay_ik_id:)
    recipient.first_name = employee_data['firstName']
    recipient.last_name = employee_data['lastName']
    recipient.email = employee_data['workEmail']
    recipient.birth_date = employee_data['birthday']
    recipient.employment_start_date = employee_data['employmentStartDate']
    recipient.is_active = (employee_data['status'] == 'active')
    recipient.manager = Recipient.refresh_one(employee_data['unitList'][0]['managerId'])
    unless recipient.save
      puts "Error on #{kolay_ik_id}\n"
      return nil
    end

    recipient
  end

  def self.refresh_all
    kolay_ik_ids = []
    is_for_active_employees = 0
    page = 1
    done = false
    until done
      uri = URI('https://kolayik.com/api/v2/person/list')
      form_data = "page=#{page}&status=#{is_for_active_employees}"
      headers = {
        'Authorization': "Bearer #{Rails.application.credentials.kolayik_api_key}",
        'Content-Type': 'application/x-www-form-urlencoded'
      }

      response = Net::HTTP.post(uri, form_data, headers)
      return false if response.code != '200'

      response = JSON.parse(response.body)
      return false if response['error']

      kolay_ik_ids += response['data']['items'].map { |item| item['id'] }
      done = (page == response['data']['lastPage'])
      page += 1

      if done && is_for_active_employees == 0
        # repeat the loop for active employees
        done = false
        is_for_active_employees = 1
        page = 1
      end

      puts kolay_ik_ids.length if done
    end

    for id in kolay_ik_ids
      Recipient.refresh_one(id)
    end

    true
  end
end
