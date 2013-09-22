#include "stm32f4xx.h"
#include "stm32f4xx_conf.h"
#include "stm32f4xx_usart.h"
#include "stm32f4xx_rcc.h"
#include "stm32f4xx_gpio.h"
#include "stm32f4_discovery.h"
#include "stm32_ub_dac_dma.h"
#include "main.h"
#include "stdio.h"
#include "string.h"
#include "misc.h"

/* --------------------------- Bluetooth Function -----------------*/
void Bluetooth_Init(void) {

	/* --------------------------- System Clocks Configuration -----------------*/
	/* USART3 clock enable */
	RCC_APB1PeriphClockCmd(RCC_APB1Periph_USART3, ENABLE);

	/* GPIOB clock enable */
	RCC_AHB1PeriphClockCmd(RCC_AHB1Periph_GPIOB, ENABLE);

	GPIO_InitTypeDef GPIO_InitStructure;

	/*-------------------------- GPIO Configuration ----------------------------*/
	GPIO_InitStructure.GPIO_Pin = GPIO_Pin_10 | GPIO_Pin_11;
	GPIO_InitStructure.GPIO_Mode = GPIO_Mode_AF;
	GPIO_InitStructure.GPIO_OType = GPIO_OType_PP;
	GPIO_InitStructure.GPIO_PuPd = GPIO_PuPd_NOPULL;
	GPIO_InitStructure.GPIO_Speed = GPIO_Speed_50MHz;
	GPIO_Init(GPIOB, &GPIO_InitStructure);

	/* Connect USART pins to AF */
	GPIO_PinAFConfig(GPIOB, GPIO_PinSource10, GPIO_AF_USART3);
	GPIO_PinAFConfig(GPIOB, GPIO_PinSource11, GPIO_AF_USART3);

	USART_InitTypeDef USART_InitStructure;

	/* USARTx configuration ------------------------------------------------------*/
	/* USARTx configured as follow:
	 - BaudRate = 9600 baud
	 - Word Length = 8 Bits
	 - Two Stop Bit
	 - Odd parity
	 - Hardware flow control disabled (RTS and CTS signals)
	 - Receive and transmit enabled
	 */
	USART_InitStructure.USART_BaudRate = 9600;
	USART_InitStructure.USART_WordLength = USART_WordLength_8b;
	USART_InitStructure.USART_StopBits = USART_StopBits_1;
	USART_InitStructure.USART_Parity = USART_Parity_No;
	USART_InitStructure.USART_HardwareFlowControl =
			USART_HardwareFlowControl_None;

	USART_InitStructure.USART_Mode = USART_Mode_Rx | USART_Mode_Tx;

	USART_Init(USART3, &USART_InitStructure);

	USART_Cmd(USART3, ENABLE);
	USART_ITConfig(USART3, USART_IT_RXNE, ENABLE);
}

/* --------------------------- ADC Function -----------------*/
// 32 Mhz 12 Bit 4096 Werte 2,5 mV
void Input_Init() {

	/* --------------------------- System Clocks Configuration -----------------*/
	RCC_APB2PeriphClockCmd(RCC_APB2Periph_ADC1, ENABLE); //The ADC1 is connected the APB2 peripheral bus thus we will use its clock source
	RCC_AHB1PeriphClockCmd(RCC_AHB1Periph_GPIOC, ENABLE); //Clock for the ADC port PORT Group C

	/* --------------------------- Analog Pin Conf -----------------*/
	GPIO_InitTypeDef GPIO_initStructre; //Structure for analog input pin

	GPIO_initStructre.GPIO_Pin = GPIO_Pin_4; //The channel 14 is connected to PC4
	GPIO_initStructre.GPIO_Mode = GPIO_Mode_AN; //The PC4 pin is configured in analog mode
	GPIO_initStructre.GPIO_PuPd = GPIO_PuPd_NOPULL; //We don't need any pull up or pull down
	GPIO_Init(GPIOC, &GPIO_initStructre); //Affecting the port with the initialization structure configuration

	/* --------------------------- ADC Configuration -----------------*/
	ADC_InitTypeDef ADC_InitStructure;
	ADC_CommonInitTypeDef ADC_CommonInitStructure;

	ADC_CommonInitStructure.ADC_Mode = ADC_Mode_Independent;
	ADC_CommonInitStructure.ADC_Prescaler = ADC_Prescaler_Div4;
	ADC_CommonInitStructure.ADC_DMAAccessMode = ADC_DMAAccessMode_Disabled;
	ADC_CommonInitStructure.ADC_TwoSamplingDelay = ADC_TwoSamplingDelay_5Cycles;
	ADC_CommonInit(&ADC_CommonInitStructure);

	ADC_InitStructure.ADC_Resolution = ADC_Resolution_12b;
	ADC_InitStructure.ADC_ScanConvMode = DISABLE; // 1 Channel
	ADC_InitStructure.ADC_ContinuousConvMode = ENABLE; // Conversions Triggered
	ADC_InitStructure.ADC_ExternalTrigConvEdge = ADC_ExternalTrigConvEdge_None;
	ADC_InitStructure.ADC_ExternalTrigConv = ADC_ExternalTrigConv_T1_CC1;
	ADC_InitStructure.ADC_DataAlign = ADC_DataAlign_Right;
	ADC_InitStructure.ADC_NbrOfConversion = 1;
	ADC_Init(ADC1, &ADC_InitStructure);

	// ADC1 regular channel 8 configuration: witch adc, witch channel, groupe sequencer, sample time
	//(ADC_TypeDef* ADCx, uint8_t ADC_Channel, uint8_t Rank, uint8_t ADC_SampleTime)
	ADC_RegularChannelConfig(ADC1, ADC_Channel_14, 1, ADC_SampleTime_480Cycles); // PC4
	//ADC_MultiModeDMARequestAfterLastTransferCmd(ENABLE);
	ADC_Cmd(ADC1, ENABLE);
	ADC_SoftwareStartConv(ADC1); //Start ADC1 Conversion

}

