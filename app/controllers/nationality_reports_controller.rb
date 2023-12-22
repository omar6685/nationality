class NationalityReportsController < ApplicationController
  before_action :set_nationality_report, only: %i[ show edit update destroy ]

  # GET /nationality_reports or /nationality_reports.json
  def index
    @nationality_reports = NationalityReport.all
  end

  # GET /nationality_reports/1 or /nationality_reports/1.json
  def show
  end
  def generate_report
    file = params[:file]
  
    if file.present? && file.content_type == 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
      workbook = Roo::Spreadsheet.open(file.path, headers: true)
      worksheet = workbook.sheet(0)
  
      nationality_counts = Hash.new(0)
      header_row = worksheet.first # Get the header row
  
      # Assuming 'الجنسية' (Nationality) is the header
      nationality_column_index = header_row.index('الجنسية')
  
      if nationality_column_index.present?
        worksheet.each do |row|
          # Skip the header row
          next if row == header_row
  
          nationality = row[nationality_column_index]
          nationality_counts[nationality] += 1 if nationality
          # Add other processing based on your data structure
        end
  
        if nationality_counts.present?
          result_hash = nationality_counts.map { |nationality, count| "#{nationality}:#{count}" }.join(',')
          NationalityReport.create(result: result_hash)
          redirect_to root_path, notice: 'Nationality report generated successfully!'
        else
          redirect_to root_path, alert: 'No data found in the Excel file.'
        end
      else
        redirect_to root_path, alert: 'Header row not found in the Excel file.'
      end
    else
      redirect_to root_path, alert: 'Please upload a valid Excel file.'
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
