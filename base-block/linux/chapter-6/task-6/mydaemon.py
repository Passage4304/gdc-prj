#!/usr/bin/env python3

import time
import logging

LOG_FILE = "/var/log/mydaemon.log"

logging.basicConfig(filename=LOG_FILE, level=logging.INFO, format='%(asctime)s %(message)s')

def main():
    while True:
        logging.info("Демон работает...")
        time.sleep(60)

if __name__ == "__main__":
    main()
