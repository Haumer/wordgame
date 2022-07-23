class Auths::GoogleController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :sign_in, :auth, :download ]
  def download
    redirect_to google_sign_in_path
  end

  def sign_in
    credentials = google_credentials
    auth_url = credentials.authorization_uri
    redirect_to auth_url, allow_other_host: true
  end

  def auth
    credentials = google_credentials
    credentials.code = params[:code]
    credentials.fetch_access_token!
    @session = GoogleDrive::Session.from_credentials(credentials)
    fetch_words(@session)
    redirect_to user_path(current_user, download: true)
  end

  private

  def fetch_words(google_session)
    sheet = google_session.spreadsheet_by_url(current_user.sheet_url)
    batch = Batch.create(user: current_user)
    sheet.worksheets.first.rows.flatten.reject(&:empty?).each do |word|
      word = Word.find_or_initialize_by(value: word)
      word.user = current_user unless word.user.present?
      word.save
      batch_word = BatchWord.create(batch: batch, word: word)
    end
  end

  def google_credentials
    domain = ENV['DOMAIN'] || 'http://localhost:3000'

    Google::Auth::UserRefreshCredentials.new(
      client_id: ENV['GOOGLE_CLIENT_ID'],
      client_secret: ENV['GOOGLE_CLIENT_SECRET'],
      additional_parameters: { "access_type" => "offline" },
      scope: [
        "https://www.googleapis.com/auth/drive",
        "https://spreadsheets.google.com/feeds/",
      ],
      redirect_uri: "#{domain}/auths/google/auth"
    )
  end
end
