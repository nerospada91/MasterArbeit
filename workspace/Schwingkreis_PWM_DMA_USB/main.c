#include "stm32f4xx.h"
#include "stm32f4_discovery.h"
#include "stdio.h"
#include "string.h"

#include "stm32_ub_dac_dma.h"
#include "stm32f4xx_usart.h"
#include "stm32f4xx_rcc.h"
#include "stm32f4xx_gpio.h"
#include "stm32f4xx_conf.h"
#include "main.h"
#include "misc.h"

#define AD9850_CLK GPIO_Pin_7
#define AD9850_FQUP GPIO_Pin_8
#define AD9850_DATA GPIO_Pin_9
#define AD9850_RESET GPIO_Pin_10

//Welcher Frequenzbereiche
// 1 = 1-250  kHz in 200 Schritten
// 2 = 1-3500 kHz in 200 Schritten

//Wie oft soll jeder einzelne Wert gemessen werden?
int n_measures = 100;

// AD9850 CLK  PE7
// AD9850 FQ   PE8
// AD9850 Data PE9
// AD9850 RST  PE10

// BT-Modul TX PB10
// BT-Modul RX PB11

// Schwingkreis Anschluss Weiss   PC4
// Schwingkreis Anschluss Schwarz Ground
// Schwingkreis Anschluss Rot     AD9850-SinA
// Schwingkreis Anschluss Gelb    Objekt

/* --------------------------- Bluetooth Function -----------------*/
void Bluetooth_Init(void) {

	/* --------------------------- System Clocks Configuration -----------------*/
	/* USART3 clock enable */
	/* GPIOB clock enable */
	RCC_APB1PeriphClockCmd(RCC_APB1Periph_USART3, ENABLE);
	RCC_AHB1PeriphClockCmd(RCC_AHB1Periph_GPIOB, ENABLE);

	/*-------------------------- GPIO Configuration ----------------------------*/
	GPIO_InitTypeDef GPIO_InitStructure;
	GPIO_InitStructure.GPIO_Pin = GPIO_Pin_10 | GPIO_Pin_11;
	GPIO_InitStructure.GPIO_Mode = GPIO_Mode_AF;
	GPIO_InitStructure.GPIO_OType = GPIO_OType_PP;
	GPIO_InitStructure.GPIO_PuPd = GPIO_PuPd_NOPULL;
	GPIO_InitStructure.GPIO_Speed = GPIO_Speed_50MHz;
	GPIO_Init(GPIOB, &GPIO_InitStructure);

	/* Connect USART pins to AF */
	GPIO_PinAFConfig(GPIOB, GPIO_PinSource10, GPIO_AF_USART3);
	GPIO_PinAFConfig(GPIOB, GPIO_PinSource11, GPIO_AF_USART3);

	/* USARTx configuration ------------------------------------------------------*/
	/* USARTx configured as follow:
	 - BaudRate = 1382400 baud
	 - Word Length = 8 Bits
	 - Two Stop Bit
	 - Odd parity
	 - Hardware flow control disabled (RTS and CTS signals)
	 - Receive and transmit enabled
	 */
	USART_InitTypeDef USART_InitStructure;
	USART_InitStructure.USART_BaudRate = 1382400;
	USART_InitStructure.USART_WordLength = USART_WordLength_8b;
	USART_InitStructure.USART_StopBits = USART_StopBits_1;
	USART_InitStructure.USART_Parity = USART_Parity_No;
	USART_InitStructure.USART_HardwareFlowControl =	USART_HardwareFlowControl_None;
	USART_InitStructure.USART_Mode = USART_Mode_Rx | USART_Mode_Tx;
	USART_Init(USART3, &USART_InitStructure);

	USART_Cmd(USART3, ENABLE);
	USART_ITConfig(USART3, USART_IT_RXNE, ENABLE);
}

