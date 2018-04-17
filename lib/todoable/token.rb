require 'json'
require 'todoable'

# Hold's the user's validation data so it can be automatically
# Re-authenticated if necessary
class Token
  include Todoable
  attr_reader :token, :expires_at
  def initialize(token, expires_at)
    @token = token
    @expires_at = expires_at
  end

  def reauthenticate
    response = Todoable.token_call
    unless response.code == '200' || response.code == '201'
      token_data = JSON.parse(response.body)
      @token = token_data['token']
      @expires_at = token_data['expires_at']
      token
    else
      return nil
    end
  end
end
