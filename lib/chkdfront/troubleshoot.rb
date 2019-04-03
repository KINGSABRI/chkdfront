module ChkDFront
  # Contains all troubleshooting functionalities.
  # Currently, ping, http, nslookup
  class Troubleshoot
    def self.icmp_ping(host)
      Net::Ping::External.new(host)
    end

    def self.http_ping(host)
      host = "http://#{host}" unless host.match(/^(http|https):\/\//i)
      Net::Ping::HTTP.new(host)
    end

    def self.dns_ping(host)
      dns = Net::DNS::Resolver.start(host)
      dns.answer.select {|r| r.type == "CNAME"}&.map(&:cname)
    end
  end
end
