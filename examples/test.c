#include <winsock2.h>
#include <stdio.h>


// need link with Ws2_32.lib
#pragma comment(lib, "Ws2_32.lib")


int main() {
  printf("ip: %d", inet_addr("127.0.0.1"));
}