//--------------------------------------------------------------
// File     : main.c
// Datum    : 24.03.2013
// Version  : 1.0
// Autor    : UB
// EMail    : mc-4u(@)t-online.de
// Web      : www.mikrocontroller-4u.de
// CPU      : STM32F4
// IDE      : CooCox CoIDE 1.7.0
// Module   : CMSIS_BOOT, M4_CMSIS_CORE
// Funktion : Demo der DAC-DMA Library
// Hinweis  : Diese zwei Files muessen auf 8MHz stehen
//              "cmsis_boot/stm32f4xx.h"
//              "cmsis_boot/system_stm32f4xx.c"
//--------------------------------------------------------------

#include "main.h"
#include "stm32_ub_dac_dma.h"
#include "stdio.h"
#include "stm32f4_discovery.h"
#include "usbd_cdc_vcp.h"
#include <string.h>
#include "stm32f4xx_conf.h"

__ALIGN_BEGIN USB_OTG_CORE_HANDLE  USB_OTG_dev __ALIGN_END;


void adc_configure()
{
	ADC_InitTypeDef ADC_init_structure; //Structure for adc confguration
	GPIO_InitTypeDef GPIO_initStructre; //Structure for analog input pin
	//Clock configuration
	RCC_APB2PeriphClockCmd(RCC_APB2Periph_ADC1, ENABLE); //The ADC1 is connected the APB2 peripheral bus thus we will use its clock source
	RCC_AHB1PeriphClockCmd(RCC_AHB1ENR_GPIOCEN, ENABLE); //Clock for the ADC port!! Do not forget about this one ;)
	//Analog pin configuration
	GPIO_initStructre.GPIO_Pin = GPIO_Pin_0; //The channel 10 is connected to PC0
	GPIO_initStructre.GPIO_Mode = GPIO_Mode_AN; //The PC0 pin is configured in analog mode
	GPIO_initStructre.GPIO_PuPd = GPIO_PuPd_NOPULL; //We don't need any pull up or pull down
	GPIO_Init(GPIOC, &GPIO_initStructre); //Affecting the port with the initialization structure configuration
	//ADC structure configuration
	ADC_DeInit();
	ADC_init_structure.ADC_DataAlign = ADC_DataAlign_Right; //data converted will be shifted to right
	ADC_init_structure.ADC_Resolution = ADC_Resolution_12b; //Input voltage is converted into a 12bit number giving a maximum value of 4096
	ADC_init_structure.ADC_ContinuousConvMode = ENABLE; //the conversion is continuous, the input data is converted more than once
	ADC_init_structure.ADC_ExternalTrigConv = ADC_ExternalTrigConv_T1_CC1; // conversion is synchronous with TIM1 and CC1 (actually I'm not sure about this one :/)
	ADC_init_structure.ADC_ExternalTrigConvEdge = ADC_ExternalTrigConvEdge_None; //no trigger for conversion
	ADC_init_structure.ADC_NbrOfConversion = 1; //I think this one is clear :p
	ADC_init_structure.ADC_ScanConvMode = DISABLE; //The scan is configured in one channel
	ADC_Init(ADC1, &ADC_init_structure); //Initialize ADC with the previous configuration
	//Enable ADC conversion
	ADC_Cmd(ADC1, ENABLE);
	//Select the channel to be read from
	ADC_RegularChannelConfig(ADC1, ADC_Channel_10, 1,
			ADC_SampleTime_144Cycles );
}

int adc_convert()
{
	ADC_SoftwareStartConv(ADC1 ); //Start the conversion
	while (!ADC_GetFlagStatus(ADC1, ADC_FLAG_EOC ))
		; //Processing the conversion
	return ADC_GetConversionValue(ADC1 ); //Return the converted data
}

void delayLoop()
{
	uint32_t delayCount = 1000000; // volatile, um "Wegoptimieren" zu vermeinden
								   //(http://en.wikipedia.org/wiki/Volatile_variable)
	while (delayCount > 0)
	{
		delayCount--;
	}
}



