#include <stdio.h>
#include <system.h>
#include <io.h>
#include <unistd.h>
#include <string.h>

int main(void)
{
	alt_u8 switches;

	while(1)
	{
		switches = IORD(SWITCHES_BASE, 0);
		IOWR(ENABLE_BEAT_DETECTION_BASE, 0, switches & 1);
		IOWR(AUDIO_MUTE_BASE, 0, (switches >> 1) & 1);
		usleep(1000);
	}
}