/* --------------------------- ADC Function -----------------*/
// 32 Mhz 12 Bit 4096 Werte 2,5 mV
void Input_ADC_Init() {

	/* --------------------------- System Clocks Configuration -----------------*/
	/* ADC1 clock enable */
	/* GPIOC clock enable */
	RCC_APB2PeriphClockCmd(RCC_APB2Periph_ADC1, ENABLE); //ADC1 connected APB2 peripheral bus will use clock source
	RCC_AHB1PeriphClockCmd(RCC_AHB1Periph_GPIOC, ENABLE);

	/*-------------------------- GPIO Configuration ----------------------------*/
	GPIO_InitTypeDef GPIO_initStructre; //Structure for analog input pin
	GPIO_initStructre.GPIO_Pin = GPIO_Pin_4; //The channel 14 is connected to PC4
	GPIO_initStructre.GPIO_Mode = GPIO_Mode_AN; //The PC4 pin is configured in analog mode
	GPIO_initStructre.GPIO_PuPd = GPIO_PuPd_NOPULL; //We don't need any pull up or pull down
	GPIO_Init(GPIOC, &GPIO_initStructre); //Affecting the port with the initialization structure configuration

	/* --------------------------- ADC Configuration -----------------*/
	ADC_CommonInitTypeDef ADC_CommonInitStructure;
	ADC_CommonInitStructure.ADC_Mode = ADC_Mode_Independent;
	ADC_CommonInitStructure.ADC_Prescaler = ADC_Prescaler_Div4;
	ADC_CommonInitStructure.ADC_DMAAccessMode = ADC_DMAAccessMode_Disabled;
	ADC_CommonInitStructure.ADC_TwoSamplingDelay = ADC_TwoSamplingDelay_5Cycles;
	ADC_CommonInit(&ADC_CommonInitStructure);

	ADC_InitTypeDef ADC_InitStructure;
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

	ADC_Cmd(ADC1, ENABLE);
	ADC_SoftwareStartConv(ADC1); //Start ADC1 Conversion

}

/* --------------------------- Simple Delay Loop  -----------------*/
void Delay_Loop(uint32_t delay) {
	uint32_t delayCount = delay;
	while (delayCount > 0) {
		delayCount--;
	}
}

/* --------------------------- Signal Generator Clock SubFunction -----------------*/
void AD9850_ClockCLK() {
	//Signalflanke CLK generieren
	GPIO_SetBits(GPIOE, AD9850_CLK);
	//Delay_Loop(10000);
	GPIO_ResetBits(GPIOE, AD9850_CLK);
}

/* --------------------------- Signal Generator FQUP SubFunction -----------------*/
void AD9850_ClockFQUP() {
	//Signalflanke FQ generieren
	GPIO_SetBits(GPIOE, AD9850_FQUP);
	//Delay_Loop(10000);
	GPIO_ResetBits(GPIOE, AD9850_FQUP);
}

/* --------------------------- Signal Generator Write Word SubFunction -----------------*/
void AD9850_Write(uint8_t word) {
	//Byte/Bit schreiben auf PE9
	int i;
	for(i=0; i<8; i++) {
		GPIO_WriteBit(GPIOE, AD9850_DATA, (word >> i) & 0x01);
		AD9850_ClockCLK();
	}
}

/* --------------------------- Signal Generator Init Function -----------------*/
void AD9850_Init() {

	/* --------------------------- System Clocks Configuration -----------------*/
	/* GPIOE clock enable */
	RCC_AHB1PeriphClockCmd(RCC_AHB1Periph_GPIOE, ENABLE);

	/*-------------------------- GPIO Configuration ----------------------------*/
	GPIO_InitTypeDef GPIO_InitStructure;
	GPIO_InitStructure.GPIO_Pin = GPIO_Pin_7 | GPIO_Pin_8 | GPIO_Pin_9 | GPIO_Pin_10;
	GPIO_InitStructure.GPIO_Mode = GPIO_Mode_OUT;
	GPIO_InitStructure.GPIO_Speed = GPIO_Speed_50MHz;
	GPIO_InitStructure.GPIO_OType = GPIO_OType_PP;
	GPIO_InitStructure.GPIO_PuPd = GPIO_PuPd_NOPULL;
	GPIO_Init(GPIOE, &GPIO_InitStructure);

	GPIO_ResetBits(GPIOE, AD9850_CLK | AD9850_FQUP | AD9850_RESET | AD9850_DATA);

	/* --------------------------- Signal Generator RESET - once called during Init -----------------*/
	int i;
	GPIO_ResetBits(GPIOE, AD9850_CLK | AD9850_FQUP);
	GPIO_SetBits(GPIOE, AD9850_RESET);

	for(i=0; i<5; i++) {
		AD9850_ClockCLK();
	}

	GPIO_ResetBits(GPIOE, AD9850_RESET);

	for(i=0; i<2; i++) {
		AD9850_ClockCLK();
	}

	AD9850_ClockFQUP();
}

