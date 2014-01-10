#include <iostream>
#include <math.h>
#include <stdio.h>

using namespace std;

struct cache_content{
	bool v;
	unsigned int tag;
//	unsigned int	data[16];    
};
const int K = 1024;

int log2(int n) {
	int a = 0;
	while (n > 1) {
		n = n >> 1;
		a++;
	}
	return a;
}

void simulate(int cache_size, int block_size) {
	unsigned int tag, index, x;
	
	int offset_bit = (int) log2(block_size);
	int index_bit = (int) log2(cache_size/block_size);
	int line = cache_size >> (offset_bit);

	/////////
	double AccessNum = 0;
	int MissNum = 0;
	

	cache_content *cache = new cache_content[line];
	//cout << "cache line:" << line << endl;

	for(int j = 0; j < line; j++) {
		cache[j].v = false;
	}
	
	FILE * fp = fopen("ICACHE.txt", "r");					//read file
	
	while(fscanf(fp, "%x", &x) != EOF) {
		AccessNum++;
	//	cout << hex << x << " ";
		index = (x >> offset_bit) & (line-1);
		tag = x >> (index_bit+offset_bit);
		if(cache[index].v && cache[index].tag == tag) {
			cache[index].v = true; 			//hit
		} else {						
			cache[index].v = true;			//miss
			cache[index].tag = tag;
			MissNum++;
		}
	}
	fclose(fp);

	delete [] cache;
	cout << "block size / cache size:" << block_size << " / " << cache_size << endl;
	cout << "Miss Rate:" << MissNum / AccessNum << endl << endl;
}
	
int main(){
	// Let us simulate 4KB cache with 16B blocks

	simulate(64, 4);
	simulate(128, 4);
	simulate(256, 4);
	simulate(512, 4);

	simulate(64, 8);
	simulate(128, 8);
	simulate(256, 8);
	simulate(512, 8);
	
	simulate(64, 16);
	simulate(128, 16);
	simulate(256, 16);
	simulate(512, 16);
	
	simulate(64, 32);
	simulate(128, 32);
	simulate(256, 32);
	simulate(512, 32);
}
