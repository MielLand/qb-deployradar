# qb-deployradar

A custom FiveM script for deploying and managing speed radars in a server. This script allows police officers to deploy radars, track vehicle speeds, and notify officers when a vehicle exceeds the speed limit.

## Features

- Deploy speed radars with configurable speed limits.
- Remove radars when player disconnects.
- Notify officers when a vehicle exceeds the speed limit in the radar zone.
- Ground detection for accurate radar placement.

## Files

### 1. **`client.lua`**

Contains the client-side logic for deploying and interacting with radars, as well as checking if players are speeding within the radar's detection range.

- **DeployRadar Event**: Deploys a radar object and adds it to the active radars list.
- **RemoveRadar Event**: Removes the radar object from the world when it is no longer needed.
- **Radar Check**: Every 1.5 seconds, checks if a player is in a vehicle and if they exceed the speed limit within the radar's range.
- **Ground Z Calculation**: Requests the correct ground height for radar deployment.

#### Important Functions:

- `isWithinBoundary(coords, center, radius)`: Checks if the player's coordinates are within the radar's boundary (a specified radius).
  
---

### 2. **`server.lua`**

Contains the server-side logic for managing radar deployment, removal, and player checks.

- **`/deployradar` Command**: Deploy a speed radar with a speed limit.
- **`/removeradar` Command**: Removes the radar closest to the player if they are a police officer.
- **Player Dropped Event**: Removes radars assigned to players who leave the server.
- **Radar Notifications**: Notifies the officer who deployed the radar when a player exceeds the speed limit.

#### Important Functions:

- `isPlayerPolice(source)`: Checks if the player is a police officer.
- `getGroundZFromClient(x, y, z, callback)`: Requests ground Z position from the client to ensure the radar is placed on solid ground.

---

### 3. **`config.lua`**

Configuration file for radar settings.

- **Config.Object**: The model for the radar object to be deployed.
- **Config.MaxRadars**: Maximum number of radars a player can deploy.
- **Config.ClockRadius**: Radius of detection around each radar.

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
- This script assumes that QBCore is used for server-side player management and commands.

---

## Installation

1. **Clone the repository** or download the script files.
2. **Place the files** (`client.lua`, `server.lua`, `config.lua`) into your resource folder.
3. **Add the resource** to your `server.cfg`:
   ```bash
   ensure MielRadar
