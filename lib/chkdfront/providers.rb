module ChkDFront
  # This module contains CDN provider specific settings headers.
  module Providers
    def get_provider(provider, domain_front)
      if domain_front.port
        host = "#{domain_front.host}:#{domain_front.port}"
      else
        host = domain_front.host
      end
      case provider
      when :amazon  then  amazon(host)
      when :azure   then  azure(host)
      when :alibaba then  alibaba(host)
      else
        puts "Unknown Provider!!!!: #{provider}"
        return false
      end
    end

    # Amazon vendor specific settings and headers
    # @param [String] host
    # @return [Hash]
    #   Returns a hash of { dfront: [domain1, domain2], headers: {}}
    def amazon(host='')
      {
          name:    'Amazon',
          dfront:  ['cloudfront.net'],
          headers: {
              'Host'       => host,
              'User-Agent' => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.13; rv:65.0) Gecko/20100101 Firefox/65.0",
              'Connection' => 'close'
          }
      }
    end

    # Azure vendor specific settings and headers
    # @param [String] host
    # @return [Hash]
    #   Returns a hash of { dfront: [domain1, domain2], headers: {}}
    def azure(host='')
      {
          name:    'Azure',
          dfront:  ['azureedge.net'],
          headers: {
            'Host'       => host,
            'User-Agent' => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.13; rv:65.0) Gecko/20100101 Firefox/65.0",
            'Connection' => 'close'
          }
      }
    end

    # Alibaba vendor specific settings and headers
    # @param [String] host
    # @return [Hash]
    #   Returns a hash of { dfront: [domain1, domain2], headers: {}}
    def alibaba(host='')
      {
          name:    'Alibaba',
          dfront:  ['kunlungr.com'],
          headers: {
              'Host'       => host,
              'User-Agent' => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.13; rv:65.0) Gecko/20100101 Firefox/65.0",
              'Connection' => 'close'
          }
      }
    end
  end
end
