//+------------------------------------------------------------------+
//|                                                   NNFX V1.30.mq4 |
//|                                     Copyright 2019, DA Solutions |
//|                                      https://www.dasolutions.org |
//+------------------------------------------------------------------+
#include "Classes/MoneyManagement.mqh"
#include "Classes/IndicatorWrappers/SuperScalper.mqh"

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class Exit
  {
private:
   MoneyManagement*  MoneyManagementInstance;
   SuperScalper*     SuperScalperInstance_H4;

   int               _lastSignal;
   int               _currentSignal;

public:
   void              Exit()
     {
      MoneyManagementInstance = new MoneyManagement();
      SuperScalperInstance_H4 = new SuperScalper(PERIOD_H4);
     };

   void             ~Exit()
     {
      delete(MoneyManagementInstance);
      delete(SuperScalperInstance_H4);
     }

   void              Tick()
     {
      this._currentSignal = SuperScalperInstance_H4.GetSignal();

      if(this._currentSignal != this._lastSignal)
        {
         this.MoneyManagementInstance.CloseAll();
        }

      this._lastSignal = this._currentSignal;
     };
  };
//+------------------------------------------------------------------+
