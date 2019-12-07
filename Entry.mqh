//+------------------------------------------------------------------+
//|                                                   NNFX V1.30.mq4 |
//|                                     Copyright 2019, DA Solutions |
//|                                      https://www.dasolutions.org |
//+------------------------------------------------------------------+
#include "Classes/Settings.mqh";
#include "Classes/MoneyManagement.mqh"
#include "Classes/IndicatorWrappers/TmaExtreme.mqh"
#include "Classes/IndicatorWrappers/SuperScalper.mqh"

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class Entry
  {
private:
   Settings*         SettingsInstance;
   MoneyManagement*  MoneyManagementInstance;
   
   TmaExtreme*       TmaExtremeInstance;
   SuperScalper*     SuperScalperInstance;

   int               _lastSignal;
   int               _currentSignal;
   int               _optimizationStage;

public:
   void              Entry()
     {
      SettingsInstance = new Settings();
      MoneyManagementInstance = new MoneyManagement();
      
      TmaExtremeInstance = new TmaExtreme();
      SuperScalperInstance = new SuperScalper();
      
      this._optimizationStage = SettingsInstance._OptimizationStage;
     };

   void             ~Entry()
     {
      delete(SettingsInstance);
      delete(MoneyManagementInstance);
      
      delete(TmaExtremeInstance);
      delete(SuperScalperInstance);
     }

   void               Tick()
     {
      this._currentSignal = this.GetSignal();

      if(this._currentSignal == this._lastSignal)
        {
         return;
        }

      if(this._currentSignal == _SELL)
        {
         MoneyManagementInstance.Sell();
        }

      if(this._currentSignal == _BUY)
        {
         MoneyManagementInstance.Buy();
        }

      this._lastSignal = this._currentSignal;
     };

   int               GetSignal()
     {
      if(this._optimizationStage == 1 && TmaExtremeInstance.GetSignal() == _SELL)
        {
         return _SELL;
        }

      if(this._optimizationStage == 1 && TmaExtremeInstance.GetSignal() == _BUY)
        {
         return _BUY;
        }

      return 0;
     }
  };
//+------------------------------------------------------------------+
