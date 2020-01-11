//+------------------------------------------------------------------+
//|                                                             NNFX |
//|                                     Copyright 2019, DA Solutions |
//|                                      https://www.dasolutions.org |
//+------------------------------------------------------------------+
#property strict

#define MAGICMA   1111111111
#define _BUY      1
#define _SELL     2

#include "Exit.mqh"
#include "Entry.mqh"

Exit* ExitInstance;
Entry* EntryInstance;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
   ExitInstance = new Exit();
   EntryInstance = new Entry();
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
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

   if(Volume[0] > 1)
      return;

   //ExitInstance.Tick();
   EntryInstance.Tick();
  }
//+------------------------------------------------------------------+
