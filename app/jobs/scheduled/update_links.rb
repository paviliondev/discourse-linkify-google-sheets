require "google/apis/sheets_v4"

module Jobs
  class UpdateLinks < ::Jobs::Scheduled
    every 6.hours

    def execute()
      sheets = ::Google::Apis::SheetsV4::SheetsService.new
      scopes =  ['https://www.googleapis.com/auth/spreadsheets.readonly']
      sheets.authorization = Google::Auth.get_application_default(scopes)
      spreadsheet_id = SiteSetting.linkify_google_sheet_id
      return unless spreadsheet_id.present?
      range = "Sheet1!A1:B"
      response = sheets.get_spreadsheet_values spreadsheet_id, range
      return if response.values.empty?
      response.values.each do |row|
        PluginStore.set(::LinkifyGoogle::PLUGIN_NAME, row[0], row[1])
      end
    end
  end
end
