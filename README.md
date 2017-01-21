# Dota 2 Bot Scripts

The aim of this bot is for extreme [pushing](http://dota2.gamepedia.com/Pushing). You can download the bot with name "ExtremePush" on workshop.

### v.20170121

**Keeper of the Light**

Huge improvements for KOTL, including:

- Now bots know how to purchase from secret shop. This results in much better item builds.
One of the KOTL will be named as support and will purchase support items: Mekansm and Pipe.
Other bots will purchase Shadow Blade and Shivas Guard.
- Now bots know how to purcahse and use TP Scroll. The TP logic is based on the **default** team desires. So it's more of a double-edged sword: Good decisions result in better results and bad decisions result in bigger mess.
- Now bots will have custom ability upgrade path and will also be able to upgrade talents.
- Chakra Magic will be casted on teammates also.
- Illuminate will end if the casting hero is in danger. Also it will ignore neutral creeps.
- Mana leak will be casted more aggressively.

### v.20170117

**Keeper of the Light**

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
