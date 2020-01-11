//+------------------------------------------------------------------+
//|                                                             NNFX |
//|                                     Copyright 2019, DA Solutions |
//|                                      https://www.dasolutions.org |
//+------------------------------------------------------------------+
#include "Classes/Settings.mqh"
#include "Classes/MoneyManagement.mqh"

#include "Classes/IndicatorWrappers/MovingAverage.mqh"
#include "Classes/IndicatorWrappers/AroonUpAndDown.mqh"
#include "Classes/IndicatorWrappers/ChaikinMoneyFlow.mqh"
#include "Classes/IndicatorWrappers/AbsoluteStrengthOscillator.mqh"

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class Exit
  {
private:
   Settings*                     SettingsInstance;
   MoneyManagement*              MoneyManagementInstance;

   MovingAverage*                MovingAverageInstance;
   AroonUpAndDown*               AroonUpAndDownInstance;
   ChaikinMoneyFlow*             ChaikinMoneyFlowInstance;
   AbsoluteStrengthOscillator*   AbsoluteStrengthOscillatorInstance;

   int                           _lastSignal;
   int                           _currentSignal;

public:
   void              Exit()
     {
      SettingsInstance = new Settings();
      MoneyManagementInstance = new MoneyManagement();

      MovingAverageInstance = new MovingAverage(SettingsInstance._IndicatorsTimeframe, SettingsInstance._IndicatorsOffset, SettingsInstance._Baseline_Period, SettingsInstance._Baseline_Levels);
      AroonUpAndDownInstance = new AroonUpAndDown(SettingsInstance._IndicatorsTimeframe, SettingsInstance._IndicatorsOffset, SettingsInstance._ConfirmationIndicator_Period);
      ChaikinMoneyFlowInstance = new ChaikinMoneyFlow(SettingsInstance._IndicatorsTimeframe, SettingsInstance._IndicatorsOffset, SettingsInstance._SecondConfirmationIndicator_Period);
      AbsoluteStrengthOscillatorInstance = new AbsoluteStrengthOscillator(SettingsInstance._IndicatorsTimeframe, SettingsInstance._IndicatorsOffset);
     }

   void             ~Exit()
     {
      delete(SettingsInstance);
      delete(MoneyManagementInstance);

      delete(MovingAverageInstance);
      delete(AroonUpAndDownInstance);
      delete(ChaikinMoneyFlowInstance);
      delete(AbsoluteStrengthOscillatorInstance);
     }

   void              Tick()
     {
      this._currentSignal = AroonUpAndDownInstance.GetState();

      if(this._currentSignal != this._lastSignal)
        {
         this.MoneyManagementInstance.CloseAll();
        }

      this._lastSignal = this._currentSignal;
     }
  };
//+------------------------------------------------------------------+
