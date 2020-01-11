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
class Entry
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
   void              Entry()
     {
      SettingsInstance = new Settings();
      MoneyManagementInstance = new MoneyManagement();

      MovingAverageInstance = new MovingAverage(
         SettingsInstance._IndicatorsTimeframe,
         SettingsInstance._IndicatorsOffset,
         SettingsInstance._Baseline_Period,
         SettingsInstance._Baseline_Levels
      );

      AroonUpAndDownInstance = new AroonUpAndDown(
         SettingsInstance._IndicatorsTimeframe,
         SettingsInstance._IndicatorsOffset,
         SettingsInstance._ConfirmationIndicator_Period
      );

      ChaikinMoneyFlowInstance = new ChaikinMoneyFlow(
         SettingsInstance._IndicatorsTimeframe,
         SettingsInstance._IndicatorsOffset,
         SettingsInstance._SecondConfirmationIndicator_Period,
         SettingsInstance._VolumeIndicator_MinimumVolume
      );

      AbsoluteStrengthOscillatorInstance = new AbsoluteStrengthOscillator(
         SettingsInstance._IndicatorsTimeframe,
         SettingsInstance._IndicatorsOffset
      );
     }

   void             ~Entry()
     {
      delete(SettingsInstance);
      delete(MoneyManagementInstance);

      delete(MovingAverageInstance);
      delete(AroonUpAndDownInstance);
      delete(ChaikinMoneyFlowInstance);
      delete(AbsoluteStrengthOscillatorInstance);
     }

   void               Tick()
     {
      this._currentSignal = this.GetSignal();

      if(this._currentSignal != this._lastSignal)
        {
         if(
            //OrdersTotal() == 0 &&
            this._currentSignal == _BUY
         )
           {
            MoneyManagementInstance.Buy();
           }

         if(
            //OrdersTotal() == 0 &&
            this._currentSignal == _SELL
         )
           {
            MoneyManagementInstance.Sell();
           }
        }

      this._lastSignal = this._currentSignal;
     }

   int               GetSignal()
     {
      if(AroonUpAndDownInstance.GetSignal() == _BUY && ChaikinMoneyFlowInstance.GetState() == _BUY)
        {
         return _BUY;
        }

      if(ChaikinMoneyFlowInstance.GetSignal() == _BUY && AroonUpAndDownInstance.GetState() == _BUY)
        {
         return _BUY;
        }

      if(AroonUpAndDownInstance.GetSignal() == _SELL && ChaikinMoneyFlowInstance.GetState() == _SELL)
        {
         return _SELL;
        }

      if(ChaikinMoneyFlowInstance.GetSignal() == _SELL && AroonUpAndDownInstance.GetState() == _SELL)
        {
         return _SELL;
        }

      return 0;
     }
  };
//+------------------------------------------------------------------+
