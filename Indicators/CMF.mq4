#property indicator_separate_window
#property indicator_buffers 1
#property indicator_color1 Red

//Input parameters
extern int Periods=20;

//Indicator buffers
double CMF[];

int init()
{
SetIndexStyle(0,DRAW_LINE);
SetIndexBuffer(0,CMF);
IndicatorShortName( "CMF(" + Periods + ")" );

SetIndexDrawBegin(0,Periods);

return(0);
}

int deinit()
{
return(0);
}

int start()
{
int shift,limit,counted_bars=IndicatorCounted();
   
   if(Bars<=Periods) return(0);
//---- initial zero
   if(counted_bars<1)
      for(int i=1;i<=Periods;i++) CMF[Bars-i]=0.0;
//----
   if ( counted_bars > 0 )  limit=Bars-counted_bars;
   if ( counted_bars ==0 )  limit=Bars-Periods-1; 
   
   for(shift=limit;shift>=0;shift--)
   {	   
   double dN_Sum=0.0;
   double Volume_Sum=0.0;
      for(i=0;i<Periods-1;i++) 
      {	
      Volume_Sum+=Volume[shift+i];
      if((High[shift+i]-Low[shift+i])>0)
      dN_Sum += Volume[shift+i]*(Close[shift+i]-Open[shift+i])/(High[shift+i]-Low[shift+i]);
      }
   CMF[shift]=dN_Sum/Volume_Sum;
   }
return(0);
}