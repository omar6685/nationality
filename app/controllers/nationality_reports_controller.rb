class NationalityReportsController < ApplicationController
  before_action :set_nationality_report, only: %i[ show edit update destroy ]

  # GET /nationality_reports or /nationality_reports.json
  def index
    @nationality_reports = NationalityReport.all
  end

  # GET /nationality_reports/1 or /nationality_reports/1.json
  def show
    @file_names = JSON.parse(@nationality_report.name)
  end
  # In the controller's generate_report action
  def generate_report
    files = params.permit!.select { |param_name, _value| param_name.starts_with?('file') }
  
    if files.present? && files.values.all? { |file| file.content_type == 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' }
      merged_counts = Hash.new(0)
      total_non_saudi_employees = 0
      saudi_employees_count = 0
      file_names = {}
  

      files.keys.each_with_index do |param_name, index|
        file = files[param_name]
        name = file.original_filename.split('.').first
        workbook = Roo::Spreadsheet.open(file.tempfile.path, headers: true)
        worksheet = workbook.sheet(0)
  
        nationality_counts = Hash.new(0)
        header_row = worksheet.first # Get the header row
  
        nationality_column_index = header_row.index('الجنسية')
        company_name_column_index = 4 # Assuming the company name is in the 5th column (index 4)
        company_name = worksheet.row(2)[company_name_column_index] # Get the company name
        file_names[(index + 1).to_s] = company_name # Store the filename and company name in the hash
  
        if nationality_column_index.present? && company_name_column_index.present?
          worksheet.each do |row|
            next if row == header_row
  
            nationality = row[nationality_column_index]
            name = row[company_name_column_index]
  
            if nationality == 'سعودي'
              saudi_employees_count += 1
            else
              nationality_counts[nationality] ||= 0
              nationality_counts[nationality] += 1
              total_non_saudi_employees += 1
            end
          end
  
          merged_counts.merge!(nationality_counts) { |_nationality, count1, count2| count1 + count2 }
        else
          redirect_to root_path, alert: 'Header row or column not found in one of the Excel files.'
          return
        end
      end
  
      if merged_counts.present?
        result_hash = merged_counts.map do |nationality, count|
          percentage = ((count.to_f / total_non_saudi_employees) * 100).round(2)
          "#{nationality}:#{count}:#{percentage}%"
        end.join(',')
  
        report = NationalityReport.create(
          result: result_hash,
          name: file_names.to_json, # Storing the hash as JSON
          saudis: saudi_employees_count,
          total_employees: total_non_saudi_employees
        )
  
        max_addition = report.calculate_max_addition(merged_counts)
        report.update(max_addition: max_addition.to_json)
  
        redirect_to root_path, notice: 'Nationality report generated successfully!'
      else
        redirect_to root_path, alert: 'No data found in the uploaded Excel files.'
      end
    else
      redirect_to root_path, alert: 'Please upload valid Excel files.'
    end
  end
  

  # GET /nationality_reports/new
  def new
    @nationality_report = NationalityReport.new
  end

  # GET /nationality_reports/1/edit
  def edit
  end

  # POST /nationality_reports or /nationality_reports.json
  def create
    @nationality_report = NationalityReport.new(nationality_report_params)

    respond_to do |format|
      if @nationality_report.save
        format.html { redirect_to nationality_report_url(@nationality_report), notice: "Nationality report was successfully created." }
        format.json { render :show, status: :created, location: @nationality_report }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @nationality_report.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /nationality_reports/1 or /nationality_reports/1.json
  def update
    respond_to do |format|
      if @nationality_report.update(nationality_report_params)
        format.html { redirect_to nationality_report_url(@nationality_report), notice: "Nationality report was successfully updated." }
        format.json { render :show, status: :ok, location: @nationality_report }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @nationality_report.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /nationality_reports/1 or /nationality_reports/1.json
  def destroy
    @nationality_report.destroy

    respond_to do |format|
      format.html { redirect_to nationality_reports_url, notice: "Nationality report was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_nationality_report
      @nationality_report = NationalityReport.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def nationality_report_params
      params.require(:nationality_report).permit(:result)
    end
end
