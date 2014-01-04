#include <iostream>
#include <math.h>
#include <cstdio>
using namespace std;

struct cache_content{
//	bool v;
	unsigned int tag;
	unsigned int time;
	//unsigned int data[16];
};

int log2 (int n) {
	int a = 0;
	while (n > 1) {
		a++;
		n = n >> 1;
	}
	return a;
}

const int K = 1024;

void simulate (int way, int cache_size, int block_size) {
	unsigned int tag, index, x;

	int offset_bit = log2(block_size);
	int index_bit = log2(cache_size / block_size / way);
	int line = cache_size >> (offset_bit);

	int AccessNum = 0;
	int MissNum = 0;
	int TimeNow = 0;

	cache_content * cache = new cache_content[line];
	cout << "way: " << way << endl;
	cout << "cache_size: " << cache_size / K << "K" << endl;
	cout << "block_size: " << block_size << "B" << endl;
	//cout << "cache line:" << line << endl;

	for (int j = 0; j < line; j++) {
//		cache[j].v = false;
		cache[j].tag = 0;
		cache[j].time = 0;
	}
	
	FILE * fp = fopen("RADIX.txt", "r");					//read file
	
	while(fscanf(fp, "%x", &x) != EOF) {
		AccessNum++;
		TimeNow++;
	//	cout << hex << x << " ";
		index = (x >> offset_bit) & ((line / way) - 1);
		tag = x >> (index_bit + offset_bit);
	
		bool h = false;

		for (int i = 0; i < way; i++) {
			if(cache[index*way+i].time && cache[index*way+i].tag == tag) {
				cache[index*way+i].time = TimeNow; 			//hit
				h = true;
				break;
			} 						
		}
		if (!h) {
			MissNum++;
			int minimum = 99999999;
			int record = 0;
			for (int i = 0; i < way; i++) {
				if (cache[index*way+i].time == 0) {
					record = i;
					break;
				} else if (cache[index*way+i].time< minimum) {
					minimum = cache[index*way+i].time;
					record = i;
				}
			}

			cache[index*way+record].time = TimeNow;
			cache[index*way+record].tag = tag;
		}

	}
	fclose(fp);

	delete [] cache;
	cout << "MissNum: " << MissNum << endl;
	cout << "AccessNum: " << AccessNum << endl;
	cout << "miss rate: " << (MissNum / (double)AccessNum) << endl << endl;;
}
	
int main() {
	// Let us simulate 4KB cache with 16B blocks
	simulate(1, 1*K, 4);
	simulate(1, 2*K, 4);
	simulate(1, 4*K, 4);
	simulate(1, 8*K, 4);
	simulate(1, 16*K, 4);
	simulate(1, 32*K, 4);

	simulate(2, 1*K, 4);
	simulate(2, 2*K, 4);
	simulate(2, 4*K, 4);
	simulate(2, 8*K, 4);
	simulate(2, 16*K, 4);
	simulate(2, 32*K, 4);

	simulate(4, 1*K, 4);
	simulate(4, 2*K, 4);
	simulate(4, 4*K, 4);
	simulate(4, 8*K, 4);
	simulate(4, 16*K, 4);
	simulate(4, 32*K, 4);

	simulate(8, 1*K, 4);
	simulate(8, 2*K, 4);
	simulate(8, 4*K, 4);
	simulate(8, 8*K, 4);
	simulate(8, 16*K, 4);
	simulate(8, 32*K, 4);

	return 0;
}
