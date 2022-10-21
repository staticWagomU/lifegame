#include <stdio.h>
#include <time.h>

int cells[32][32];
int nextGen[32][32];

void mysleep(int s, int n);

int main(int argc, char *argv[]) {
  printf("\x1B[2J\x1B[H");
  for (int i = 0; i < 10; i++)
    cells[16][8 + i] = 1;

  for (;;) {
    // print
    for (int y = 0; y < 32; y++) {
      for (int x = 0; x < 32; x++) {
        printf("%s ", cells[y][x] ? "o" : "-");
      }
      printf("\n");
    }
    // to next genaration
    int count, current;
    for (int y = 0; y < 32; y++) {
      for (int x = 0; x < 32; x++) {
        count = 0;
        current = cells[y][x];

        // top
        if (y > 0)
          count += cells[y - 1][x];
        // top left
        if (y > 0 && x > 0)
          count += cells[y - 1][x - 1];
        // left
        if (x > 0)
          count += cells[y][x - 1];
        // bottom left
        if (y < 32 && x > 0)
          count += cells[y + 1][x - 1];
        // bottom
        if (y < 32)
          count += cells[y + 1][x];
        // bottom right
        if (y < 32 && x < 32)
          count += cells[y + 1][x + 1];
        // right
        if (x < 32)
          count += cells[y][x + 1];
        // top right
        if (y > 0 && x > 0)
          count += cells[y - 1][x + 1];

        if (current) {
          if (count == 2 || count == 3) {
            nextGen[y][x] = 1;
          } else {
            nextGen[y][x] = 0;
          }
        } else {
          if (count == 3) {
            nextGen[y][x] = 1;
          } else {
            nextGen[y][x] = 0;
          }
        }
      }
    }

    // update
    for (int y = 0; y < 32; y++) {
      for (int x = 0; x < 32; x++)
        cells[y][x] = nextGen[y][x];
    }
    mysleep(0, 400000000);
    printf("\x1B[2J\x1B[H");
  }
  return 0;
}

void mysleep(int s, int n) {
  struct timespec ts;
  ts.tv_nsec = n;
  ts.tv_sec = s;
  nanosleep(&ts, NULL);
}
