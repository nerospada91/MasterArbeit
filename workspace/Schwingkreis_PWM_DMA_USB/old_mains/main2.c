/**
********************************************************************************

********************************************************************************
*/

/* Includes */
#include <stdio.h>
#include "stm32f4_discovery.h"

#include "usbd_cdc_vcp.h"

/* Private macro */
/* Private variables */
uint32_t button_sts;
__ALIGN_BEGIN USB_OTG_CORE_HANDLE  USB_OTG_dev __ALIGN_END;
uint32_t i = 0;
/* Private function prototypes */
/* Private functions */
int ConvertedValue = 0; //Converted value read from ADC
/**
**===========================================================================
**  Main
**===========================================================================
*/
void adc_configure() {
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

int adc_convert() {
	ADC_SoftwareStartConv(ADC1 ); //Start the conversion
	while (!ADC_GetFlagStatus(ADC1, ADC_FLAG_EOC ))
		; //Processing the conversion
	return ADC_GetConversionValue(ADC1 ); //Return the converted data
}



void delayLoop() {
	uint32_t delayCount = 1000000; // volatile, um "Wegoptimieren" zu vermeinden
								   //(http://en.wikipedia.org/wiki/Volatile_variable)
	while (delayCount > 0) {
		delayCount--;
	}
}

int main(void)
{
	adc_configure(); //Start configuration
	SystemInit();

	/* Inicio dos I/Os pelas funções da biblioteca da ST*/
	STM32F4_Discovery_LEDInit(LED3); //Orange
	STM32F4_Discovery_LEDInit(LED4); //Green
	STM32F4_Discovery_LEDInit(LED5); //Red
	STM32F4_Discovery_LEDInit(LED6); //Blue

	STM32F4_Discovery_PBInit(BUTTON_USER, BUTTON_MODE_GPIO);

	USBD_Init(&USB_OTG_dev,USB_OTG_FS_CORE_ID,&USR_desc,&USBD_CDC_cb,&USR_cb);

	char buffer[50];

	while (1){



		ConvertedValue = adc_convert(); //Read the ADC converted value


		sprintf(buffer, "%d", ConvertedValue);

		usb_cdc_printf(buffer);
		usb_cdc_printf("\n");

		STM32F4_Discovery_LEDOn(LED3);
		STM32F4_Discovery_LEDOn(LED4);
		STM32F4_Discovery_LEDOff(LED5);
		STM32F4_Discovery_LEDOff(LED6);

		delayLoop();

		STM32F4_Discovery_LEDOff(LED3);
		STM32F4_Discovery_LEDOff(LED4);
		STM32F4_Discovery_LEDOn(LED5);
		STM32F4_Discovery_LEDOn(LED6);

		delayLoop();

/*
		if(usb_cdc_kbhit()){
			char c, buffer_out[15];
			c = usb_cdc_getc();
			usb_cdc_printf("Test");
			switch(c){
				case '3':
					STM32F4_Discovery_LEDToggle(LED3);
					sprintf(buffer_out,"LED%c = %u\r\n",c,GPIO_ReadInputDataBit(GPIOD,LED3_PIN));
					usb_cdc_printf(buffer_out);
					break;
				case '4':
					STM32F4_Discovery_LEDToggle(LED4);
					sprintf(buffer_out,"LED%c = %u\r\n",c,GPIO_ReadInputDataBit(GPIOD,LED4_PIN));
					usb_cdc_printf(buffer_out);
					break;
				case '5':
					STM32F4_Discovery_LEDToggle(LED5);
					sprintf(buffer_out,"LED%c = %u\r\n",c,GPIO_ReadInputDataBit(GPIOD,LED5_PIN));
					usb_cdc_printf(buffer_out);
					break;
				case '6':
					STM32F4_Discovery_LEDToggle(LED6);
					sprintf(buffer_out,"LED%c = %u\r\n",c,GPIO_ReadInputDataBit(GPIOD,LED6_PIN));
					usb_cdc_printf(buffer_out);
					break;
			}
		}
*/

		/*
		button_sts = STM32F4_Discovery_PBGetState(BUTTON_USER);

		if(button_sts){
			STM32F4_Discovery_LEDOff(LED3);
			STM32F4_Discovery_LEDOff(LED5);
			STM32F4_Discovery_LEDOff(LED3);
			STM32F4_Discovery_LEDOff(LED5);
		}
		*/
	}
}
