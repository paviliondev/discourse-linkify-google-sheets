require "google/apis/sheets_v4"

module Jobs
  class UpdateLinks < ::Jobs::Scheduled
    every 6.hours

    def execute(_args)
      sheets = ::Google::Apis::SheetsV4::SheetsService.new
      scopes =  ['https://www.googleapis.com/auth/spreadsheets.readonly']
      sheets.authorization = Google::Auth.get_application_default(scopes)
      spreadsheet_id = SiteSetting.linkify_google_sheet_id
      return unless spreadsheet_id.present?
      range = SiteSetting.linkify_google_sheet_name+"!"+SiteSetting.linkify_google_sheet_cell_range
      response = sheets.get_spreadsheet_values spreadsheet_id, range
      return if response.values.empty?
      keys = []
      data = response.values.map do |arr|
        Rails.logger.warn(arr.inspect)
        keys << arr[0]
        PluginStore.set(::LinkifyGoogle::PLUGIN_NAME, arr[0], arr[1])
      end

      PluginStoreRow.where(plugin_name: ::LinkifyGoogle::PLUGIN_NAME).where.not(key: keys).destroy_all
    end
  end
end
