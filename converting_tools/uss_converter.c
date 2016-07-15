#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include <inttypes.h>

#define pack754_32(f) (pack754((f), 32, 8))
#define pack754_64(f) (pack754((f), 64, 11))
#define unpack754_32(i) (unpack754((i), 32, 8))
#define unpack754_64(i) (unpack754((i), 64, 11))

char convert(char* n)
{
	char* fourBits = malloc(4);
	fourBits = n;
	
	if(strcmp(fourBits, "0000") == 0)
		return '0';			
	else if(strcmp(fourBits, "0001") == 0)
		return '1';			
	else if(strcmp(fourBits, "0010") == 0)
		return '2';			
	else if(strcmp(fourBits, "0011") == 0)
		return '3';			
	else if(strcmp(fourBits, "0100") == 0)
		return '4';			
	else if(strcmp(fourBits, "0101") == 0)
		return '5';			
	else if(strcmp(fourBits, "0110") == 0)
		return '6';			
	else if(strcmp(fourBits, "0111") == 0)
		return '7';			
	else if(strcmp(fourBits, "1000") == 0)
		return '8';			
	else if(strcmp(fourBits, "1001") == 0)
		return '9';			
	else if(strcmp(fourBits, "1010") == 0)
		return 'a';			
	else if(strcmp(fourBits, "1011") == 0)
		return 'b';			
	else if(strcmp(fourBits, "1100") == 0)
		return 'c';			
	else if(strcmp(fourBits, "1101") == 0)
		return 'd';			
	else if(strcmp(fourBits, "1110") == 0)
		return 'e';			
	else 
		return 'f';			
}

char* convertbin(char n)
{
	char bit;
	char* fourBits = malloc(4);
	bit = n;

	printf("%c\n", bit);
	
	if(bit  == '0')
		strcpy(fourBits, "0000");	
	else if(bit == '1')
		strcpy(fourBits, "0001");	
	else if(bit == '2')
		strcpy(fourBits, "0010");	
	else if(bit == '3')
		strcpy(fourBits, "0011");	
	else if(bit == '4')
		strcpy(fourBits, "0100");	
	else if(bit == '5')
		strcpy(fourBits, "0101");	
	else if(bit == '6')
		strcpy(fourBits, "0110");	
	else if(bit == '7')
		strcpy(fourBits, "0111");	
	else if(bit == '8')
		strcpy(fourBits, "1000");	
	else if(bit == '9')
		strcpy(fourBits, "1001");	
	else if(bit == 'a')
		strcpy(fourBits, "1010");	
	else if(bit == 'b')
		strcpy(fourBits, "1011");	
	else if(bit == 'c')
		strcpy(fourBits, "1100");	
	else if(bit == 'd')
		strcpy(fourBits, "1101");	
	else if(bit == 'e')
		strcpy(fourBits, "1110");	
	else 
		strcpy(fourBits, "1111");	

	return fourBits;
}
uint64_t pack754(long double f, unsigned bits, unsigned expbits)
{
	long double fnorm;
	int shift;
	long long sign, exp, significand;
	unsigned significandbits = bits - expbits - 1; // -1 for sign bit

	if (f == 0.0) return 0; // get this special case out of the way

	// check sign and begin normalization
	if (f < 0) { sign = 1; fnorm = -f; }
	else { sign = 0; fnorm = f; }

	// get the normalized form of f and track the exponent
	shift = 0;
	while(fnorm >= 2.0) { fnorm /= 2.0; shift++; }
	while(fnorm < 1.0) { fnorm *= 2.0; shift--; }
	fnorm = fnorm - 1.0;

	// calculate the binary form (non-float) of the significand data
	significand = fnorm * ((1LL<<significandbits) + 0.5f);

	// get the biased exponent
	exp = shift + ((1<<(expbits-1)) - 1); // shift + bias

	// return the final answer
	return (sign<<(bits-1)) | (exp<<(bits-expbits-1)) | significand;
}

long double unpack754(uint64_t i, unsigned bits, unsigned expbits)
{
	long double result;
	long long shift;
	unsigned bias;
	unsigned significandbits = bits - expbits - 1; // -1 for sign bit

	if (i == 0) return 0.0;

	// pull the significand
	result = (i&((1LL<<significandbits)-1)); // mask
	result /= (1LL<<significandbits); // convert back to float
	result += 1.0f; // add the one back on

	// deal with the exponent
	bias = (1<<(expbits-1)) - 1;
	shift = ((i>>significandbits)&((1LL<<expbits)-1)) - bias;
	while(shift > 0) { result *= 2.0; shift--; }
	while(shift < 0) { result /= 2.0; shift++; }

	// sign it
	result *= (i>>(bits-1))&1? -1.0: 1.0;

	return result;
}

int main(void)
{
	float f, f2;
	
	FILE *fp = fopen("to_dCollideSpheres2.txt", "r");
	FILE *fp1 = fopen("to_dCollideSpheres8Hex.txt", "w");
	FILE *fp2 = fopen("outputs.txt", "r");
	FILE *fp3 = fopen("from_dCollideSpheres55.txt", "w");
	FILE *fp4 = fopen("FredyBinary.txt", "w");
	
	char *nString = malloc(16);

	uint32_t fi;
	
	char* binString = malloc(32);
	char hexString[11] = {'0','x','0','0','0','0','0','0','0','0','\0'};
	char* four = malloc(4);
	char hex;

	char* binary = malloc(33);

	int i, count = 0;
	while(fgets(nString, 16, fp) != NULL)
	{
		fgets(binString, 33, fp2);

		for(i = 0; i < 8; i = i + 1)
		{
			memcpy(four, &binString[i*4], 4);
			hex = convert(four);
			hexString[i+2] = hex;
		}
	
		f = (float)atof(nString);

		fi = pack754_32(f);
		f2 = unpack754_32((uint32_t)atof(hexString));
	
		fprintf(fp1, "push %d 0x%08" PRIx32 "\n", count, fi);	
		fprintf(fp3, "%lf\n", f2);

		char* temp = malloc(8);
		char* piece = malloc(4);
	
		sprintf(temp, "%08" PRIx32 , fi);
		for(i = 0; i < 8; i = i + 1)
		{
			piece = convertbin(temp[i]);	
			memcpy(&binary[i*4], piece, 4);
		}
		fprintf(fp4, "%s\n", binary);	
		count = count + 1;	

		if(count == 8)
		{
			fprintf(fp1, "push 8 0x00000000\n");	
			fprintf(fp1, "push 8 0x00000001\n");	

			int j;
			for(j = 9; j < 16; j = j + 1)
			{
				fprintf(fp1, "pop %d\n", j);	
			}
			count = 0;
			fprintf(fp1, "popfile 18\n");	
		}
	
		//reads the \n character
		fgets(binString, 33, fp2);
	}
	
	fclose(fp);
	fclose(fp1);
	fclose(fp2);
	fclose(fp3);
	fclose(fp4);
	
	return 0;
}

