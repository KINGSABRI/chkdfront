class String
  def red; colorize(self, "\e[1m\e[31m"); end
  def green; colorize(self, "\e[1m\e[32m"); end
  def dark_green; colorize(self, "\e[32m"); end
  def yellow; colorize(self, "\e[1m\e[33m"); end
  def blue; colorize(self, "\e[1m\e[34m"); end
  def dark_blue; colorize(self, "\e[34m"); end
  def purple; colorize(self, "\e[35m"); end
  def dark_purple; colorize(self, "\e[1;35m"); end
  def cyan; colorize(self, "\e[1;36m"); end
  def dark_cyan; colorize(self, "\e[36m"); end
  def pure; colorize(self, "\e[0m\e[28m"); end
  def bold; colorize(self, "\e[1m"); end
  def error; colorize(self, "\n[" + " ✖ ".red + "] "); end
  def colorize(text, color_code) "#{color_code}#{text}\e[0m" end
end

module ChkDFront
  class CliOperations
    include ChkDFront::Providers
    attr_accessor :http, :request, :response
    def initialize
      @http     = nil
      @request  = nil
      @response = nil

      @regx_domain = /^(?:https?:\/\/)?(?:[^@\n]+@)?([^:\/\n?]+)/ # extract domain from url
      @options = { output: $stdout, format: :pulse_2, success_mark: " ✔ ".green, error_mark: " ✖ ".red, hide_cursor: true }
    end

    def show_success
      puts CLI::UI.fmt "{{v}} Front target:    " + "#{@http.front_target.host}"
      puts CLI::UI.fmt "{{v}} Provider header: " + "#{@response['Via']}"
      puts CLI::UI.fmt "{{v}} Domain front:    " + "#{@http.domain_front}"
    end

    def show_expected(string)
      CLI::UI::Frame.divider('Expected String')
      if @response.body.include?(string)
        puts CLI::UI.fmt "{{v}} Found: " + "#{string}"
      else
        puts CLI::UI.fmt "{{x}} Not Found: " + "#{string}"
      end
    end

    def show_checks
      puts @http.res_err[:checks]
    end

    def show_body
      CLI::UI::Frame.divider('Response Body')
      puts @response.body
    end
    def show_debug
      CLI::UI::Frame.divider('Debugging')
      puts WordWrap.ww(@http.debug_output, CLI::UI::Terminal.width)
    end

    # Find provider if not given by the user
    # @param [Symbol] provider_name
    #   given by 'options.provider' option.
    #   Default is :auto, accepted is :amazon, :azure, :alibaba
    # @param [String] domain_front
    #   given by 'options.domain_front' option.
    def find_provider(provider_name, domain_front)
      @options[:format] = :dots_9
      spinner = TTY::Spinner.new("[:spinner] Auto-detecting", @options)
      case provider_name
      when :auto
        domain = Adomain.domain(domain_front)
        [amazon, azure, alibaba].map do |provider|
          if provider[:dfront].include?(domain)
            # spinner.update(title: "Provider found: #{provider[:name].bold}")
            # spinner.reset
            spinner.success(" | Provider found: #{provider[:name].bold}")
            return provider[:name].downcase.to_sym
          end
        end
      when :amazon || :azure || :alibaba
        provider_name
      else
        spinner.error("Failed to auto detect provider: please use '-p' and choose from: 1, 2 or 3")
      end
    end

    def troubleshoot(hosts = [])
      icmp_ping hosts
      http_ping hosts
      dns_ping  hosts
    end

    def icmp_ping(hosts)
      CLI::UI::Frame.divider('ICMP Ping', color: :reset)
      hosts.map do |host|
        host = host.scan(@regx_domain).join
        spinner = TTY::Spinner.new("[:spinner] pinging #{host}", @options)
        icmp = ChkDFront::Troubleshoot.icmp_ping(host)
        icmp.ping? ? spinner.success : spinner.error
      end
    end

    def http_ping(hosts)
      CLI::UI::Frame.divider('HTTP Ping', color: :reset)
      hosts.map do |host|
        host = host.scan(@regx_domain).join
        spinner = TTY::Spinner.new("[:spinner] pinging #{host}", @options)
        http = ChkDFront::Troubleshoot.http_ping(host)
        http.ping? ? spinner.success : spinner.error
        puts http.exception unless http.ping?
      end
    end

    def dns_ping(hosts)
      CLI::UI::Frame.divider('NSlookup (CNAME)', color: :reset)
      hosts.map do |host|
        host = host.scan(@regx_domain).join
        spinner = TTY::Spinner.new("[:spinner] nslookup #{host}", @options)
        dns = ChkDFront::Troubleshoot.dns_ping(host)
        dns.empty? ? spinner.error : spinner.success
        puts dns
      end
    end
  end
end


