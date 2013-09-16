/*			switch(c){
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
