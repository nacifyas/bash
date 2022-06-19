import urllib.request, socket, os

DOMAIN = "vpn.atomflare.tk"
CURRENT_IP = urllib.request.urlopen('https://ident.me').read().decode('utf8')
DOMAIN_IP = socket.gethostbyname(DOMAIN)

def send_email():
    cmd = '''echo Atomflare Public IP address has changed. Cloudflare registries states it is {}. The current IP address is: {}  | mail -s "IP ADDRESS CHANGE NOTIFICATION" atomflare.events@gmail.com'''.format(DOMAIN_IP, CURRENT_IP)
    os.system(cmd)

def main():
    if DOMAIN_IP != CURRENT_IP:
        print("Detected IP address change")
        print(" - Atomflare IP: {}".format(DOMAIN_IP))
        print(" - System IP: {}".format(CURRENT_IP))
        print("sending email")
        send_email()
        print("Email sent!")
    else:
        print("IP address match")

if __name__ == "__main__":
    main()