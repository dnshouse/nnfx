//+------------------------------------------------------------------+
//|                                                   NNFX V1.30.mq4 |
//|                                     Copyright 2019, DA Solutions |
//|                                      https://www.dasolutions.org |
//+------------------------------------------------------------------+
#include "Classes/Settings.mqh";
#include "Classes/MoneyManagement.mqh"
#include "Classes/IndicatorWrappers/SuperScalper.mqh"

#include "Classes/IndicatorWrappers/TmaExtreme.mqh"
#include "Classes/IndicatorWrappers/AroonUpAndDown.mqh"

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class Entry
  {
private:
   Settings*         SettingsInstance;
   MoneyManagement*  MoneyManagementInstance;
   SuperScalper*     SuperScalperInstance_H4;
   SuperScalper*     SuperScalperInstance_D1;

   int               _lastSignal;
   int               _currentSignal;

public:
   void              Entry()
     {
      SettingsInstance = new Settings();
      MoneyManagementInstance = new MoneyManagement();
      SuperScalperInstance_H4 = new SuperScalper(PERIOD_H4, SettingsInstance._IndicatorsOffset);
      SuperScalperInstance_D1 = new SuperScalper(PERIOD_D1, SettingsInstance._IndicatorsOffset);
     };

   void             ~Entry()
     {
      delete(SettingsInstance);
      delete(MoneyManagementInstance);
      delete(SuperScalperInstance_H4);
      delete(SuperScalperInstance_D1);
     }

   void               Tick()
     {
      if(OrdersTotal() == 0 && SuperScalperInstance_D1.GetSignal() == _SELL && SuperScalperInstance_H4.GetSignal() == _SELL)
        {
         MoneyManagementInstance.Sell();
        }

      if(OrdersTotal() == 0 && SuperScalperInstance_D1.GetSignal() == _BUY && SuperScalperInstance_H4.GetSignal() == _BUY)
        {
         MoneyManagementInstance.Buy();
        }
     };
  };
//+------------------------------------------------------------------+
