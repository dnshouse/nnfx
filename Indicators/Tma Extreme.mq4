#property copyright ""
#property link      ""

#property indicator_chart_window
#property indicator_buffers 6
#property indicator_color1  clrGreen
#property indicator_color2  clrSteelBlue  //Teal  //clrWhite
#property indicator_color3  clrSteelBlue  //Teal  //clrWhite
#property indicator_color4  clrLime 
#property indicator_color5  clrRed
#property indicator_color6  clrGold
#property indicator_style2  STYLE_DOT
#property indicator_style3  STYLE_DOT
#property  indicator_width1 0
#property  indicator_width2 1
#property  indicator_width3 1
#property  indicator_width4 2
#property  indicator_width5 2
#property  indicator_width6 2


extern string TimeFrame      = "Current";
extern int    TMAPeriod      = 45;
extern int    Price          = PRICE_MEDIAN;
extern double ATRMultiplier  = 1.272;
extern int    ATRPeriod      = 100;
extern double TrendThreshold = 0.5;
extern bool   ShowCenterLine = true;

extern bool   alertsOn       = true;
extern bool   alertsMessage  = true;
extern bool   alertsSound    = true;
extern bool   alertsEmail    = false;
extern bool   alertsMobile   = false;
extern string soundFile      = "alert2.wav";   

double tma[];
double upperBand[];
double lowerBand[];
double bull[];
double bear[];
double neutral[];
 
int    MTF;
bool AlertHappened;
datetime AlertTime;
double TICK;
bool AdditionalDigit;


int init()
{
   AdditionalDigit = MarketInfo(_Symbol, MODE_MARGINCALCMODE) == 0 && MarketInfo(_Symbol, MODE_PROFITCALCMODE) == 0 && Digits % 2 == 1;
   
   TICK = MarketInfo(_Symbol, MODE_TICKSIZE);   if (AdditionalDigit) TICK *= 10;
    
   MTF         = stringToTimeFrame(TimeFrame);
                
   IndicatorBuffers(6); 
   SetIndexBuffer(0,tma);        SetIndexDrawBegin(0,TMAPeriod * (MTF / _Period) );
   SetIndexBuffer(1,upperBand);  SetIndexDrawBegin(1,TMAPeriod* (MTF / _Period));
   SetIndexBuffer(2,lowerBand);  SetIndexDrawBegin(2,TMAPeriod* (MTF / _Period));
   SetIndexBuffer(3,bull);       SetIndexDrawBegin(3,TMAPeriod* (MTF / _Period));
   SetIndexBuffer(4,bear);       SetIndexDrawBegin(4,TMAPeriod* (MTF / _Period));
   SetIndexBuffer(5,neutral);    SetIndexDrawBegin(5,TMAPeriod* (MTF / _Period));
   
   SetIndexStyle(0,DRAW_NONE);   SetIndexLabel(0,TFtoSTR(MTF)+": TMA ["+(string)TMAPeriod+"]");
   SetIndexStyle(1,DRAW_LINE);   SetIndexLabel(1,TFtoSTR(MTF)+": Band UPPER");
   SetIndexStyle(2,DRAW_LINE);   SetIndexLabel(2,TFtoSTR(MTF)+": Band LOWER");
   SetIndexStyle(3,DRAW_LINE);   SetIndexLabel(3,"Trend BULL ["+DoubleToStr(TrendThreshold,2)+"]");  
   SetIndexStyle(4,DRAW_LINE);   SetIndexLabel(4,"Trend BEAR ["+DoubleToStr(TrendThreshold,2)+"]");  
   SetIndexStyle(5,DRAW_LINE);   SetIndexLabel(5,"Trend FLAT ["+DoubleToStr(TrendThreshold,2)+"]");  
    
   IndicatorShortName(TFtoSTR(MTF)+": TMA Extreme ["+(string)TMAPeriod+"]");
   return(0);
}
int deinit() { return(0); }


int start(){
   
   int counted_bars=IndicatorCounted();
   int i,limit;

   if(counted_bars<0) return(-1);
   if(counted_bars>0) counted_bars--;
   double barsPerTma = (MTF / _Period);
   limit=MathMin(Bars-1,Bars-counted_bars+ TMAPeriod * barsPerTma ); 

   int mtfShift = 0;
   int lastMtfShift = 999;
   double tmaVal = tma[limit+1];
   double range = 0;
   
   double slope = 0;
   double prevTma = tma[limit+1];
   double prevSlope = 0;
   
   
   for (i=limit; i>=0; i--){
      if (MTF == _Period){
         mtfShift = i;
      }
      else{         
         mtfShift = iBarShift(_Symbol,MTF,Time[i]);
      } 
      
      if(mtfShift == lastMtfShift){       
         tma[i] =tma[i+1] + ((tmaVal - prevTma) * (1/barsPerTma));         
         upperBand[i] =  tma[i] + range;
         lowerBand[i] = tma[i] - range;
         DrawCenterLine(i, slope);   
         continue;
      }
      
      lastMtfShift = mtfShift;
      prevTma = tmaVal;
      tmaVal = CalcTma(mtfShift);
      
      range = iATR(NULL,MTF,ATRPeriod,mtfShift+10)*ATRMultiplier;
      if(range == 0) range = 1;
      
      if (barsPerTma > 1)
      {
         tma[i] =prevTma + ((tmaVal - prevTma) * (1/barsPerTma));
      }
      else{
         tma[i] =tmaVal;
      }
      upperBand[i] = tma[i]+range;
      lowerBand[i] = tma[i]-range;

      slope = (tmaVal-prevTma) / ((range / ATRMultiplier) * 0.1);
            
      DrawCenterLine(i, slope);
          
   }
   
   manageAlerts();
   return(0);
}

