#!/usr/bin/env python3
"""
The script automatically sets profile colors based on iTerm2 application theme. To make this track the OS's
theme, set Iterm2's theme to one of the themes other than `Light` or `Dark` in the General settings.
To configure, update the mapping in `PROFILE_PRESETS` such that the profile name maps to the light and dark
presets you'd like to use.
"""

import asyncio
import os
from collections import namedtuple
from typing import Dict, List, Optional, Set, Union

import iterm2

ColorPresets = namedtuple('preset_name', ['light', 'dark'])

# Mapping of Profile Name to Color presets
PROFILE_PRESETS = {
    # Built in presets
    'Solarized (Auto)': ColorPresets('Solarized Light', 'Solarized Dark'),
    'Tango (Auto)': ColorPresets('Tango Light', 'Tango Dark'),
    'Default (Auto)': ColorPresets('Light Background', 'Dark Background'),

    # Custom
    'Gruvbox (Auto)': ColorPresets('Gruvbox Light', 'Gruvbox Dark'),
}

async def build_color_preset_lookup(connection: iterm2.connection.Connection, preset_names: set) -> Dict[str, iterm2.colorpresets.ColorPreset]:
    """
    Return map of color preset names to preset objects.
    This is used to minimize the number of async calls.
    """
    async def preset_name_to_preset(preset_name):
        preset = await iterm2.ColorPreset.async_get(connection, preset_name)
        print("Got preset for color preset name {}: {}".format(preset_name, preset))
        return preset_name, preset

    return dict(
        await asyncio.gather(*[
            preset_name_to_preset(preset_name) for preset_name in preset_names if preset_name
        ])
    )

def get_color_preset_for_profile(profile_name: str, dark_mode: bool) -> Optional[str]:
    """
    Get the color preset name for a particular preset, given whether its a dark or not-dark mode.
    If the profile is not a key in the PROFILE_PRESETS map, return None
    """
    if profile_name not in PROFILE_PRESETS:
        return None

    color_preset = PROFILE_PRESETS[profile_name]
    if dark_mode:
        return color_preset.dark
    else:
        return color_preset.light

def get_color_presets_for_profiles(profiles: List[iterm2.profile.PartialProfile], dark_mode: bool) -> Set[Optional[str]]:
    """
    Return a set of color presets, given a list of profiles.
    Will contain None for profiles we don't recognize.
    This allows us to fetch presets only once.
    """
    return {
        get_color_preset_for_profile(profile.name, dark_mode)
        for profile in profiles
    }

async def set_color_presets(connection: iterm2.connection.Connection, new_dark_mode: bool):
    """
    Set the color presets to the appropriate light/dark selection, for all open profiles
    """
    print("Setting dark color presets: {}".format(new_dark_mode))

    profiles = (await iterm2.PartialProfile.async_query(connection))

    names = get_color_presets_for_profiles(profiles, new_dark_mode)
    preset_lookup = await build_color_preset_lookup(connection, names)

    for profile in profiles:
        preset_name = get_color_preset_for_profile(profile.name, new_dark_mode)
        if not preset_name:
            continue
        preset = preset_lookup[preset_name]
        await profile.async_set_color_preset(preset)

def update_zshrc(new_dark_mode: bool):
    ZSHRC_PATH = '~/.zshrc'
    BATCONFIG_PATH = '~/.config/bat/config'

    with open(os.path.expanduser(ZSHRC_PATH), "r") as zshrc:
        lines = zshrc.readlines()
        old_color = lines[-1].split('=')[1].strip()
        new_color = 'dark' if new_dark_mode else 'light'

        if old_color != new_color:
            print('Updating Neovim background color')
            lines[-1] = 'export NVIM_BACKGROUND=%s\n' % (new_color)
            open(os.path.expanduser(ZSHRC_PATH), 'w').writelines(lines)

            with open(os.path.expanduser(BATCONFIG_PATH), "w") as batconfig:
                theme = 'gruvbox' if new_dark_mode else 'gruvbox-light'
                batconfig.write('--theme="%s"' % (theme))

async def is_dark_theme(monitor_or_app: Optional[Union[iterm2.VariableMonitor, iterm2.app.App]] = None) -> bool:
    """
    Return whether the iTerm2 application theme is currently dark or not
    """
    # Extract the theme name from the variable monitor or application object
    theme_name = None
    if isinstance(monitor_or_app, iterm2.VariableMonitor):
        theme_name = await monitor_or_app.async_get()
    elif isinstance(monitor_or_app, iterm2.app.App):
        theme_name = await monitor_or_app.async_get_variable("effectiveTheme")
    else:
        raise ValueError('Need a monitor or app instance to detect theme')

    # Themes have space-delimited attributes, one of which will be light or dark.
    parts = theme_name.split(" ")
    is_dark = "dark" in parts

    print("Detected theme and dark status: '{}' ({})".format(theme_name, is_dark))

    return is_dark

async def main(connection: iterm2.connection.Connection):
    app = await iterm2.app.async_get_app(connection)

    # Set colors initially because of unknown profile defaults
    is_dark = await is_dark_theme(app)
    await set_color_presets(connection, is_dark)
    was_dark = is_dark

    # Begin monitoring the effective theme
    async with iterm2.VariableMonitor(
        connection,
        iterm2.VariableScopes.APP,
        "effectiveTheme",
        None,
    ) as monitor:
        while True:
            is_dark = await is_dark_theme(monitor)
            if is_dark != was_dark:
                await set_color_presets(connection, is_dark)
                update_zshrc(is_dark)
                was_dark = is_dark

if __name__ == '__main__':
    iterm2.run_forever(main)
