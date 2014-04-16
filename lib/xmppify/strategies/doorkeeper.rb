module OmniAuth
  module Strategies
    class Doorkeeper < OmniAuth::Strategies::OAuth2
      option :name, :doorkeeper

      option :client_options, {
        :site => "http://localhost:3003",
        :authorize_path => "/oauth/authorize"
      }

      uid do
        raw_info["id"]
      end

      info do
         {
          :email => raw_info["email"],
          :github_auth_token => raw_info['identities'][0]['auth_token'],
          :github_email => raw_info['identities'][0]['email'],
          :name => raw_info["name"]
          # :github_auth_token => raw_info['identities'][1]['auth_token']
        }
      end

      def raw_info
        @raw_info ||= access_token.get('/api/v1/me.json').parsed
      end
    end
  end
end