/* --------------------------- Signal Generator SetFrequency Function -----------------*/
void AD9850_SetFrequency(double freq) {
	double x = 34.35973836;

	freq *= x;

	uint32_t y = (uint32_t)freq;

	AD9850_ClockFQUP();
	int i;
	for(i=0;i<4;i++) {
		uint8_t w = (uint8_t) ((y >> i*8) & 0xff);
		AD9850_Write(w);
	}
	AD9850_Write(0x00);
	AD9850_ClockFQUP();
}

/* --------------------------- Bluetooth Send SubFunction -----------------*/
void Send_String_USART(const char *str) {
	while (*str) {
		while (USART_GetFlagStatus(USART3, USART_FLAG_TXE) == RESET);
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
	Input_ADC_Init();

	//Init LED (Blue)
	STM32F4_Discovery_LEDInit(LED6);

	//Init and Reset AD9850
	AD9850_Init();

	//Init some Variables for while loop ADC/DAC
	int i, k, meas_raw, meas_fin;
	char str_output[10], buffer[10];
	double meas_comb;

	//Welcher Frequenzbereich soll genutzt werden? {
	//Frequenzen - 1-250kHz - 200 Schritte

	long int freq_ary[] = { 1000, 2000, 3000, 4000, 5000, 6000, 7000, 8000, 9000,
			10000, 11000, 12000, 13000, 14000, 15000, 16000, 17000, 18000,
			19000, 20000, 21000, 22000, 23000, 24000, 25000, 26000, 27000,
			28000, 29000, 30000, 31000, 32000, 33000, 34000, 35000, 36000,
			37000, 38000, 39000, 40000, 41000, 42000, 43000, 44000, 45000,
			46000, 47000, 48000, 49000, 50000, 51000, 52000, 53000, 54000,
			55000, 56000, 57000, 58000, 59000, 60000, 61000, 62000, 63000,
			64000, 65000, 66000, 67000, 68000, 69000, 70000, 71000, 72000,
			73000, 74000, 75000, 76000, 77000, 78000, 79000, 80000, 81000,
			82000, 83000, 84000, 85000, 86000, 87000, 88000, 89000, 90000,
			91000, 92000, 93000, 94000, 95000, 96000, 97000, 98000, 99000,
			100000, 101000, 102000, 103000, 104000, 105000, 106000, 107000,
			108000, 109000, 110000, 111000, 112000, 113000, 114000, 115000,
			116000, 117000, 118000, 119000, 120000, 121000, 122000, 123000,
			124000, 125000, 126000, 127000, 128000, 129000, 130000, 131000,
			132000, 133000, 134000, 135000, 136000, 137000, 138000, 139000,
			140000, 141000, 142000, 143000, 144000, 145000, 146000, 147000,
			148000, 149000, 150000, 151000, 152000, 153000, 154000, 155000,
			156000, 157000, 158000, 159000, 160000, 161000, 162000, 163000,
			164000, 165000, 166000, 167000, 168000, 169000, 170000, 171000,
			172000, 173000, 174000, 175000, 176000, 177000, 178000, 179000,
			180000, 181000, 182000, 183000, 184000, 185000, 186000, 187000,
			188000, 189000, 190000, 191000, 192000, 193000, 194000, 195000,
			196000, 197000, 198000, 199000, 200000, 201000, 202000, 203000,
			204000, 205000, 206000, 207000, 208000, 209000, 210000, 211000,
			212000, 213000, 214000, 215000, 216000, 217000, 218000, 219000,
			220000, 221000, 222000, 223000, 224000, 225000, 226000, 227000,
			228000, 229000, 230000, 231000, 232000, 233000, 234000, 235000,
			236000, 237000, 238000, 239000, 240000, 241000, 242000, 243000,
			244000, 245000, 246000, 247000, 248000, 249000, 250000 };


	//Frequenzen - 1-3500kHz - 200 Schritte
	/*
	long int freq_ary[] = { 1000, 15053, 29105, 43157, 57209, 71261, 85313, 99365,
			113417, 127469, 141521, 155573, 169625, 183677, 197729, 211781,
			225833, 239885, 253937, 267989, 282041, 296093, 310145, 324197,
			338249, 352301, 366353, 380405, 394457, 408509, 422561, 436613,
			450665, 464717, 478769, 492821, 506873, 520925, 534977, 549029,
			563081, 577133, 591185, 605237, 619289, 633341, 647393, 661445,
			675497, 689549, 703601, 717653, 731705, 745757, 759809, 773861,
			787913, 801965, 816017, 830069, 844121, 858173, 872225, 886277,
			900329, 914381, 928433, 942485, 956537, 970589, 984641, 998693,
			1012745, 1026797, 1040849, 1054901, 1068953, 1083005, 1097057,
			1111109, 1125161, 1139213, 1153265, 1167317, 1181369, 1195421,
			1209473, 1223525, 1237577, 1251629, 1265681, 1279733, 1293785,
			1307837, 1321889, 1335941, 1349993, 1364045, 1378097, 1392149,
			1406201, 1420253, 1434305, 1448357, 1462409, 1476461, 1490513,
			1504565, 1518617, 1532669, 1546721, 1560773, 1574825, 1588877,
			1602929, 1616981, 1631033, 1645085, 1659137, 1673189, 1687241,
			1701293, 1715345, 1729397, 1743449, 1757501, 1771553, 1785605,
			1799657, 1813709, 1827761, 1841813, 1855865, 1869917, 1883969,
			1898021, 1912073, 1926125, 1940177, 1954229, 1968281, 1982333,
			1996385, 2010437, 2024489, 2038541, 2052593, 2066645, 2080697,
			2094749, 2108801, 2122853, 2136905, 2150957, 2165009, 2179061,
			2193113, 2207165, 2221217, 2235269, 2249321, 2263373, 2277425,
			2291477, 2305529, 2319581, 2333633, 2347685, 2361737, 2375789,
			2389841, 2403893, 2417945, 2431997, 2446049, 2460101, 2474153,
			2488205, 2502257, 2516309, 2530361, 2544413, 2558465, 2572517,
			2586569, 2600621, 2614673, 2628725, 2642777, 2656829, 2670881,
			2684933, 2698985, 2713037, 2727089, 2741141, 2755193, 2769245,
			2783297, 2797349, 2811401, 2825453, 2839505, 2853557, 2867609,
			2881661, 2895713, 2909765, 2923817, 2937869, 2951921, 2965973,
			2980025, 2994077, 3008129, 3022181, 3036233, 3050285, 3064337,
			3078389, 3092441, 3106493, 3120545, 3134597, 3148649, 3162701,
			3176753, 3190805, 3204857, 3218909, 3232961, 3247013, 3261065,
			3275117, 3289169, 3303221, 3317273, 3331325, 3345377, 3359429,
			3373481, 3387533, 3401585, 3415637, 3429689, 3443741, 3457793,
			3471845, 3485897, 3500000 };
	 */

	//While don't exit
	while (1) {

		STM32F4_Discovery_LEDOn(LED6);
		//Delay_Loop(1000000);

		//Wir fahren mit dieser Schleife die Frequnezen ab
		for (i = 1; i <= 200; i++) {

			//Frequenz setzen
			AD9850_SetFrequency(freq_ary[i-1]);

			//Mehrfaches Messen um validität der Ergebnisse zu erhöhen
			meas_comb = 0;
			for(k = 1; k <= n_measures; k++)
			{
				meas_raw = ADC_GetConversionValue(ADC1);
				meas_comb = meas_comb + meas_raw;
			}
			meas_comb = meas_comb/n_measures;
			meas_fin = (int)meas_comb;

			//Konvertieren und Senden der gemessenen Ergebnisse
			if (meas_fin < 1000)
			{
				if (meas_fin > 99)
				{
					sprintf(buffer, "%d", (int)meas_fin);
					strcat(str_output, buffer);
					strcat(str_output, "X");
					Send_String_USART(str_output);
				}
				else
				{
					if (meas_fin > 9)
					{
						sprintf(buffer, "%d", (int)meas_fin);
						strcat(str_output, buffer);
						strcat(str_output, "XX");
						Send_String_USART(str_output);
					}
					else
					{
							sprintf(buffer, "%d", (int)meas_fin);
							strcat(str_output, buffer);
							strcat(str_output, "XXX");
							Send_String_USART(str_output);
					}

				}
			}
			else
			{
				sprintf(str_output, "%d", (int)meas_fin);
				Send_String_USART(str_output);
			}

			buffer[0] = '\0';
			str_output[0] = '\0';
		}
		//Sendevorgang abgeschlossen -> END senden
		Send_String_USART("END\r\n");

		STM32F4_Discovery_LEDOff(LED6);
		Delay_Loop(800000);
	}
}

