# -*- coding: utf-8 -*-
import re
import subprocess

DEFAULT_DPMS_TIMEOUT = 300

def get_dpms_timeout():
    command = "xset q | grep -A2 'DPMS' | grep Off"
    result = subprocess.run(command, shell=True, capture_output=True, text=True)
    output = result.stdout.strip()

    match = re.search(r'Off:\s*(\d+)', output)
    if match:
        return int(match.group(1))
    else:
        raise ValueError("Unable to determine DPMS timeout")

def disable_dpms():
    subprocess.run(['xset', 'dpms', '0', '0', '0'], check=True)

def enable_dpms(timeout=300):
    command = ['xset', 'dpms'] + ([str(timeout)] * 3)
    subprocess.run(command, check=True)

class Py3status:
    format = 'DPMS: {status}'

    def __init__(self):
        dpms_timeout = get_dpms_timeout()
        if dpms_timeout == 0:
            self.status = 'Off'
        else:
            self.status = str(dpms_timeout)

    def dpms_toggle(self):
        return {
            'full_text': self.py3.safe_format(self.format, {'status': self.status}),
            'cached_until': self.py3.CACHE_FOREVER
        }

    def on_click(self, _):
        if self.status == 'Off':
            enable_dpms(DEFAULT_DPMS_TIMEOUT)
            self.status = str(DEFAULT_DPMS_TIMEOUT)
        else:
            disable_dpms()
            self.status = 'Off'

if __name__ == "__main__":
    """
    Run module in test mode.
    """
    from py3status.module_test import module_test
    module_test(Py3status)
