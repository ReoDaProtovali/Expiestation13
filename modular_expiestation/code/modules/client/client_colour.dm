#define PRIORITY_ABSOLUTE 1
#define PRIORITY_HIGH 10
#define PRIORITY_NORMAL 100
#define PRIORITY_LOW 1000

/datum/client_colour/monochrome/mindwipe
	priority = PRIORITY_HIGH - 1 //Slightly above other high prio things, but not absolute

#undef PRIORITY_ABSOLUTE
#undef PRIORITY_HIGH
#undef PRIORITY_NORMAL
#undef PRIORITY_LOW
