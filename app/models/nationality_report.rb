class NationalityReport < ApplicationRecord
    def parsed_result
      return {} if result.blank?
  
      result.split(',').each_with_object({}) do |item, hash|
        nationality, count, percentage = item.split(':')
        allowed_percentage = calculate_allowed_percentage(nationality)
  
        hash[nationality] = {
          count: count.to_i,
          percentage: percentage.to_f,
          allowed_percentage: allowed_percentage
        }
      end
    end
  
    private
  
    def calculate_allowed_percentage(nationality)
      case nationality
      when 'سعودي'
        100.0
      when 'يمني'
        25.0
      when 'اثيوبي'
        1.0
      else
        40.0 # For any other nationality
      end
    end
  end
  