/* --------------------------- Simple Delay Loop LED-Flash -----------------*/
void delayLoop() {
	uint32_t delayCount = 1000000;
	while (delayCount > 0) {
		delayCount--;
	}
}

/* --------------------------- Bluetooth Send Function -----------------*/
void Send_String_USART(const char *str) {
	while (*str) {
		while (USART_GetFlagStatus(USART3, USART_FLAG_TXE) == RESET)
			;
		USART_SendData(USART3, *str++);
	}
}

/* --------------------------- Main Function -----------------*/
int main(void) {

	//Init the Sytem
	SystemInit();
	//Init Bluetooth
	Bluetooth_Init();
	//Init ADC
	Input_Init();
	//Init LED (Blue)
	STM32F4_Discovery_LEDInit(LED6);

	//DAC_WAVE4_RECHTECK
	//an DAC1 (PA4) ein Rechteck-Signal ausgeben
	//Init vom DAC im DMA-Mode (DAC-1)
	UB_DAC_DMA_Init(SINGLE_DAC1_DMA);
	UB_DAC_DMA_SetWaveform1(DAC_WAVE4_RECHTECK);

	//Vorgebene Werte für Teiler und Periode um den Frequenz vorzugeben
	int period_ary[] = { 21000, 10500, 7000, 5250, 4200, 3500, 3000, 2625, 2333,
			2100, 1909, 1750, 1615, 1500, 1400, 1313, 1235, 1167, 1105, 1050,
			1000, 955, 913, 875, 840, 808, 778, 750, 724, 700, 677, 656, 636,
			618, 600, 583, 568, 553, 538, 525, 512, 500, 488, 477, 467, 457,
			447, 438, 429, 420, 412, 404, 396, 389, 382, 375, 368, 362, 356,
			350, 344, 339, 333, 328, 323, 318, 313, 309, 304, 300, 296, 292,
			288, 284, 280, 276, 273, 269, 266, 263, 259, 256, 253, 250, 247,
			244, 241, 239, 236, 233, 231, 228, 226, 223, 221, 219, 216, 214,
			212, 210, 208, 206, 204, 202, 200, 198, 196, 194, 193, 191, 189,
			188, 186, 184, 183, 181, 179, 178, 176, 175, 174, 172, 171, 169,
			168, 167, 165, 164, 163, 162, 160, 159, 158, 157, 156, 154, 153,
			152, 151, 150, 149, 148, 147, 146, 145, 144, 143, 142, 141, 140,
			139, 138, 137, 136, 135, 133, 131, 130, 128, 127, 125, 124, 122,
			121, 119, 118, 117, 115, 114, 113, 112, 111, 109, 108, 107, 106,
			105, 104, 103, 102, 101, 100, 99, 98, 97, 96, 95, 95, 94, 93, 92,
			91, 90, 89, 88, 88, 87, 86, 85, 84 };
	//Init some Variables for while loop ADC/DAC
	int i;
	int period;
	char str_output[10];
	char buffer[10];

	int k;
	int meas_raw = 0;
	long meas_comb = 0;
	int meas_fin = 0;

	while (1) {

		STM32F4_Discovery_LEDOn(LED6);

		//uint16_t Data = 1;
		//USART_SendData(USART3, Data); // Echo Char

		//Wir fahren mit dieser Schleife die Frequnezen ab
		for (i = 1; i <= 200; i++) {

			//Frequenz setzen
			//UB_DAC_DMA_SetFrq1(prescale-1,period-1);
			period = period_ary[i - 1];
			UB_DAC_DMA_SetFrq1(1 - 1, period - 1);

			meas_raw = 0;
			meas_comb = 0;
			meas_fin = 0;

			/*
			 for(k = 1; k <= 5000; k++)
			 {
			 meas_raw = ADC_GetConversionValue(ADC1);
			 meas_comb = meas_comb + meas_raw;
			 }
			 meas_comb = meas_comb/5000;
			 meas_fin = (int)meas_comb;
			 */

			//sprintf(buffer, "%d", ADC_GetConversionValue(ADC1));

			meas_fin = ADC_GetConversionValue(ADC1);

			if (meas_fin < 1000) {
				if (meas_fin > 99) {
					sprintf(buffer, "%d", (int) meas_fin);
					strcat(str_output, buffer);
					strcat(str_output, "X");
					Send_String_USART(str_output);
				} else {
					if (meas_fin > 9) {
						sprintf(buffer, "%d", (int) meas_fin);
						strcat(str_output, buffer);
						strcat(str_output, "XX");
						Send_String_USART(str_output);
					} else {
						sprintf(buffer, "%d", (int) meas_fin);
						strcat(str_output, buffer);
						strcat(str_output, "XXX");
						Send_String_USART(str_output);
					}

				}
			} else {
				sprintf(str_output, "%d", (int) meas_fin);
				Send_String_USART(str_output);

			}

			/*
			 sprintf(buffer, "%d", ADC_GetConversionValue(ADC1));
			 strcat(str_output, buffer);
			 strcat(str_output, ".");
			 Send_String_USART(str_output);
			 */

			buffer[0] = '\0';
			str_output[0] = '\0';
		}

		//Sendevorgang abgeschlossen
		Send_String_USART("END\r\n");

		STM32F4_Discovery_LEDOff(LED6);
		delayLoop();
	}
}

