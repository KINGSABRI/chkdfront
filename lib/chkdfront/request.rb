module ChkDFront
  # Contains all HTTP request related functionalities
  class Request
    include ChkDFront::Providers

    # @attribute [r] front_target
    #   @return [String] front_target
    attr_reader :front_target
    # @!attribute [r] domain_front
    #   @return [String]
    attr_reader :domain_front
    # @!attribute [r] proxy
    #   @return [String]
    attr_reader :proxy
    # @!attribute [r]
    #   @return [String]
    attr_reader :debug_output
    # @!attribute [r] request
    #   @return [Net::HTTP::Request]
    attr_reader :request
    # @!attribute [r] request
    #   @return [Net::HTTP::Response]
    attr_reader :response
    # @!attribute [r] res_err
    #   @return [Hash]
    attr_reader :res_err

    def initialize(front_target, domain_front, proxy)
      @front_target = format_front_target(front_target)
      @domain_front = format_domain_front(domain_front)
      @proxy        = format_proxy(proxy)
      @http         = setup_http
    end

    # Send GET/POST request to the targeted domain
    #
    # @param [Symbol] provider_name
    #   Available providers symbols:
    #     - :amazon
    #     - :azure
    #     - :alibaba
    # @param [String] http_method
    # @return [Object]
    def send_to(provider_name, http_method='get')
      provider = get_provider(provider_name, @domain_front)
      @request = Net::HTTP.const_get(http_method.capitalize).new(
          @front_target.request_uri, provider[:headers]
      )
      @response = @http.request(@request)
      check_http(@response) # if response failed, give the user some suggestion
    rescue SocketError => e
      puts "#{self.class}##{__method__}:".error
      puts e.message
    rescue Net::ReadTimeout => e
      puts "#{self.class}##{__method__}:".error
      puts e.message
      puts "Remote port is closed.".error
      exit!
    rescue Exception => e
      puts "#{self.class}##{__method__}:".error
      puts e.full_message
    end

    private

    # @param [String] front_target
    #   The domain of fronted domain (e.g. images.businessweek.com)
    #     This domain should be on the same CDN that user already uses
    # @return [OpenStruct]
    def format_front_target(front_target)
      front_target = "http://#{front_target}" unless front_target.match(/^(http|https):\/\//i)
      uri = URI.parse(front_target)
      OpenStruct.new(host: uri.host, port: uri.port, scheme: uri.scheme, request_uri: uri.request_uri)
    end

    # @param [String] domain_front
    #   The CDN's domain front (e.g. df36z1umwj2fze.cloudfront.net)
    #     this domain is what the users create by their provider.
    # @return [String]
    def format_domain_front(domain_front)
      # if the user gave a URL instead a FQDN:PORT, parse it
      #   Otherwise just use what you get
      uri = URI.parse(domain_front)
      if uri.scheme
        OpenStruct.new(host: uri.host, port: uri.port)
      else
        host, port = domain_front.split(':')
        OpenStruct.new(host: host, port: port)
      end
    end

    #
    # @param [String] proxy
    #   The accepted proxy format is:
    #     - Username and Password separated by column
    #     - Hostname and Port separated by column
    #     - Both above parts separated by @ sign
    #   @example
    #     user1:Pass123@localhost:8080
    #
    # @return [OpenStruct]
    def format_proxy(proxy)
      if proxy
        p_url, p_creds = proxy.reverse&.split('@', 2).map(&:reverse)
        p_host, p_port = p_url.split(':')      if p_url
        p_user, p_pass = p_creds.split(':', 2) if p_creds
      end
      OpenStruct.new(host: p_host, port: p_port, user: p_user, pass: p_pass)
    end

    # @private
    # Setups the initial http connection settings.
    #   The @!method #send_to is going to use it later
    # @return [Net::HTTP]
    def setup_http
      http = Net::HTTP.new(@front_target.host, @front_target.port,
                           @proxy.host, @proxy.port,
                           @proxy.user, @proxy.pass)
      http.use_ssl = true if @front_target.scheme =~ /https/i
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      http.open_timeout = 5
      http.read_timeout = 5
      @debug_output = ""
      http.set_debug_output(@debug_output)
      return http
    rescue Exception => e
      puts "#{self.class}##{__method__}:".error
      puts e.full_message
    end

    # @param [] response
    #   HTTP response error-based suggestions.
    #     If request fail, it checks the response type and suggest checks based on the error.
    #     These suggestion are based on our experience to help users to troubleshoot.
    #     If you've faced different cases and responses, please report it us to update the list
    # @todo: move this to a yaml or json file instead
    def check_http(response)
      case response
      when Net::HTTPOK
        response
      when Net::HTTPGatewayTimeOut
        @res_err = {
            orig:  response,
            checks: [
                "Check your original server:",
                "  is server up?",
                "  is service up?",
                "  is service port correct?",
            ]
        }
      when Net::HTTPBadGateway
        @res_err = {
            orig:  response,
            checks: [
                "- Check your original server:",
                "  - is server up?",
                "  - is service up?",
                "  - is service port correct?",
                "- Check your provider:",
                "  - is front domain name correct? (#{@domain_front})",
                "  - is destination port correct?.",
            ]
        }
      when Net::HTTPForbidden
        @res_err = {
            orig:  response,
            checks: [
                "- Check your provider:",
                "  - is front domain name correct? (#{@domain_front})",
                "- Check your target:",
                "  - is target domain correct? (#{@front_target.host})",
                "  - is target port correct? (#{@front_target.port})"
            ]
        }
      end
    end
  end
end

