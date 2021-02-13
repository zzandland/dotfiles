#!/usr/bin/env python3
"""
The script makes an API call to check sunset and sunrise time to switch between light and dark theme for
Microsoft Terminal and Neovim.
"""
import json
import os
import requests
from datetime import datetime, timezone
from operator import itemgetter
from typing import Dict

HTTPError = requests.models

def utc_dt_to_local_t(utc_dt):
    return utc_dt.replace(tzinfo=timezone.utc).astimezone(tz=None).time()

def is_dark_theme() -> bool:
    """
    Return whether dark theme should be enabled or not.
    """
    payload = {
        'lat': 34.0536909,
        'lng': -118.242766,
        'formatted': 0,
    }
    r = requests.get('https://api.sunrise-sunset.org/json', params=payload)
    if r.status_code == 200:
        sunrise, sunset = itemgetter('sunrise', 'sunset')(r.json()['results'])
        format = '%Y-%m-%dT%H:%M:%S+00:00'
        sunrise_time = utc_dt_to_local_t(datetime.strptime(sunrise, format))
        sunset_time = utc_dt_to_local_t(datetime.strptime(sunset, format))
        return not sunrise_time <= datetime.now().time() <= sunset_time
    raise HTTPError('HTTP request returned status code: %d' % (r.status_code))

def update_zshrc(new_dark_mode: bool):
    ZSHRC_PATH = '~/.zshrc'

    with open(os.path.expanduser(ZSHRC_PATH), "r") as zshrc:
        lines = zshrc.readlines()
        old_color = lines[-1].split('=')[1].strip()
        new_color = 'dark' if new_dark_mode else 'light'

        if old_color != new_color:
            print('Updating Neovim background color')
            lines[-1] = 'export NVIM_BACKGROUND=%s\n' % (new_color)
            open(os.path.expanduser(ZSHRC_PATH), 'w').writelines(lines)

def update_config(config_path: str, data: Dict):
    with open(config_path, 'w') as config:
        json.dump(data, config, indent=2)
        print('updated: ' + config_path)

if __name__ == '__main__':
    TERMINAL_CONFIG_PATH = '/mnt/c/Users/zzand/AppData/Local/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/settings.json'
    DOTFILE_CONFIG_PATH = os.path.expanduser('~/.config/wsl/settings.json')

    # open the configuration file and update color profile
    with open(TERMINAL_CONFIG_PATH, 'r+') as config:
        data = json.load(config)
        is_dark = is_dark_theme()
        old_profile = data['profiles']['defaults']['colorScheme']
        new_profile = 'Gruvbox Dark' if is_dark else 'Gruvbox Light'
        if old_profile != new_profile:
            data['profiles']['defaults']['colorScheme'] = new_profile
            update_zshrc(is_dark)
            update_config(TERMINAL_CONFIG_PATH, data)
            update_config(DOTFILE_CONFIG_PATH, data)
