//+------------------------------------------------------------------+
//|                                                             NNFX |
//|                                     Copyright 2019, DA Solutions |
//|                                      https://www.dasolutions.org |
//+------------------------------------------------------------------+
#property strict

#define MAGICMA   1111111111
#define _BUY      1
#define _SELL     2

#include "Classes/Settings.mqh"
#include "Exit.mqh"
#include "Entry.mqh"

Settings* SettingsInstance;
Exit* ExitInstance;
Entry* EntryInstance;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
   SettingsInstance = new Settings();
   ExitInstance = new Exit();
   EntryInstance = new Entry();
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   delete(SettingsInstance);
   delete(ExitInstance);
   delete(EntryInstance);
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
   if(Bars < 30 || IsTradeAllowed() == false)
      return;

   if(IsNewCandle()==false)
      return;

   if(SettingsInstance._LiveMode == true && Hour() != 23)
      return;
   if(SettingsInstance._LiveMode == true && Minute() < 45)
      return;

   if(SettingsInstance._LiveMode == false && Hour() != 0)
      return;

   ExitInstance.Tick();
   EntryInstance.Tick();
  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
datetime NewCandleTime=TimeCurrent();
bool IsNewCandle()
  {
   if(NewCandleTime==iTime(Symbol(),0,0))
      return false;
   else
     {
      NewCandleTime=iTime(Symbol(),0,0);
      return true;
     }
  }
//+------------------------------------------------------------------+
