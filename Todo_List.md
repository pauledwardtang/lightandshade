# To do #

## Fix broken stuff ##

---

### Movement ###
  * Units should go where they're ordered unless blocked by a unit that is currently executing an order
  * Less bounciness
  * Sort out force/mass/density stuff, so units move at reasonable speeds
  * Implement mousewheel focusing
  * Implement mousewheel turning

## Redo limited features ##

---


### Level generator ###
  * Should be more flexible
  * Obstacle generator should be able to generate different kinds of obstacles based on input parameters
    * takes: color, #sides, width, height, etc.
  * Obstacle placement should be procedural instead of pre-determined
  * Level generator should generate varied backgrounds, obstacle colors

### Manipulation ###
  * Manipulation needs to be easy to do
  * Visually obvious
    * Tooltip?


## New things ##

---

### AI ###
  * Not actually a huge deal anymore. We will explore this once we fix unfun things.

### Larger maps, with scrolling ###
  * This involves rewriting all the draw functions to deal with the relative position of the camera.

### Campaign? ###
  * A series of levels introducing new tactics.
  * Include tutorials.

### Multiplayer? ###
  * Processing has libraries that would make this possible