module OmniAuth
  module Strategies
    class Whiplash < OmniAuth::Strategies::OAuth2
      option :name, :whiplash

      option :client_options, {
        site: ENV.fetch('WHIPLASH_API_URL') || "https://www.getwhiplash.com",
        authorize_url: "/oauth/authorize"
      }

      uid { raw_info["id"] }

      info do
        {
          email: raw_info["email"],
          first_name: raw_info["first_name"],
          last_name: raw_info["last_name"],
          role: raw_info["role"]
        }
      end

      def raw_info
        @raw_info ||= access_token.get('/api/v2/me').parsed
      end

      # https://github.com/intridea/omniauth-oauth2/issues/81
      def callback_url
        full_host + script_name + callback_path
      end
    end
  end
end
