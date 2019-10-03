extern void UART_PUT32(unsigned int);

struct input
{
  int c;
  char str[0];
};

__attribute__((section("dupajasia")))
void print_uart0(const char *s)
{
 while(*s != '\0'){
   UART_PUT32(*s);
//   *uart_addr = (unsigned int)(*s); /* Transmit char */
   s++; /* Next char */
 }
}

void c_entry(struct input* inp)
{
  print_uart0("marcin to gej\n");
  if(inp->c != 3)
    print_uart0(inp->str);
}
