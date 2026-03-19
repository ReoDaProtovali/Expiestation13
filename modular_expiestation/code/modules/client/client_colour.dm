#define PRIORITY_ABSOLUTE 1
#define PRIORITY_HIGH 10
#define PRIORITY_NORMAL 100
#define PRIORITY_LOW 1000

/datum/client_colour/mindwiped //Desaturated, not quite greyscale.
	colour = list(rgb(200, 100, 100),
				  rgb(100, 200, 100),
				  rgb(100, 100, 200))
	priority = PRIORITY_HIGH - 1 //Slightly above other high prio things, but not absolute
	fade_out = 5 SECONDS //if you do somehow get un-mindwiped, colors will fade back gradually.

#undef PRIORITY_ABSOLUTE
#undef PRIORITY_HIGH
#undef PRIORITY_NORMAL
#undef PRIORITY_LOW