int main(void)
{

	  SystemInit(); // Quarz Einstellungen aktivieren -> CPU 168MHz

	  adc_configure(); //Start configuration
	  USBD_Init(&USB_OTG_dev,USB_OTG_FS_CORE_ID,&USR_desc,&USBD_CDC_cb,&USR_cb);

	  STM32F4_Discovery_LEDInit(LED6); //Blue

	  // init vom DAC im DMA-Mode (DAC-1)
	  UB_DAC_DMA_Init(SINGLE_DAC1_DMA);

	  //DAC_WAVE4_RECHTECK
	  // an DAC1 (PA4) ein Rechteck-Signal ausgeben
	  UB_DAC_DMA_SetWaveform1(DAC_WAVE4_RECHTECK);

	  //Vorgebene Werte für Teiler und Periode um den Frequenz vorzugeben
	  int prescale_ary[]={8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,4,4,4,4,4,2,2,2,2,2,2,2,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1};
	  int period_ary[] = {2625,146,75,50,38,31,25,22,19,17,15,14,13,12,11,10,19,18,17,16,15,29,28,27,26,25,24,23,44,43,41,40,39,37,36,35,34,33,32,31,30,29,28,27,26,25,24,23,22,21,20,19,18,17,16,15,14,13,12,11,10,9,8,7,6};
	  int convvalue_ary[72];
	  int i;
	  int prescale;
	  int period;
	  char str_output[290];
	  char buffer[10];
	  int ConvertedValue = 0; //Converted value read from ADC

	  while(1)
	  {

		  //Wir lesen von PC0
		  //Wir fahren mit dieser Schleife die Frequnezen ab
		  for(i = 1; i <= 72; i++)
		  {

				//Werte aus den Arrays lesen
				prescale = prescale_ary[i-1];
				period = period_ary[i-1];

				//Timer und damit Frequenz setzen
				UB_DAC_DMA_SetFrq1(prescale-1,period-1);

				//Wert der Frequenz auslesen
				convvalue_ary[i-1] = adc_convert(); //Read the ADC converted value
		  }

		   //Mach nen String draus
		   //sprintf(buffer, "%d", ConvertedValue);

		   //Schick ihn über USB
		   //strcpy(str_output, "start_");       // copies "one" into str_output

			  for(i = 1; i <= 72; i++)
			  {
				  sprintf(buffer, "%d", convvalue_ary[i-1]);
				  strcat(str_output, buffer);    //  attaches str_two to str_output
			  }

			  usb_cdc_printf(str_output);
			  //New Line
			  usb_cdc_printf("\r\n");

			  str_output[0] = '\0';

			  //strcat(str_output, "_end");

			  //usb_cdc_printf(str_output);
			  //sprintf(buffer, "%d", convvalue_ary[1]);

			  STM32F4_Discovery_LEDOn(LED6);

			  delayLoop();

			  STM32F4_Discovery_LEDOff(LED6);

			  delayLoop();
	  }
}

// an DAC2 (PA5) ein Rechteck-Signal ausgeben
//UB_DAC_DMA_SetWaveform2(DAC_WAVE_OFF);


// an DAC2 (PA5) ein Dreieck-Signal ausgeben
// UB_DAC_DMA_SetWaveform2(DAC_WAVE3_DREIECK);

// Frq vom Sinus-Signal auf 1 KHz stellen
// !!!!!!!!!!!!!!!! 1 KHz SINUS
//OLD
// Das Sinus-Signal ist 32 Werte lang -> GEÄNADERT AUF 16 WERTE!
// -> Das hier ist aktuell f=84MHz/300/8750/16 = 1 Hz
// -> NICHT AKTUELLf=84MHz/300/8750/32 = 1 Hz
//OLD
//UB_DAC_DMA_SetFrq1(83,30);
//UB_DAC_DMA_SetFrq1(83,2);


// Frq vom Rechteck-Signal auf 1 KHz stellen
// Das Rechteck-Signal ist 1 Wert lang
// f=84MHz/84/1000 = 1 kHz
//UB_DAC_DMA_SetFrq2(83,999);


// Frq vom Dreieck-Signal auf 10 Hz stellen
// Das Dreieck-Signal ist 32 Werte lang
// f=84MHz/30/8750/32 = 10 Hz
//UB_DAC_DMA_SetFrq2(29,8749);
