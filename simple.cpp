#include <cstdio>
#include <stdlib.h>

int main()
{
  const int sz = 128*1024;
  char s[sz];

  fprintf(stdout, "test,test12,breakout\n");
  fflush(stdout);
  
  fgets(s, sz, stdin);
  fprintf(stdout, "0,0,0,1\n");
  fflush(stdout);
  
  for(int i = 0; i < 1000*1000; ++i) {
    fgets(s, sz, stdin);
    fprintf(stdout, "%d,18\n", rand() % 19);
    fflush(stdout);
  }
  return 0;
}
