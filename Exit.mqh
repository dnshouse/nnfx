//+------------------------------------------------------------------+
//|                                                             NNFX |
//|                                     Copyright 2019, DA Solutions |
//|                                      https://www.dasolutions.org |
//+------------------------------------------------------------------+
#include "Classes/Settings.mqh"
#include "Classes/MoneyManagement.mqh"

#include "Classes/IndicatorWrappers/AbsoluteStrengthOscillator.mqh"

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class Exit
  {
private:
   Settings*                     SettingsInstance;
   MoneyManagement*              MoneyManagementInstance;
   AbsoluteStrengthOscillator*   AbsoluteStrengthOscillatorInstance;

   int                           _lastSignal;
   int                           _currentSignal;

public:
   void              Exit()
     {
      SettingsInstance = new Settings();
      MoneyManagementInstance = new MoneyManagement();
      AbsoluteStrengthOscillatorInstance = new AbsoluteStrengthOscillator(SettingsInstance._IndicatorsTimeframe);
     }

   void             ~Exit()
     {
      delete(SettingsInstance);
      delete(MoneyManagementInstance);
      delete(AbsoluteStrengthOscillatorInstance);
     }

   void              Tick()
     {
      this._currentSignal = AbsoluteStrengthOscillatorInstance.GetSignal();

      if(this._currentSignal != this._lastSignal)
        {
         this.MoneyManagementInstance.CloseAll();
        }

      this._lastSignal = this._currentSignal;
     }
  };
//+------------------------------------------------------------------+
