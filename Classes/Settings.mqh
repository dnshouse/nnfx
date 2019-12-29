//+------------------------------------------------------------------+
//|                                                             NNFX |
//|                                     Copyright 2019, DA Solutions |
//|                                      https://www.dasolutions.org |
//+------------------------------------------------------------------+
extern bool    PrefSettings = true;

extern double  Risk = 0.01;
extern bool    RiskManagement = true;
extern double  MinimumLotSize = 0.1;

extern int              OptimizationStage = 1;
extern int              IndicatorsOffset = 1;
extern ENUM_TIMEFRAMES  IndicatorsTimeframe = PERIOD_CURRENT; // PERIOD_D1

extern double           TP_Multiplier = 0.5;
extern double           SL_Multiplier = 0.5;
extern int              Baseline_Period = 4;
extern int              Confirmation_Period = 4;
extern int              Reversal_Period = 4;

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class Settings
  {
public:
   double            _Risk;
   bool              _RiskManagement;
   double            _MinimumLotSize;

   int               _OptimizationStage;

   int               _IndicatorsOffset;
   int               _IndicatorsTimeframe;

   double            _TP_Multiplier;
   double            _SL_Multiplier;
   int               _Baseline_Period;
   int               _Confirmation_Period;
   int               _Reversal_Period;

   void              Settings()
     {
      this._Risk = Risk;
      this._RiskManagement = RiskManagement;
      this._MinimumLotSize = MinimumLotSize;

      this._IndicatorsOffset = IndicatorsOffset;
      this._IndicatorsTimeframe = IndicatorsTimeframe;

      this._Reversal_Period = Reversal_Period;

      this._OptimizationStage = OptimizationStage;
      this._TP_Multiplier = TP_Multiplier;
      this._SL_Multiplier = SL_Multiplier;
      this._Baseline_Period = Baseline_Period;
      this._Confirmation_Period = Confirmation_Period;

      if(PrefSettings == true)
        {
         if((Symbol() == "AUDCAD") || (Symbol() == "AUDCADmicro"))
           {
           }

         if((Symbol() == "AUDCHF") || (Symbol() == "AUDCHFmicro"))
           {
           }

         if((Symbol() == "AUDJPY") || (Symbol() == "AUDJPYmicro"))
           {
           }

         if((Symbol() == "AUDNZD") || (Symbol() == "AUDNZDmicro"))
           {
           }

         if((Symbol() == "AUDUSD") || (Symbol() == "AUDUSDmicro"))
           {
           }

         if((Symbol() == "CADCHF") || (Symbol() == "CADCHFmicro"))
           {
           }

         if((Symbol() == "CADJPY") || (Symbol() == "CADJPYmicro"))
           {
           }

         if((Symbol() == "CHFJPY") || (Symbol() == "CHFJPYmicro"))
           {
           }

         if((Symbol() == "EURAUD") || (Symbol() == "EURAUDmicro"))
           {
           }

         if((Symbol() == "EURCAD") || (Symbol() == "EURCADmicro"))
           {
           }

         if((Symbol() == "EURCHF") || (Symbol() == "EURCHFmicro"))
           {
           }

         if((Symbol() == "EURGBP") || (Symbol() == "EURGBPmicro"))
           {
           }

         if((Symbol() == "EURJPY") || (Symbol() == "EURJPYmicro"))
           {
           }

         if((Symbol() == "EURNZD") || (Symbol() == "EURNZDmicro"))
           {
           }

         if((Symbol() == "EURUSD") || (Symbol() == "EURUSDmicro"))
           {
           }

         if((Symbol() == "GBPAUD") || (Symbol() == "GBPAUDmicro"))
           {
           }

         if((Symbol() == "GBPCAD") || (Symbol() == "GBPCADmicro"))
           {
           }

         if((Symbol() == "GBPCHF") || (Symbol() == "GBPCHFmicro"))
           {
           }

         if((Symbol() == "GBPJPY") || (Symbol() == "GBPJPYmicro"))
           {
           }

         if((Symbol() == "GBPNZD") || (Symbol() == "GBPNZDmicro"))
           {
           }

         if((Symbol() == "GBPUSD") || (Symbol() == "GBPUSDmicro"))
           {
           }

         if((Symbol() == "NZDCAD") || (Symbol() == "NZDCADmicro"))
           {
           }

         if((Symbol() == "NZDCHF") || (Symbol() == "NZDCHFmicro"))
           {
           }

         if((Symbol() == "NZDJPY") || (Symbol() == "NZDJPYmicro"))
           {
           }

         if((Symbol() == "NZDUSD") || (Symbol() == "NZDUSDmicro"))
           {
           }

         if((Symbol() == "USDCAD") || (Symbol() == "USDCADmicro"))
           {
           }

         if((Symbol() == "USDCHF") || (Symbol() == "USDCHFmicro"))
           {
           }

         if((Symbol() == "USDJPY") || (Symbol() == "USDJPYmicro"))
           {
           }
        }
      else
        {
        }
     }
  };
//+------------------------------------------------------------------+
