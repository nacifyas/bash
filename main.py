import urllib.request, socket, os, redis

DOMAIN = "vpn.atomflare.tk"
CURRENT_IP = urllib.request.urlopen('https://ident.me').read().decode('utf8')
DOMAIN_IP = socket.gethostbyname(DOMAIN)
WAIT_TIME = 12
REDIS_HOST = "atomflare.af"
REDIS_PORT = "6385"
r = redis.StrictRedis(REDIS_HOST, REDIS_PORT, charset='utf-8', decode_responses=True)
REDIS_STATUS = r.ping()

def send_email():
    cmd = '''echo "Atomflare Public IP address has changed.\n\nCloudflare registries have {}.\nThe current IP address is: {}\n\nTargeted domain is: {}"  | mail -s "IP ADDRESS CHANGE NOTIFICATION" atomflare.events@gmail.com'''.format(DOMAIN_IP, CURRENT_IP, DOMAIN)
    os.system(cmd)


def main():
    if DOMAIN_IP != CURRENT_IP:
        print("Detected IP address change")
        print(" - Atomflare IP: {}".format(DOMAIN_IP))
        print(" - System IP: {}".format(CURRENT_IP))
        if int(r.get("WAIT_TIME")) == 0 or r.get("LOGGED_IP") != CURRENT_IP:
            print("sending email")
            send_email()
            print("Email sent!")
            r.set(name="WAIT_TIME", value=WAIT_TIME)
            r.set(name="LOGGED_IP", value=CURRENT_IP)
        else:
            remaining_time = int(r.get("WAIT_TIME"))
            r.set(name="WAIT_TIME", value=remaining_time-1)
            print("Notification sent {} hours ago. If the problem persists, next email notification will be sent in {} hours".format(WAIT_TIME-remaining_time, remaining_time))
    else:
        print("IP address match. Everything is fine")
        r.set(name="WAIT_TIME", value=0)


if __name__ == "__main__":
    if REDIS_STATUS:
        r.setnx(name="WAIT_TIME", value=0)
        main()
    else:
        send_email()