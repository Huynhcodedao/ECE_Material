#include "numberclass.h"

void DSP1D::storearray(float _inputs[],int _length)
{
	length = _length;
	inputs = _inputs;
}

float DSP1D::max()
{
	float temp = 0;
	for (int i=0; i<length; i++)
	{
		if (inputs[i] > temp) temp = inputs[i];
	}

	return temp;
}

float DSP1D::min()
{
	float temp = inputs[0];
	for (int i=0; i<length; i++)
	{
		if (inputs[i] < temp) temp = inputs[i];
	}
	return temp;
}

float DSP1D::avg()
{
	float temp = 0;
	for (int i=0;i<length;i++)
	{
		temp = temp+inputs[i];
	}
	temp = temp/length;
	return temp;
}


float DSP1D::var()
{
	float avg = this->avg();
	float tempvar = 0;
	float temp = 0;
	for (int i=0; i<length; i++)
	{
		temp = inputs[i]-avg;
		temp = pow(temp,2);
		tempvar = tempvar + temp;
	}
	tempvar = tempvar/length;
	return tempvar;
}

float DSP1D::standev()
{
	float temp = this->var();
	temp = sqrt(temp);
	return temp;
}

float DSP1D::sort()
{
	  int i=0;
	  int x=0;
	for (i=length; i>=0; i--)
	{
	for (x=0; x<length-1; x++)
		{
		if (inputs[x] > inputs[x+1])
			{
				float temp = inputs[x+1];
				inputs[x+1] = inputs[x];
				inputs[x] = temp;
			}
		}
	}
	return *inputs;
    
}
