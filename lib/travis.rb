class Travis
  include Singleton

  # https://api.travis-ci.com/repositories/:owner/:repo/branches/:branch?access_token=token
  BASE_URL = "https://api.travis-ci.com/repositories/"

  def self.repos
    @repos ||= Rails.application.secrets.travis_repos.split(' ').compact
  end

  # repo arg expected to be string ":owner/:repo/:branch". See TRAVIS_REPOS
  # variable in .env.example for examples.
  def self.status(repo_string)
    owner, repo, branch = repo_string.split('/')
    url = "#{BASE_URL}#{owner}/#{repo}/branches/#{branch}?access_token=#{Rails.application.secrets.travis_token}"
    puts url
    response = HTTParty.get(url, headers: default_headers)
    report_http_error(response)
    Travis::Repo.new(response.body, owner: owner, repository: repo)
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
  attr_reader :response, :branch, :commit, :owner, :repository

  def initialize(travis_json, owner: nil, repository: nil, branch_name: nil)
    @response = if travis_json.class == String
      JSON.parse(travis_json)
    else
      travis_json
    end
    @branch = @response["branch"]
    @commit = @response["commit"]
    @owner = owner
    @repository = repository
    @branch_name = branch_name
  end

  def passing?
    @branch["state"] == "passed"
  end

  def broken?
    !passing?
  end

  def duration(fmt=:raw)
    case fmt
    when :english
      "#{(@branch["duration"].to_f/60.0).round(1)} minutes"
    else
      @branch["duration"]
    end
  end

  def finished
    @finished ||= Time.parse(@branch["finished_at"])
  end

  def branch_name
    @branch_name || @commit["branch"]
  end

  def by
    @commit["committer_name"]
  end
end
