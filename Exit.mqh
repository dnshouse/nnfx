//+------------------------------------------------------------------+
//|                                                             NNFX |
//|                                     Copyright 2019, DA Solutions |
//|                                      https://www.dasolutions.org |
//+------------------------------------------------------------------+
#include "Classes/Settings.mqh"
#include "Classes/MoneyManagement.mqh"
#include "Classes/IndicatorWrappers/AroonUpAndDown.mqh"

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class Exit
  {
private:
   Settings*         SettingsInstance;
   MoneyManagement*  MoneyManagementInstance;
   AroonUpAndDown*   AroonUpAndDownInstance;

   int               _lastSignal;
   int               _currentSignal;

public:
   void              Exit()
     {
      SettingsInstance = new Settings();
      MoneyManagementInstance = new MoneyManagement();
      AroonUpAndDownInstance = new AroonUpAndDown(SettingsInstance._IndicatorsTimeframe);
     }

   void             ~Exit()
     {
      delete(SettingsInstance);
      delete(MoneyManagementInstance);
      delete(AroonUpAndDownInstance);
     }

   void              Tick()
     {
      this._currentSignal = AroonUpAndDownInstance.GetSignal();

      if(this._currentSignal != this._lastSignal)
        {
         this.MoneyManagementInstance.CloseAll();
        }

      this._lastSignal = this._currentSignal;
     }
  };
//+------------------------------------------------------------------+
