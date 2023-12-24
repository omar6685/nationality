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
  
    def calculate_max_addition(nationality_counts)
        max_additions = {}
        nationality_counts.each do |nationality, count|
          inc = 0
          allowed_percentage = calculate_allowed_percentage(nationality)
          actual_percentage = (count.to_f / total_employees) * 100
    
          while true
            inc += 1
            actual_percentage = ((count + inc).to_f / (total_employees + inc)) * 100
            break if actual_percentage > allowed_percentage
          end
    
          max_addition = [0, inc - 1].max
          max_additions[nationality] = max_addition
        end
        max_additions
      end

      def parsed_max_addition
        return {} if max_addition.blank?
    
        JSON.parse(max_addition)
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
  