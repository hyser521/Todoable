require 'json'
require 'Todoable'

# in order to handle persistance of a token from the calling class, I made a
# token class to hold the data of the current token.  That way the List api
# can make at least one retry before returning failure to the user
class Token
  include Todoable
  attr_reader :token, :expires_at
  def initialize(token, expires_at)
    @token = token
    @expires_at = expires_at
  end

  # Pass in a pre-existing token object to replace data
  def reauthenticate
    response = Todoable.token_call
    return nil unless response.code == '200' || response.code == '201'
    token_data = JSON.parse(response.body)
    @token = token_data['token']
    @expires_at = token_data['expires_at']
    token
  end
end
