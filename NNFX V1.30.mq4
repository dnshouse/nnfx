//+------------------------------------------------------------------+
//|                                                   NNFX V1.30.mq4 |
//|                                     Copyright 2019, DA Solutions |
//|                                      https://www.dasolutions.org |
//+------------------------------------------------------------------+
#property strict

#define MAGICMA   1111111111
#define _SELL     1
#define _BUY      2

#include "Entry.mqh"
#include "Exit.mqh"

Entry* EntryInstance;
Exit* ExitInstance;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
   EntryInstance = new Entry();
   ExitInstance = new Exit();
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   delete(EntryInstance);
   delete(ExitInstance);
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

   EntryInstance.Tick();
//ExitInstance.Tick();

  }
//+------------------------------------------------------------------+
