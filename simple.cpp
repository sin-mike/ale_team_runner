#include <cstdio>

int main()
{
  const int sz = 128*1024;
  char s[sz];
  
  fgets(s, sz, stdin);
  fprintf(stdout, "0,0,0,1\n");
  fflush(stdout);
  
  for(int i = 0; i < 1000*1000; ++i) {
    fgets(s, sz, stdin);
    fprintf(stdout, "12,18\n");
    fflush(stdout);
  }
  return 0;
}
