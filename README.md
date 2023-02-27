# Spike strips
Spike strips for FiveM server using ox_lib and ox_target

![img](https://i.imgur.com/DDJ4mDg.jpg)

## Features
- Sync with all player
- Animation when launch and grab spike
- Job restriction for grab
- Only burst the tire that hit the spikestrip and automatically removes the spikestrip
- Spikestrip can be broke when you remove it (Configurable)


## Requirement
- Onesnyc
- ESX or QB
- [ox_lib](https://github.com/overextended/ox_lib)
- [ox_target](https://github.com/overextended/ox_target)

## Installation
- ESX
Execute SQL request :
```SQL
INSERT INTO `items` (`name`, `label`, `weight`, `rare`, `can_remove`) VALUES ('spike', 'Herse', 1, 0, 1);
```

- QB
Insert into items.lua
```lua
{['spike'] = {['name'] = 'spike', ['label'] = 'Spike strips', ['weight'] = 7000, ['type'] = 'item', ['image'] = 'spike.png', ['unique'] = false, ['useable'] = true, ['shouldClose'] = true, ['combinable'] = nil, ['description'] = 'A spike Strips'}
```

- Add to server.cfg
```lua
ensure axio_spikes
```