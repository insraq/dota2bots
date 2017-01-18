# Dota 2 Bot Scripts

The aim of this bot is for extreme [pushing](http://dota2.gamepedia.com/Pushing).

## Completed Bots

### Keeper of the Light

Key Strategies:

- Chakra Magic: cast when available
- Illuminate: cast and channel when there are creeps within range. Cancel channelling when the hero is "threatened".
- Mana leak: cast on the enenmy hero within the range that has lowest HP.
- Illuminate and Mana leak are casted when there is enough mana left for Chakra Magic.
- Other abilities are not casted at all. I found out when Spirit Form is on, the hero will have weird behaviors.
- Phase Boots and Necronomicon: purchase and cast when available.
- Mekansm and Pipe of Insight: purchase and cast when a nearby teammates has HP <= 400.
- Dagon: purcahse and cast on the enenmy hero within the range that has lowest HP.

For test runs, please see [Issue #1](https://github.com/insraq/dota2bots/issues/1)

![Test Run Keeper of the Light](https://cloud.githubusercontent.com/assets/608221/22066488/1eb64e12-ddc8-11e6-8882-fa93c0c07cd3.png)
