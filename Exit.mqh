//+------------------------------------------------------------------+
//|                                                   NNFX V1.30.mq4 |
//|                                     Copyright 2019, DA Solutions |
//|                                      https://www.dasolutions.org |
//+------------------------------------------------------------------+
#include "Classes/MoneyManagement.mqh"

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class Exit
  {
private:
   MoneyManagement*  MoneyManagementInstance;

   int               _lastSignal;
   int               _currentSignal;

public:
   void              Exit()
     {
      MoneyManagementInstance = new MoneyManagement();
     };

   void             ~Exit()
     {
      delete(MoneyManagementInstance);
     }

   void              Tick()
     {
      //this._currentSignal = SomeInstance.GetSignal();

      if(this._currentSignal > 0 && this._currentSignal != this._lastSignal)
        {
         this.MoneyManagementInstance.CloseAll();
        }

      if(this._currentSignal > 0)
        {
         this._lastSignal = this._currentSignal;
        }
     };
  };
//+------------------------------------------------------------------+