void DrawCenterLine(int shift, double slope)
{

   bull[shift] = EMPTY_VALUE;
   bear[shift] = EMPTY_VALUE;          
   neutral[shift] = EMPTY_VALUE; 
   if (ShowCenterLine)
   {
      if(slope > TrendThreshold)
      {
         bull[shift] = tma[shift];
      }
      else if(slope < -1 * TrendThreshold)
      {
         bear[shift] = tma[shift];
      }
      else
      {
         neutral[shift] = tma[shift];
      }
   }
}

 double CalcTma( int inx )
{ 
   double dblSum  = (TMAPeriod+1)*iClose(_Symbol,MTF,inx);
   double dblSumw = (TMAPeriod+1);
   int jnx, knx;
         
   for ( jnx = 1, knx = TMAPeriod; jnx <= TMAPeriod; jnx++, knx-- )
   {
      dblSum  += ( knx * iClose(_Symbol,MTF,inx+jnx) );
      dblSumw += knx;      
      
      /*
      if ( jnx <= inx )
      {         
         if (iTime(_Symbol,MTF,inx-jnx) > Time[0])
         {
            //Print (" MTF ", MTF , " inx ", inx," jnx ", jnx, " iTime(_Symbol,MTF,inx-jnx) ", TimeToStr(iTime(_Symbol,MTF,inx-jnx)), " Time[0] ", TimeToStr(Time[0])); 
            continue;
         }
         dblSum  += ( knx * iClose(_Symbol,MTF,inx-jnx) );
         dblSumw += knx;
      }
      */
   }
   
   return( dblSum / dblSumw );
}
 

void manageAlerts()
{
   if (alertsOn)
   { 
      int trend;        
      if (Close[0] > upperBand[0]) trend =  1;
      else if (Close[0] < lowerBand[0]) trend = -1;
      else {AlertHappened = false;}
            
      if (!AlertHappened && AlertTime != Time[0])
      {       
         if (trend == 1) doAlert("up");
         if (trend ==-1) doAlert("down");
      }         
   }
}


void doAlert(string doWhat)
{ 
   if (AlertHappened) return;
   AlertHappened = true;
   AlertTime = Time[0];
   string message;
     
   message =  StringConcatenate(_Symbol," at ",TimeToStr(TimeLocal(),TIME_SECONDS)," "+TFtoSTR(MTF)+" TMA Extreme price penetrated ",doWhat," band");
   if (alertsMessage) Alert(message);
   if (alertsEmail)   SendMail(StringConcatenate(_Symbol,"TMA Extreme "),message);
   if (alertsMobile)  SendNotification(message);  
   if (alertsSound)   PlaySound(soundFile);

}

//+-------------------------------------------------------------------
//|   Time Frame Handlers                                                               
//+-------------------------------------------------------------------


string sTfTable[] = {"M1","M5","M15","M30","H1","H4","D1","W1","MN"};
int    iTfTable[] = {1,5,15,30,60,240,1440,10080,43200};


int stringToTimeFrame(string tfs)
{
   tfs = StringUpperCase(tfs);
   for (int i=ArraySize(iTfTable)-1; i>=0; i--)
   {
      if (tfs==sTfTable[i] || tfs==""+iTfTable[i]) 
      {
         return(MathMax(iTfTable[i],_Period));
      }
   }
   return(_Period);
   
}
string TFtoSTR(int tf)
{
   for (int i=ArraySize(iTfTable)-1; i>=0; i--) 
         if (tf==iTfTable[i]) return(sTfTable[i]);
                              return("");
}

string StringUpperCase(string str)
{
   string   s = str;

   for (int length=StringLen(str)-1; length>=0; length--)
   {
      int Char = StringGetChar(s, length);
         if((Char > 96 && Char < 123) || (Char > 223 && Char < 256))
                     s = StringSetChar(s, length, Char - 32);
         else if(Char > -33 && Char < 0)
                     s = StringSetChar(s, length, Char + 224);
   }
   return(s);
}