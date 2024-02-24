//////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////
 
#include <stdio.h>
#include "xparameters.h"
#include "xil_io.h"

#define AXI_DATA_BYTE 4
 
int main() {
    unsigned int data1;
    unsigned int data2;

	int sec, min, hour, day, year;
    while (1) {
    	printf("======= Hello Project Watch ======\n");
    	printf("plz input freq (1 <= input <= 1GHz)\n");
    	scanf("%d",&data1);
    	Xil_Out32((XPAR_WATCH_0_BASEADDR) + (0*AXI_DATA_BYTE), (u32)(data1));
    	printf("WATCH (year : day : hour : min : sec)\n");

		while(1) {
    		data1 = Xil_In32((XPAR_WATCH_0_BASEADDR) + (1*AXI_DATA_BYTE));
    		data2 = Xil_In32((XPAR_WATCH_0_BASEADDR) + (2*AXI_DATA_BYTE));
			sec = data1 & 0x3F;
			min = (data1>>6) & 0x3F;
			hour = (data1>>12) & 0x1F;
			day = data2 & 0x1FF;
			year = (data2>>9) & 0xFFF;
    		printf("\r(%4d Y : %2d D : %2d h :%2d m :%2d s) ", year, day, hour, min, sec); // https://stackoverflow.com/questions/15192441/update-printf-value-on-same-line-instead-of-new-one
			fflush(stdout);
	        // wait (for example, 10000 us or 0.01 sec), To prevent over send to PC through uart.
	        usleep(10000);
		}
    }
    return 0;
}

