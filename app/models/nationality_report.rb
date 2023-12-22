class NationalityReport < ApplicationRecord
    
    def parsed_result
      return {} if result.blank?
  
      result.split(',').each_with_object({}) do |item, hash|
        nationality, count = item.split(':')
        hash[nationality] = count.to_i
      end
    end  
  end  
