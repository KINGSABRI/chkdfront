# Check Domain Fronting (chkdfront)
chkdfront checks if your domain fronting is working by testing the targeted domain (fronted domain) against your domain front domain.

```
MMMMMMMMMMMMMWNK0kdolc;,'      ;KMMMMMMMMMMMMMMMMMMMMMMMMMMM
MMMMMMMMMN0xl;'.                lNMMMMMMMMMMMMMMMMMMMMMMMMMM
MMMMMWKxc'.                     .kWMMMMMMMMMMMMMMMMMMMMMMMMM
MMN0o;.                          ;XMMMMMMMMMMMMMMMMMMMMMMMMM
Ol,.                             .xWMMMMMMMMMMMMMMMMMMMMMMMM
'                        .        ;XMMMMMMMMMMMMMMMMMMMMMMMM
l                    .;dO00ko;'.  .kMMMMMMMMMMMMMMMMMMMMMMMM
X:                   .dKNWWXOl,.   oWMMMMMMMMMMMMMMMMMMMMMMM
M0,        'ldkx;      .',,..,;:cc;dNMMMMMMMMMMMMMMMMMMMMMMM
MWk.     .doMaiN.          ;ONWWWWWWMMMMMMMMMMMMMMMMMMMMMMMM
MMWx.    lXXKkc.          :XMXOo;;coxOKNWMMMMMMMMMMMMMMMMMMM
MMMWx.   ....            ;KMXc.       .';cdkKNMMMMMMMMMMMMMM
MMMMWk.            .:oxxkXMNl               .,cx0NMMMMMMMMMM
MMMMMWO,         .oXWWXNMMNo.                   .,lONMMMMMMM
MMMMMMMXl.      .kNOo,;OWWx.                        'lONMMMM
MMMMMMMMWO;    .lx;.  lNMO'                           .,dKWM
MMMMMMMMMMNx;. ..    ,0MX:   .,:ll:,.                    .:x
MMMMMMMMMMMMNOc.    .dWWx.   .'lXWMNOc.                    .
MMMMMMMMMMMMMMWXOo:':KMX:       .cxO0k;                   .o
MMMMMMMMMMMMMMMMMMWNNWMk.                 ,domain.        .N
MMMMMMMMMMMMMMMMMMMMMMWo                  .fronting     .dNM
MMMMMMMMMMMMMMMMMMMMMMNc    ;,              'cdxko.    .kWMM
MMMMMMMMMMMMMMMMMMMMMMNc    lKOl.                     ;0WMMM
MMMMMMMMMMMMMMMMMMMMMMWo    ,KMW0l.                 .lXMMMMM
MMMMMMMMMMMMMMMMMMMMMMMk.    :kKMWXOdolcc:,.       ,kWMMMMMM
MMMMMMMMMMMMMMMMMMMMMMMNc     .'o0XNNNKOo;.      'dXMMMMMMMM
MMMMMMMMMMMMMMMMMMMMMMMMK;       ..''..        'dXWMMMMMMMMM
MM By: @KINGSABRI MMMMMMKc                  .:xXMMMMMMMMMMMM
MM chkdfront v1.0.1 MMMMNk;.            .'cxKWMMMMMMMMMMMMMM
MMMMMMMMMMMMMMMMMMMMMMMMMMMMNxl:'....':oOXWMMMMMMMMMMMMMMMMM
Check DomainFront (chkdfront) - A tool verifies domain fronting.
```
## Features
* Checking your domain fronted against the domain front.
* Searching an expected string in the response to indicate success.
* Showing troubleshooting suggestions when test fails based on the failure natural.
* Inspecting the HTTP request and response when test fails. (optionally if succeeded).
* Troubleshooting with various checks (ping, http, nslookup) when test fails. (optionally if succeeded).
* Support testing though proxy

## Demo
Please check below demo
https://asciinema.org/a/nA9wBiuSDLDH9SunQ8GxKT2ra

## Installation

    $ gem install chkdfront

## Usage

```
Help menu:
    -f, --front-target URL           Fronted target domain or URL.
                                     	e.g. images.businessweek.com
    -d, --domain-front DOMAIN        DomainFront domain.
                                     	e.g. df36z1umwj2fze.cloudfront.net
    -e, --expect STRING              Expect a given string that indicates success. (case-sensitive)
                                     	e.g. It works
    -p, --provider NUM               Choose CDN / Domain Front Provider:
                                     	[0] Auto    (default - auto tune request. Extra request to detect)
                                     	[1] Amazon  (tune request for Amazon domain fronting)
                                     	[2] Azure   (tune request for Azure domain fronting)
                                     	[3] Alibaba (tune request for Alibaba domain fronting)
    -t, --troubleshoot [DOMAIN]      Force troubleshooting procedures.
                                     execute troubleshooting procedures(ping, http, nslookup) for all parties
                                     (optional: original domain where CDN forwards, to include in the checks)
                                     	e.g. c2.mydomain.com
        --proxy USER:PASS@HOST:PORT  Use proxy settings if you're behind proxy.
                                     	e.g. user1:Pass123@localhost:8080
        --debug                      Force debugging.
                                     show response's body and low-level request and response debug trace.
                                     (default enabled when test fails.)
    -h, --help                       Show this message.

Usage:
  /usr/local/bin/chkdfront <OPTIONS>
Example:
  /usr/local/bin/chkdfront -f images.businessweek.com -d df36z1umwj2fze.cloudfront.net
  /usr/local/bin/chkdfront -f images.businessweek.com -d df36z1umwj2fze.cloudfront.net --debug -t c2.mysite.com
```

## Contributing

1. Fork it ( https://github.com/KINGSABRI/chkdfront/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request
