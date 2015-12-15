module OmniAuth
  module Strategies
    class Whiplash < OmniAuth::Strategies::OAuth2
      option :name, :whiplash

      option :client_options, {
        site: "https://www.whiplashmerch.com",
        authorize_url: "oauth/authorize",
        request_token_url: "oauth/authorize",
        access_token_url: "oauth/token"
      }

      uid { raw_info["id"] }

      info do
        { email: raw_info["email"], name: user_full_name }
      end

      extra do
        { raw_info: raw_info }
      end

      def callback_url
        options[:callback_url] || super
      end

      def user_full_name
        "#{raw_info['first_name']} #{raw_info['last_name']}".strip
      end

      def raw_info
        @raw_info ||= access_token.get('/api/v2/me.json').parsed
      end

      def authorize_params
        super.tap do |params|
          %w[scope client_options].each do |v|
            if request.params[v]
              params[v.to_sym] = request.params[v]
            end
          end
        end
      end
    end
  end
end
