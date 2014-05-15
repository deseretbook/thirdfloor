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

    if Rails.application.secrets.travis_test_mode
      return Travis::Repo::Test.new("test", owner: owner, repository: repo, branch_name: branch)
    end
    
    url = "#{BASE_URL}#{owner}/#{repo}/branches/#{branch}?access_token=#{Rails.application.secrets.travis_token}"
    puts url
    response = HTTParty.get(url, headers: default_headers)
    if http_success?(response)
      Travis::Repo.new(response.body, owner: owner, repository: repo)
    else
      Travis::Repo::Error.new("#{response.code}\n#{response.body}", owner: owner, repository: repo, branch_name: branch)
    end
  end

private

  def self.default_headers
  {
    'Content-Type' => 'application/json',
    'Accepts' => 'application/json'
  }
  end

  def self.http_success?(response)
    if response.code.to_s =~ /^(1|2)\d{2}$/
      Rails.logger.info "HTTP success: #{response.code}"
      return true
    else
      Rails.logger.fatal "FATAL: HTTP Error: #{response.code}\n#{response.body}"
      return false
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

  def test?
    !!@test
  end

  def error?
    false
  end

  def state
    @branch["state"]
  end

  def running?
    created? || started?
  end

  def finished?
    !running?
  end

  def created?
    state == "created"
  end

  def started?
    state == "started"
  end

  def passing?
    state == "passed"
  end

  def broken?
    !building? && !passing?
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
    @finished ||= if (finished_at = @branch["finished_at"]).present?
      Time.parse(finished_at)
    else
      nil
    end
  end

  def branch_name
    @branch_name || @commit["branch"]
  end

  def by
    @commit["committer_name"]
  end
end

class Travis::Repo::Test < Travis::Repo
  def initialize(state="test", owner: nil, repository: nil, branch_name: nil)
    @state = state
    @owner = owner
    @repository = repository
    @branch_name = branch_name

    @test = true
  end

  def error?
    false
  end

  def state
    @state
  end

  def running?
    false
  end

  def duration(fmt=:raw)
    fmt == :english ? "1 second" : 1
  end

  def finished
    Time.now
  end

  def by
    "test"
  end
end

class Travis::Repo::Error < Travis::Repo
  def initialize(state="error", owner: nil, repository: nil, branch_name: nil)
    @state = state
    @owner = owner
    @repository = repository
    @branch_name = branch_name
  end

  def error?
    true
  end
  
  def state
    @state
  end

  def running?
    false
  end

  def duration(fmt=:raw)
    fmt == :english ? "1 second" : 1
  end

  def finished
    Time.now
  end

  def by
    "test"
  end
end
