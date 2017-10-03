mkdir /etc/yum.repos.d/backup
#
#--------------------------------
mv /etc/yum.repos.d/*.repo /etc/yum.repos.d/backup
#
#--------------------------------

echo '[client]
name=yum client
baseurl=ftp://10.130.10.167/pub/spacewalkclnt
enabled=1
gpgcheck=0' >> /etc/yum.repos.d/spacewalkclient.repo
#
#--------------------------------

yum -y install  spacewalk-client-repo
#
#--------------------------------

mv /etc/yum.repos.d/spacewalk-client*.repo /etc/yum.repos.d/backup
#
#--------------------------------

yum -y install rhn-client-tools rhn-check rhn-setup rhnsd m2crypto yum-rhn-plugin osad 

#
#--------------------------------

echo '-----BEGIN PGP PUBLIC KEY BLOCK-----
Version: GnuPG v1.4.5 (GNU/Linux)

mQINBE4P06MBEACqn48FZgYkG2QrtUAVDV58H6LpDYEcTcv4CIFSkgs6dJ9TavCW
NyPBZRpM2R+Rg5eVqlborp7TmktBP/sSsxc8eJ+3P2aQWSWc5ol74Y0OznJUCrBr
bIdypJllsD9Fe+h7gLBXTh3vdBEWr2lR+xA+Oou8UlO2gFbVFQqMafUgU1s0vqaE
/hHH0TzwD0/tJ6eqIbHwVR/Bu6kHFK4PwePovhfvyYD9Y+C0vOYd5Ict2vbLHz1f
QBDZObv4M6KN3j7nzme47hKtdMd+LwFqxM5cXfM6b5doDulWPmuGV78VoX6OR7el
x1tlfpuiFeuXYnImm5nTawArcQ1UkXUSYcTUKShJebRDLR3BycxR39Q9jtbOQ29R
FumHginovEhdUcinRr22eRXgcmzpR00zFIWoFCwHh/OCtG14nFhefuZ8Z80qbVhW
2J9+/O4tksv9HtQBmQNOK5S8C4HNF2M8AfOWNTr8esFSDc0YA5/cxzdfOOtWam/w
lBpNcUUSSgddRsBwijPuWhVA3NmA/uQlJtAo4Ji5vo8cj5MTPG3+U+rfNqRxu1Yc
ioXRo4LzggPscaTZX6V24n0fzw0J2k7TT4sX007k+7YXwEMqmHpcMYbDNzdCzUer
Zilh5hihJwvGfdi234W3GofttoO+jaAZjic7a3p6cO1ICMgfVqrbZCUQVQARAQAB
tEZDZW50T1MtNiBLZXkgKENlbnRPUyA2IE9mZmljaWFsIFNpZ25pbmcgS2V5KSA8
Y2VudG9zLTYta2V5QGNlbnRvcy5vcmc+iQI8BBMBAgAmBQJOD9OjAhsDBQkSzAMA
BgsJCAcDAgQVAggDBBYCAwECHgECF4AACgkQCUb8osEFud6ajRAAnb6d+w6Y/v/d
MSy7UEy4rNquArix8xhqBwwjoGXpa37OqTvvcJrftZ1XgtzmTbkqXc+9EFch0C+w
ST10f+H0SPTUGuPwqLkg27snUkDAv1B8laub+l2L9erzCaRriH8MnFyxt5v1rqWA
mVlRymzgXK+EQDr+XOgMm1CvxVY3OwdjdoHNox4TdVQWlZl83xdLXBxkd5IRciNm
sg5fJAzAMeg8YsoDee3m4khg9gEm+/Rj5io8Gfk0nhQpgGGeS1HEXl5jzTb44zQW
qudkfcLEdUMOECbu7IC5Z1wrcj559qcp9C94IwQQO+LxLwg4kHffvZjCaOXDRiya
h8KGsEDuiqwjU9HgGq9fa0Ceo3OyUazUi+WnOxBLVIQ8cUZJJ2Ia5PDnEsz59kCp
JmBZaYPxUEteMtG3yDTa8c8jUnJtMPpkwpSkeMBeNr/rEH4YcBoxuFjppHzQpJ7G
hZRbOfY8w97TgJbfDElwTX0/xX9ypsmBezgGoOvOkzP9iCy9YUBc9q/SNnflRWPO
sMVrjec0vc6ffthu2xBdigBXhL7x2bphWzTXf2T067k+JOdoh5EGney6LhQzcp8m
YCTENStCR+L/5XwrvNgRBnoXe4e0ZHet1CcCuBCBvSmsPHp5ml21ahsephnHx+rl
JNGtzulnNP07RyfzQcpCNFH7W4lXzqM=
=jrWY
-----END PGP PUBLIC KEY BLOCK-----' > /etc/yum.repos.d/RPM-GPG-KEY-CentOS-6

#
#-------------------------------------------------

rpm --import /etc/yum.repos.d/RPM-GPG-KEY-CentOS-6
#
#-------------------------------------------------

rhnreg_ks --force --serverUrl=http://10.130.10.167/XMLRPC --activationkey=1-9b04ede92fa04ddf66d0a99c7e298113
#
#-------------------------------------------------

echo 'Certificate:
    Data:
        Version: 3 (0x2)
        Serial Number:
            ab:5d:6a:14:52:fa:f1:9e
        Signature Algorithm: sha1WithRSAEncryption
        Issuer: C=IN, ST=Maharashtra, L=Navi Mumbai, O=RIL, OU=spacewalksvr, CN=spacewalksvr
        Validity
            Not Before: Oct  5 14:52:22 2013 GMT
            Not After : Sep 29 14:52:22 2036 GMT
        Subject: C=IN, ST=Maharashtra, L=Navi Mumbai, O=RIL, OU=spacewalksvr, CN=spacewalksvr
        Subject Public Key Info:
            Public Key Algorithm: rsaEncryption
                Public-Key: (2048 bit)
                Modulus:
                    00:aa:e0:59:a9:79:fe:a5:73:3a:1e:08:22:da:d8:
                    d5:15:f4:cf:0d:e7:7f:4b:dc:9e:80:24:1e:6d:68:
                    7b:8b:e5:bf:24:d5:a7:31:17:27:d8:c7:86:50:cb:
                    a8:8e:25:40:6c:dd:2a:17:2b:0f:d9:fa:c7:be:fc:
                    24:05:51:f7:94:99:72:31:f7:33:92:41:36:f1:c9:
                    1b:a8:0e:1f:ee:4a:c1:b3:ec:fc:9c:4f:3d:b6:1a:
                    8c:06:80:f9:1a:26:39:67:65:18:f3:53:e3:46:ef:
                    b7:0a:7f:7b:a2:5f:23:a9:a1:73:6f:63:05:95:e4:
                    f1:07:13:e5:0e:33:6f:53:97:26:81:88:e9:a9:fa:
                    34:81:c0:76:e8:29:96:97:3f:b7:7a:ae:ab:85:ad:
                    9d:b5:6f:04:1d:f9:5d:05:99:71:60:90:51:c9:4a:
                    98:4b:3b:53:0b:c4:af:4c:dc:fb:3a:a2:81:63:b7:
                    56:dc:6d:13:bf:a8:1c:5d:f4:0a:dc:b0:3e:06:54:
                    c8:da:15:7c:7d:3b:01:06:6a:4a:97:fe:57:9f:1c:
                    87:5b:1b:ad:e5:f9:46:f4:40:0a:0f:6e:1f:9a:69:
                    0e:cb:1f:12:6f:ac:9a:92:79:5d:c6:24:9f:5e:b0:
                    e5:cd:6a:54:d1:06:27:55:95:dd:4f:b7:33:72:1a:
                    2b:8b
                Exponent: 65537 (0x10001)
        X509v3 extensions:
            X509v3 Basic Constraints:
                CA:TRUE
            X509v3 Key Usage:
                Digital Signature, Key Encipherment, Certificate Sign
            X509v3 Extended Key Usage:
                TLS Web Server Authentication, TLS Web Client Authentication
            Netscape Comment:
                RHN SSL Tool Generated Certificate
 X509v3 Subject Key Identifier:
                30:E3:53:C7:DE:FC:A4:B9:5C:E4:8D:02:02:56:99:D4:01:2C:40:94
            X509v3 Authority Key Identifier:
                keyid:30:E3:53:C7:DE:FC:A4:B9:5C:E4:8D:02:02:56:99:D4:01:2C:40:94
                DirName:/C=IN/ST=Maharashtra/L=Navi Mumbai/O=RIL/OU=spacewalksvr/CN=spacewalksvr
                serial:AB:5D:6A:14:52:FA:F1:9E

    Signature Algorithm: sha1WithRSAEncryption
        7f:85:43:4c:d0:eb:14:8b:21:e7:8e:0f:1a:7b:2d:62:67:b6:
        1d:84:3f:39:1a:f6:65:12:c5:ca:41:6e:ee:e1:8f:b0:fd:eb:
        cc:2f:94:a1:ce:fa:87:8b:a4:e7:a1:db:75:37:4f:38:d5:d5:
        c7:05:a0:17:c5:42:f2:67:06:a4:9f:81:bf:46:db:a1:fe:43:
        95:36:80:e9:70:82:39:58:cd:0e:1b:30:c9:4e:63:dd:da:f5:
        db:36:f3:7e:0b:5e:82:a6:63:c3:2e:46:61:57:30:1b:2e:18:
        cb:15:f7:6e:8d:9a:df:55:1a:42:0c:6e:26:d7:29:e2:06:e4:
        5c:2b:48:7a:ce:59:95:74:aa:88:78:b5:12:c2:05:c4:73:8c:
        e8:94:12:54:2d:01:6a:8c:39:a5:86:6d:c8:4e:81:3a:7f:cf:
        54:ac:1d:05:c4:fc:ed:7f:2b:4e:a7:0a:2d:6e:de:40:85:05:
        1b:98:d1:72:02:35:45:de:b9:de:9f:ef:d4:d9:e3:c4:e9:3b:
        18:b1:ac:25:8d:83:17:5c:f2:d5:fc:a5:ab:62:cd:4f:bc:86:
        68:02:16:1e:8d:2c:e7:ef:52:81:e2:a9:2d:d5:30:f6:f3:15:
        36:bf:27:97:c2:b8:1c:24:09:86:05:44:8d:87:91:8e:d2:d9:
        eb:7c:7f:4b
-----BEGIN CERTIFICATE-----
MIIEqTCCA5GgAwIBAgIJAKtdahRS+vGeMA0GCSqGSIb3DQEBBQUAMHUxCzAJBgNV
BAYTAklOMRQwEgYDVQQIEwtNYWhhcmFzaHRyYTEUMBIGA1UEBxMLTmF2aSBNdW1i
YWkxDDAKBgNVBAoTA1JJTDEVMBMGA1UECxMMc3BhY2V3YWxrc3ZyMRUwEwYDVQQD
EwxzcGFjZXdhbGtzdnIwHhcNMTMxMDA1MTQ1MjIyWhcNMzYwOTI5MTQ1MjIyWjB1
MQswCQYDVQQGEwJJTjEUMBIGA1UECBMLTWFoYXJhc2h0cmExFDASBgNVBAcTC05h
dmkgTXVtYmFpMQwwCgYDVQQKEwNSSUwxFTATBgNVBAsTDHNwYWNld2Fsa3N2cjEV
MBMGA1UEAxMMc3BhY2V3YWxrc3ZyMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIB
CgKCAQEAquBZqXn+pXM6Hggi2tjVFfTPDed/S9yegCQebWh7i+W/JNWnMRcn2MeG
UMuojiVAbN0qFysP2frHvvwkBVH3lJlyMfczkkE28ckbqA4f7krBs+z8nE89thqM
BoD5GiY5Z2UY81PjRu+3Cn97ol8jqaFzb2MFleTxBxPlDjNvU5cmgYjpqfo0gcB2
6CmWlz+3eq6rha2dtW8EHfldBZlxYJBRyUqYSztTC8SvTNz7OqKBY7dW3G0Tv6gc
XfQK3LA+BlTI2hV8fTsBBmpKl/5XnxyHWxut5flG9EAKD24fmmkOyx8Sb6yaknld
xiSfXrDlzWpU0QYnVZXdT7czchoriwIDAQABo4IBOjCCATYwDAYDVR0TBAUwAwEB
/zALBgNVHQ8EBAMCAqQwHQYDVR0lBBYwFAYIKwYBBQUHAwEGCCsGAQUFBwMCMDEG
CWCGSAGG+EIBDQQkFiJSSE4gU1NMIFRvb2wgR2VuZXJhdGVkIENlcnRpZmljYXRl
MB0GA1UdDgQWBBQw41PH3vykuVzkjQICVpnUASxAlDCBpwYDVR0jBIGfMIGcgBQw
41PH3vykuVzkjQICVpnUASxAlKF5pHcwdTELMAkGA1UEBhMCSU4xFDASBgNVBAgT
C01haGFyYXNodHJhMRQwEgYDVQQHEwtOYXZpIE11bWJhaTEMMAoGA1UEChMDUklM
MRUwEwYDVQQLEwxzcGFjZXdhbGtzdnIxFTATBgNVBAMTDHNwYWNld2Fsa3N2coIJ
AKtdahRS+vGeMA0GCSqGSIb3DQEBBQUAA4IBAQB/hUNM0OsUiyHnjg8aey1iZ7Yd
hD85GvZlEsXKQW7u4Y+w/evML5ShzvqHi6Tnodt1N0841dXHBaAXxULyZwakn4G/
Rtuh/kOVNoDpcII5WM0OGzDJTmPd2vXbNvN+C16CpmPDLkZhVzAbLhjLFfdujZrf
VRpCDG4m1yniBuRcK0h6zlmVdKqIeLUSwgXEc4zolBJULQFqjDmlhm3IToE6f89U
rB0FxPztfytOpwotbt5AhQUbmNFyAjVF3rnen+/U2ePE6TsYsawljYMXXPLV/KWr
Ys1PvIZoAhYejSzn71KB4qkt1TD28xU2vyeXwrgcJAmGBUSNh5GO0tnrfH9L
-----END CERTIFICATE-----
' > /usr/share/rhn/RHN-ORG-TRUSTED-SSL-CERT
#
#------------------------------------------------------------------

sed -i "s/osa_ssl_cert \=/osa_ssl_cert \= \/usr\/share\/rhn\/RHN-ORG-TRUSTED-SSL-CERT/g" /etc/sysconfig/rhn/osad.conf


service osad start

#------------------------------------------------------------------

echo '[client]
name=Software yum
baseurl=ftp://10.130.10.167/pub/Software
enabled=1
gpgcheck=0' >> /etc/yum.repos.d/spacewalkclient.repo
