#include <stdio.h>
#include <system.h>
#include <io.h>
#include <unistd.h>
#include <string.h>

int main(void)
{
	int bclk = 0;
	int bclk_save = 0;
	int countbclk = 0;

	int ADC_LR_CLK = 0;
	int ADC_LR_CLK_save = 0;
	int countADC_LR_CLK = 0;

//	alt_up_audio_dev * audio_dev;

	/* used for audio record/playback */
//	unsigned int l_buf;
//	unsigned int r_buf;

	// open the Audio port
//	audio_dev = alt_up_audio_open_dev(AUDIO_NAME);
//	if (audio_dev == NULL)
//	printf("Error: could not open audio device \n");
//	else
//	printf("Opened audio device \n");

	// Write something random to SDRAM for test
//	IOWR(SDRAM_BASE, 0xFF /* random address */, 0x64);

	/*  */
	while(1)
	{
		bclk = IORD(BCLK_BASE, 0);
		ADC_LR_CLK = IORD(ADC_LR_CLK_BASE, 0);

			if(bclk_save != bclk)
			{

				bclk_save = bclk;

				if(bclk_save)
				{
					countbclk++;
				}
			}

			if(ADC_LR_CLK_save != ADC_LR_CLK)
			{
				ADC_LR_CLK_save = ADC_LR_CLK;

				if(ADC_LR_CLK_save)
				{
					countADC_LR_CLK++;
					printf("%d: %i \r\n", countADC_LR_CLK, countbclk);
				}
			}




//			if(countbclk == 32)
//			{
//				printf("%i \r\n", countbclk);
//			}


			//usleep(500000);


//			IOWR(SDRAM_BASE, i, i);
//			IOWR(LEDS_BASE, 0, IORD(SDRAM_BASE, i));
//			usleep(1000);
//
//			if(IORD(SDRAM_BASE, i) > 0x00)
//			{
//				printf("%i \r\n", i);
//				IOWR(SDRAM_BASE, i, i);
//			}
//		}


		//Write to leds decimal 100 on address 0xFF
//		IOWR(LEDS_BASE, 0, IORD(SDRAM_BASE, 0xFF));

		// Audio bypass
//		int fifospace = alt_up_audio_read_fifo_avail(audio_dev, ALT_UP_AUDIO_RIGHT);
//		if ( fifospace > 0 ) // check if data is available
//		{
//			// read audio buffer
//			alt_up_audio_read_fifo (audio_dev, &(r_buf), 1, ALT_UP_AUDIO_RIGHT);
//			alt_up_audio_read_fifo (audio_dev, &(l_buf), 1, ALT_UP_AUDIO_LEFT);
//			// write audio buffer
//			alt_up_audio_write_fifo (audio_dev, &(r_buf), 1, ALT_UP_AUDIO_RIGHT);
//			alt_up_audio_write_fifo (audio_dev, &(l_buf), 1, ALT_UP_AUDIO_LEFT);
//		}
	}
}
