class Travis
  include Singleton

  # https://api.travis-ci.com/repositories/owner/repo/cc.xml?access_token=token
  BASE_URL = "https://api.travis-ci.com/repositories/"

  def self.repos
    @repos ||= Rails.application.secrets.travis_repos.split(' ')
  end

  def self.status(repo)
    url = "#{BASE_URL}#{repo}/cc?access_token=#{Rails.application.secrets.travis_token}"
    puts url
    response = HTTParty.get(url, headers: default_headers)
    report_http_error(response)
    Travis::Repo.new(response.body)
  end

private

  def self.default_headers
  {
    'Content-Type' => 'application/json',
    'Accepts' => 'application/json'
  }
  end

  def self.report_http_error(response)
    if response.code.to_s =~ /^(1|2)\d{2}$/
      puts "HTTP success: #{response.code}"
      return false
    else
      raise "FATAL: HTTP Error: #{response.code}\n#{response.body}"
    end
  end

end

class Travis::Repo
  def initialize(travis_json)
    @repo = if travis_json.class == String
      JSON.parse(travis_json)
    else
      travis_json
    end
  end

  def passing?
    @repo["last_build_status"] == 0 && @repo["last_build_result"] == 0
  end

  def broken?
    !passing?
  end

  def duration(fmt=:raw)
    case fmt
    when :english
      "#{(@repo["last_build_duration"].to_f/60.0).round(1)} minutes"
    else
      @repo["last_build_duration"].to_i
    end
  end

  def finished
    Time.parse(@repo["last_build_finished_at"])
  end
end
