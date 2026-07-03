#!/usr/bin/env python3

"""Apply the vendored Ghostty palette to iTerm2's default and tmux profiles."""

import asyncio
import plistlib
from pathlib import Path

import iterm2


THEME_FILE = Path(__file__).resolve().with_name(
    "Ghostty Default Style Dark.itermcolors"
)
EXTRA_PROFILE_NAMES = {"tmux"}
COLOR_COMPONENTS = {
    "Red Component",
    "Green Component",
    "Blue Component",
}


def profile_guid(profile):
    return profile.all_properties["Guid"]


async def apply_theme(connection, profile, theme):
    guid = profile_guid(profile)
    updates = []

    for key, value in theme.items():
        if not isinstance(value, dict) or not COLOR_COMPONENTS.issubset(value):
            continue
        for suffix in ("", " (Dark)", " (Light)"):
            updates.append(
                iterm2.rpc.async_set_profile_property(
                    connection,
                    None,
                    key + suffix,
                    value,
                    [guid],
                )
            )

    updates.append(
        iterm2.rpc.async_set_profile_property(
            connection,
            None,
            "Use Separate Colors for Light and Dark Mode",
            True,
            [guid],
        )
    )
    await asyncio.gather(*updates)


async def main(connection):
    with THEME_FILE.open("rb") as theme_file:
        theme = plistlib.load(theme_file)

    profiles = {}
    default_profile = await iterm2.Profile.async_get_default(connection)
    profiles[profile_guid(default_profile)] = default_profile

    for partial in await iterm2.PartialProfile.async_query(connection):
        if partial.name in EXTRA_PROFILE_NAMES:
            profile = await partial.async_get_full_profile()
            profiles[profile_guid(profile)] = profile

    await asyncio.gather(
        *(apply_theme(connection, profile, theme) for profile in profiles.values())
    )


iterm2.run_until_complete(main)
