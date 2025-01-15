# qb-deployradar

A custom FiveM script for deploying and managing speed radars in a server. This script allows police officers to deploy radars, track vehicle speeds, and notify officers when a vehicle exceeds the speed limit.

## Features

- Allows Police to Deploy speed radars with configurable speed limits.
- Remove radars when player disconnects.
- Notify officer when a vehicle exceeds the speed limit in the radar zone.

## Config

### **`config.lua`**

Configuration file for radar settings.

- **Config.Object**: The model for the radar object to be deployed. (Currently set to a TV, but you may change the object to your liking.)
- **Config.MaxRadars**: Maximum number of radars a player can deploy.
- **Config.ClockRadius**: Radius of speed detection around each radar.

---

## Commands

### `/deployradar`
- **Description**: Deploy a speed radar at the player's location.
- **Usage**: `/deployradar <speedlimit>`
  - `<speedlimit>`: The speed limit to set for the radar (in miles per hour).
- **Permissions**: Only accessible by police officers.

### `/removeradar`
- **Description**: Remove the radar closest to the player.
- **Usage**: `/removeradar`
- **Permissions**: Only accessible by police officers.

---

## Dependencies

- [QBCore Framework](https://github.com/qbcore-framework)

---

## Installation

1. **Download the repository**
2. **Unzip and place the folder** into your resource folder.
3. **Add the resource** to your `server.cfg`:
   ```bash
   ensure qb-deployradar
