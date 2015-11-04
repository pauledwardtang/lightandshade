#Description of AI behaviors

The AI will move Shades in groups whenever possible.
The AI will keep some shades near the Eyes whenever possible.

The AI will have a few layers, each performing different functions.

A lower layer throws together "battle plans" that is- ways that very small objectives can be achieved.

A higher layer selects between the options provided by the lower layer. We will think of this layer as the one the "Eyes" operate on- they select plans based on their position, personality, available Shades, and the base "goodness" of the plans. This will more-or-less be starting with a number, multiplying it by Eye-specific modifiers, and going with the plan associated with the biggest one.

The highest layer is the "boss" of the Eyes. It decides whether or not the AI-player as a whole should be offensive or defensive, allocates Shades to the Eyes that need them, and maintains things like the vector field that is used to represent light levels.

## High-level behaviors ##

### Capture ###
  * Identify blind light units
    * The AI keeps a list of blind light units, blind dark units
  * Send shades to pull them away from areas with a lot of light

### Rescue ###
  * Identify blind dark units, decide how many Shades will have to be sent to turn a profit. Attempt to cut off the light source if it is profitable.

### Push ###
  * Use blinded Shades to advance on a light source.

### Defend ###
  * Use blinded Shades to keep the light player from advancing.


## Lower-level behaviors ##

### Identify dark/light areas ###
  * This could be done all sorts of fun ways. That said, we'll probably do it the following way unless someone has a better idea.
  * A "heat map", kept by the AI might be the most straightforward way of doing it.
    * Such a heat map could be updated either by how often light particles pass over its regions
    * Could also be built up based on how often Shades get lit up. (Possibly more realistic)
    * Stores (average) direction of light particles that pass over its regions, making it a vector field.

### Determine push/defense values ###
  * This might be tricky, and will certainly take some tinkering.
  * The AI asks, "how many Shades do I need to Capture/Rescue all of the units in that area? How many am I likely to lose in the attempt?
  * When if figures out that number, the number is modified (possibly based on the AI's personality, a "intelligence" value to send more than needed, less than needed, or exactly the right amount.

### Identify areas to cut off light ###
  * The AI wants to cut off light to free Shades and to capture light units.
  * If we store the "heat map" of light particles as a vector field, we can determine where the light is coming from, and where it can be cut off.
  * Start at the units we want to blind/capture, trace the vectors to an area that can be easily choked off.
  * "easily choked off" is variable, based on the number of Shades that are available for the operation. If there only a few, then it is more restrictive. If the AI has a whole swarm of Shades, they might consider more "difficult" areas.

## AI Tasks ##
AI tasks involve selecting from these main behaviors.

The AI can perform one of these per non-blind-Eye.

While the AI is associated with the Eyes, it should not be built into the code for the Eyes.

Which Eye controls which Shades?
If x is the current number of non-blind Shades, then the number of Shades controlled by a given Eye is x/3, +/- a random number, for variation. The playfield will be split into three parts, where each part has ~1/3 of the Shades. The shades in each part will be assigned to one of the Eyes. If they are not close, Shades will be moved toward their Eye, and the Eye will move toward its Shades. This behavior should take place quickly, early in the game.

If an Eye goes blind, its shades are _slowly_ reassigned to a new Eye based on proximity, and the number of Shades currently controlled by that Eye.