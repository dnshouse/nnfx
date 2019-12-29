//+------------------------------------------------------------------+
//|                                                             NNFX |
//|                                     Copyright 2019, DA Solutions |
//|                                      https://www.dasolutions.org |
//+------------------------------------------------------------------+
#include "Classes/Settings.mqh"
#include "Classes/MoneyManagement.mqh"

#include "Classes/IndicatorWrappers/SuperScalper.mqh"
#include "Classes/IndicatorWrappers/AroonUpAndDown.mqh"
#include "Classes/IndicatorWrappers/TmaExtreme.mqh"

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class Entry
  {
private:
   Settings*         SettingsInstance;
   MoneyManagement*  MoneyManagementInstance;
   AroonUpAndDown*   AroonUpAndDownInstance;

   int               _lastSignal;
   int               _currentSignal;

public:
   void              Entry()
     {
      SettingsInstance = new Settings();
      MoneyManagementInstance = new MoneyManagement();
      AroonUpAndDownInstance = new AroonUpAndDown(SettingsInstance._IndicatorsTimeframe);
     }

   void             ~Entry()
     {
      delete(SettingsInstance);
      delete(MoneyManagementInstance);
      delete(AroonUpAndDownInstance);
     }

   void               Tick()
     {
      if(OrdersTotal() == 0 && this.GetSignal() == _SELL)
        {
         MoneyManagementInstance.Sell();
        }

      if(OrdersTotal() == 0 && this.GetSignal() == _BUY)
        {
         MoneyManagementInstance.Buy();
        }
     }

   int               GetSignal()
     {
      this._currentSignal = AroonUpAndDownInstance.GetSignal();

      if(this._currentSignal != this._lastSignal)
        {
         return this._currentSignal;
        }

      this._lastSignal = this._currentSignal;

      return 0;
     }
  };
//+------------------------------------------------------------------+
