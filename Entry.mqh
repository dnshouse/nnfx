//+------------------------------------------------------------------+
//|                                                             NNFX |
//|                                     Copyright 2019, DA Solutions |
//|                                      https://www.dasolutions.org |
//+------------------------------------------------------------------+
#include "Classes/Settings.mqh"
#include "Classes/MoneyManagement.mqh"

#include "Classes/IndicatorWrappers/AroonUpAndDown.mqh"
#include "Classes/IndicatorWrappers/CMF.mqh"

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class Entry
  {
private:
   Settings*         SettingsInstance;
   MoneyManagement*  MoneyManagementInstance;

   AroonUpAndDown*   AroonUpAndDownInstance;
   CMF*              CMFInstance;

   int               _lastSignal;
   int               _currentSignal;

public:
   void              Entry()
     {
      SettingsInstance = new Settings();
      MoneyManagementInstance = new MoneyManagement();

      AroonUpAndDownInstance = new AroonUpAndDown(SettingsInstance._IndicatorsTimeframe);
      CMFInstance = new CMF(SettingsInstance._IndicatorsTimeframe);
     }

   void             ~Entry()
     {
      delete(SettingsInstance);
      delete(MoneyManagementInstance);

      delete(AroonUpAndDownInstance);
      delete(CMFInstance);
     }

   void               Tick()
     {
      this._currentSignal = this.GetSignal();

      if(this._currentSignal != this._lastSignal)
        {
         if(OrdersTotal() == 0 && this._currentSignal == _SELL)
           {
            MoneyManagementInstance.Sell();
           }

         if(OrdersTotal() == 0 && this._currentSignal == _BUY)
           {
            MoneyManagementInstance.Buy();
           }
        }

      this._lastSignal = this._currentSignal;
     }

   int               GetSignal()
     {
      if(AroonUpAndDownInstance.GetSignal() == _BUY && CMFInstance.GetSignal() == _BUY)
        {
         return _BUY;
        }

      if(AroonUpAndDownInstance.GetSignal() == _SELL && CMFInstance.GetSignal() == _SELL)
        {
         return _SELL;
        }

      return 0;
     }
  };
//+------------------------------------------------------------------+
