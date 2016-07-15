#include<stdio.h>
#include<stdlib.h>
#include<string.h>

int main()
{
	FILE *fp = fopen("from_dCollideSpheresNUMBERS.txt", "r");
	FILE *fp2 = fopen("floatNumbers.txt", "r");
//	FILE *fp1 = fopen("uss_org_time_total.txt", "w");

	char *nstring = malloc(5);
	char *nstring2 = malloc(10);
	size_t len = 5;
	size_t len2 = 5;
	ssize_t read;
	ssize_t read2;

	float num;
	while(read = getline(&nstring, &len, fp) != -1)
	{
		num = num + atof(nstring);
	}

	float num2;
	while(read2 = getline(&nstring2, &len2, fp2) != -1)
	{
		num2 = num2 + atof(nstring2);
	}

	printf("%f\n", num);
//	printf("%f\n", num2);

	fclose(fp);
	fclose(fp2);

	free(nstring);	
	free(nstring2);	
	return 0;
}
