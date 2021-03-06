//+------------------------------------------------------------------+
//|                                                  MultiChange.mq4 |
//|                                              Copyright 2020, MZ. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
//|            Combine with Period Change.mq4 and MultiIndicators.mqh4

#property copyright "Copyright 2020, Horse Technology Software Corp."
#property link      "https://www.horseforex.net"
#property version   "1.00"
#property strict
#property indicator_separate_window
#property indicator_minimum 0
#property indicator_maximum 1
#property indicator_buffers 2
#property indicator_color1 Lime
#property indicator_color2 Red
#property description "交易货币对实时多重分时指标监测" 
#property description "注意：请仅做辅助分析使用！" 
#property description "指标所有权和归属权归于马汇科技@Horseforex" 
#property description "如需修改及自定义指标请联系VX:306599003" 
#property description "开户链接: https://secure.horsegroup.net/register/" 
#property description "Trend Check&Mulit-Indicators. Copyright@Horseforex" 
#property description "Open Account: https://secure.horsegroup.net/register/" 

//---- buffers
double UPBuffer[];
double DOWNBuffer[];
int flag;

string    MA_Settings           = "=== Moving Average Settings ===";
int       FastMAPeriod          =           20;  // Fast Moving Average period
int       MediumMAPeriod        =           50;  // Medium Moving Average period
int       SlowMAPeriod          =          100;  // Slow Moving Average period
int       MAMethod              =     MODE_EMA;  // Moving Average method
int       MAPrice               =  PRICE_CLOSE;  // Moving Average price

string    CCI_Settings          = "=== CCI Settings ===";
int       CCIPeriod             =           14;  // Commodity Channel Index  period
int       CCIPrice              =  PRICE_CLOSE;  // CCI price

string    MACD_Settings         = "=== MACD Settings ===";
int       MACDFast              =           12;  // MACD fast EMA period
int       MACDSlow              =           26;  // MACD slow EMA period
int       MACDSignal            =            9;  // MACD signal SMA period

string    ADX_Settings          = "=== ADX Settings ===";
int       ADXPeriod             =           14;  // Average Directional movement  period
int       ADXPrice              =  PRICE_CLOSE;  // ADX price

string    BULLS_Settings        = "=== BULLS Settings ===";
int       BULLSPeriod           =           13;  // Bulls Power  period
int       BULLSPrice            =  PRICE_CLOSE;  // Bulls Power price

string    BEARS_Settings        = "=== BEARS Settings ===";
int       BEARSPeriod           =           13;  // Bears Power  period
int       BEARSPrice            =  PRICE_CLOSE;  // Bears Power price

double UP_1, UP_2, UP_3, UP_4, UP_5, UP_6, UP_7, UP_8, UP_9, UP_10;
double UP_11, UP_12, UP_13, UP_14, UP_15, UP_16, UP_17, UP_18, UP_19, UP_20;
double UP_21, UP_22, UP_23, UP_24, UP_25, UP_26, UP_27, UP_28, UP_29, UP_30;
double UP_31, UP_32, UP_33, UP_34, UP_35, UP_36, UP_37, UP_38, UP_39, UP_40;
double UP_41, UP_42, UP_43, UP_44, UP_45, UP_46, UP_47, UP_48, UP_49, UP_50;
double UP_51, UP_52, UP_53, UP_54, UP_55, UP_56, UP_57, UP_58, UP_59, UP_60;
double UP_61, UP_62, UP_63, UP_64;

double DOWN_1, DOWN_2, DOWN_3, DOWN_4, DOWN_5, DOWN_6, DOWN_7, DOWN_8, DOWN_9, DOWN_10;
double DOWN_11, DOWN_12, DOWN_13, DOWN_14, DOWN_15, DOWN_16, DOWN_17, DOWN_18, DOWN_19, DOWN_20;
double DOWN_21, DOWN_22, DOWN_23, DOWN_24, DOWN_25, DOWN_26, DOWN_27, DOWN_28, DOWN_29, DOWN_30;
double DOWN_31, DOWN_32, DOWN_33, DOWN_34, DOWN_35, DOWN_36, DOWN_37, DOWN_38, DOWN_39, DOWN_40;
double DOWN_41, DOWN_42, DOWN_43, DOWN_44, DOWN_45, DOWN_46, DOWN_47, DOWN_48, DOWN_49, DOWN_50;
double DOWN_51, DOWN_52, DOWN_53, DOWN_54, DOWN_55, DOWN_56, DOWN_57, DOWN_58, DOWN_59, DOWN_60;
double DOWN_61, DOWN_62, DOWN_63, DOWN_64;
double balance;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
//--- drawing settings

   if(AccountInfoString(ACCOUNT_COMPANY)=="Horse Forex Ltd")
         {           
                //TextCreate("PASS","Horse Technology @copyright",15,15,10,Red);
                flag=1;
         }
    else {
            Alert("Invaild Broker !");
            Alert("Please Change Account !");
            Alert("Failed Authorization !");
            flag=0;
            return(INIT_FAILED);
         }  
   if(!IsConnected()) 
    {    
         Alert("No Connected !");
         return(0); 
    }else balance= AccountInfoDouble(ACCOUNT_BALANCE);
         
   if(balance>=100.0)
         {            
                //TextCreate("PASS1","Horse Technology @copyright",15,15,10,Red);
                flag=1;
         }
    else {
            Alert("No Enough AccountBalance !");
            Alert("Please Deposit !");
            Alert("Failed Authorization !");
            flag=0;
            return(INIT_FAILED);
         }          
        
//--- name for DataWindow and indicator subwindow label
if(flag){
   IndicatorShortName("MultiChange");
   SetIndexBuffer(0,UPBuffer);
   SetIndexBuffer(1,DOWNBuffer);
//---
//double time_frame=Period();
   string symbol=Symbol();
   ObjectCreate("timeframe", OBJ_LABEL, WindowFind("MultiChange"), 0, 0);
   ObjectSetText("timeframe",symbol,8, "Verdana",PaleGoldenrod);
   ObjectSet("timeframe", OBJPROP_CORNER, 0);
   ObjectSet("timeframe", OBJPROP_XDISTANCE, 6);
   ObjectSet("timeframe", OBJPROP_YDISTANCE, 14);

   ObjectCreate("line1t", OBJ_LABEL, WindowFind("MultiChange"), 0, 0);
   ObjectSetText("line1t","------------------------------------------------------",6, "Verdana", White);
   ObjectSet("line1t", OBJPROP_CORNER, 0);
   ObjectSet("line1t", OBJPROP_XDISTANCE, 6);
   ObjectSet("line1t", OBJPROP_YDISTANCE, 24);
   ObjectCreate("line2t", OBJ_LABEL, WindowFind("MultiChange"), 0, 0);
   ObjectSetText("line2t","-------------------------------------------------------------------------",6, "Verdana", White);
   ObjectSet("line2t", OBJPROP_CORNER, 0);
   ObjectSet("line2t", OBJPROP_XDISTANCE, 221);
   ObjectSet("line2t", OBJPROP_YDISTANCE, 24);
   Comment("Horse Technology @copyright\nhttps://www.horsegroup.net/\nOpen Account: https://secure.horsegroup.net/register/");
}

   return(INIT_SUCCEEDED);
  }
  
  
    void OnDeinit(const int reason)
  {
   //DeleteAll();
   ObjectDelete(0,"PASS");
   ObjectDelete(0,"PASS1");
   ObjectDelete(0,"BACKG");
   
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {
//---
if(flag){
   string text,trendtext;
   color color_indic;
   double askprice=SymbolInfoDouble(NULL,SYMBOL_ASK);
//---day high and low
//        double DayHigh=iHigh(NULL,PERIOD_D1,0);
//       double DayLow=iLow(NULL,PERIOD_D1,0);
//---day change between yesterday close price and current price
   double DayOpen=iOpen(NULL,PERIOD_D1,0);
   double DayClose=iClose(NULL,PERIOD_D1,1);
   double DayPercentage=(askprice-DayClose)/DayClose*100;
   if(DayPercentage>=0)
     {
      color_indic = Lime;
     }
   else
     {
      color_indic = Red;
     }
   ObjectCreate("DayChanget", OBJ_LABEL, WindowFind("MultiChange"), 0, 0);
   text=StringConcatenate("Day: ",DoubleToString(DayPercentage,2)," %");
   ObjectSetText("DayChanget",text,9, "Verdana", color_indic);
   ObjectSet("DayChanget", OBJPROP_CORNER, 0);
   ObjectSet("DayChanget", OBJPROP_XDISTANCE, 90);
   ObjectSet("DayChanget", OBJPROP_YDISTANCE, 13);
//---week change
   double WeekOpen=iOpen(NULL,PERIOD_W1,0);
   double WeekClose=iClose(NULL,PERIOD_W1,1);
   double WeekPercentage=(askprice-WeekOpen)/WeekClose*100;
   if(WeekPercentage>=0)
     {
      color_indic = Lime;
     }
   else
     {
      color_indic = Red;
     }
   ObjectCreate("WeekChanget", OBJ_LABEL, WindowFind("MultiChange"), 0, 0);
   text=StringConcatenate("Week: ",DoubleToString(WeekPercentage,2)," %");
   ObjectSetText("WeekChanget",text,9, "Verdana", color_indic);
   ObjectSet("WeekChanget", OBJPROP_CORNER, 0);
   ObjectSet("WeekChanget", OBJPROP_XDISTANCE, 189);
   ObjectSet("WeekChanget", OBJPROP_YDISTANCE, 13);
//---Month change
   double MonthOpen=iOpen(NULL,PERIOD_MN1,0);
   double MonthClose=iClose(NULL,PERIOD_MN1,1);
   double MonthPercentage=(askprice-MonthOpen)/WeekClose*100;
   if(MonthPercentage>=0)
     {
      color_indic = Lime;
     }
   else
     {
      color_indic = Red;
     }
   ObjectCreate("MonthChanget", OBJ_LABEL, WindowFind("MultiChange"), 0, 0);
   text=StringConcatenate("Month: ",DoubleToString(MonthPercentage,2)," %");
   ObjectSetText("MonthChanget",text,9, "Verdana", color_indic);
   ObjectSet("MonthChanget", OBJPROP_CORNER, 0);
   ObjectSet("MonthChanget", OBJPROP_XDISTANCE, 290);
   ObjectSet("MonthChanget", OBJPROP_YDISTANCE, 13);

//+------------------------------------------------------------------+
   color color_common_line = White;
   color color_common_text = White;
   color color_tf = PaleGoldenrod;

   ObjectCreate("m1", OBJ_LABEL, WindowFind("MultiChange"), 0, 0);
   ObjectSetText("m1","M1",9, "Verdana", color_tf);
   ObjectSet("m1", OBJPROP_CORNER, 0);
   ObjectSet("m1", OBJPROP_XDISTANCE, 6);
   ObjectSet("m1", OBJPROP_YDISTANCE, 40);

   ObjectCreate("m5", OBJ_LABEL, WindowFind("MultiChange"), 0, 0);
   ObjectSetText("m5","M5",9, "Verdana", color_tf);
   ObjectSet("m5", OBJPROP_CORNER, 0);
   ObjectSet("m5", OBJPROP_XDISTANCE, 6);
   ObjectSet("m5", OBJPROP_YDISTANCE, 53);

   ObjectCreate("m15", OBJ_LABEL, WindowFind("MultiChange"), 0, 0);
   ObjectSetText("m15","M15",9, "Verdana", color_tf);
   ObjectSet("m15", OBJPROP_CORNER, 0);
   ObjectSet("m15", OBJPROP_XDISTANCE, 6);
   ObjectSet("m15", OBJPROP_YDISTANCE,67);

   ObjectCreate("m30", OBJ_LABEL, WindowFind("MultiChange"), 0, 0);
   ObjectSetText("m30","M30",9, "Verdana", color_tf);
   ObjectSet("m30", OBJPROP_CORNER, 0);
   ObjectSet("m30", OBJPROP_XDISTANCE, 6);
   ObjectSet("m30", OBJPROP_YDISTANCE,82);

   ObjectCreate("h1", OBJ_LABEL, WindowFind("MultiChange"), 0, 0);
   ObjectSetText("h1","H1",9, "Verdana", color_tf);
   ObjectSet("h1", OBJPROP_CORNER, 0);
   ObjectSet("h1", OBJPROP_XDISTANCE, 6);
   ObjectSet("h1", OBJPROP_YDISTANCE,97);

   ObjectCreate("h4", OBJ_LABEL, WindowFind("MultiChange"), 0, 0);
   ObjectSetText("h4","H4",9, "Verdana", color_tf);
   ObjectSet("h4", OBJPROP_CORNER, 0);
   ObjectSet("h4", OBJPROP_XDISTANCE, 6);
   ObjectSet("h4", OBJPROP_YDISTANCE,112);

   ObjectCreate("d1", OBJ_LABEL, WindowFind("MultiChange"), 0, 0);
   ObjectSetText("d1","D1",9, "Verdana", color_tf);
   ObjectSet("d1", OBJPROP_CORNER, 0);
   ObjectSet("d1", OBJPROP_XDISTANCE, 6);
   ObjectSet("d1", OBJPROP_YDISTANCE,127);

   ObjectCreate("w1", OBJ_LABEL, WindowFind("MultiChange"), 0, 0);
   ObjectSetText("w1","W1",9, "Verdana", color_tf);
   ObjectSet("w1", OBJPROP_CORNER, 0);
   ObjectSet("w1", OBJPROP_XDISTANCE, 6);
   ObjectSet("w1", OBJPROP_YDISTANCE, 142);

// Shift calculation for indicators (tests only)

   double shift_1, shift_5, shift_15, shift_30, shift_60, shift_240, shift_1440, shift_10080;

// Indicator (Moving Average)

   color color_ind = PowderBlue;
   string MAfast_Trend_1, MAfast_Trend_5, MAfast_Trend_15, MAfast_Trend_30, MAfast_Trend_60, MAfast_Trend_240, MAfast_Trend_1440, MAfast_Trend_10080;
   string MAmedium_Trend_1, MAmedium_Trend_5, MAmedium_Trend_15, MAmedium_Trend_30, MAmedium_Trend_60, MAmedium_Trend_240, MAmedium_Trend_1440, MAmedium_Trend_10080;
   string MAslow_Trend_1, MAslow_Trend_5, MAslow_Trend_15, MAslow_Trend_30, MAslow_Trend_60, MAslow_Trend_240, MAslow_Trend_1440, MAslow_Trend_10080;
   double x;

// FAST
   ObjectCreate("mafast", OBJ_LABEL, WindowFind("MultiChange"), 0, 0);
   ObjectSetText("mafast","MA"+DoubleToStr(FastMAPeriod,0),8, "Verdana", color_ind);
   ObjectSet("mafast", OBJPROP_CORNER, 0);
   ObjectSet("mafast", OBJPROP_XDISTANCE, 41);
   ObjectSet("mafast", OBJPROP_YDISTANCE, 30);

   double FastMA_1_1 = iMA(NULL,PERIOD_M1,FastMAPeriod,0,MAMethod,MAPrice,shift_1);
   double FastMA_2_1 = iMA(NULL,PERIOD_M1,FastMAPeriod,0,MAMethod,MAPrice,shift_1+1);

   if((FastMA_1_1 > FastMA_2_1))
     {
      MAfast_Trend_1 = "多";
      x = 50;
      color_indic = Lime;
      UP_1 = 1;
      DOWN_1 = 0;
     }
   if((FastMA_1_1 < FastMA_2_1))
     {
      MAfast_Trend_1 = "空";
      x = 50;
      color_indic = Red;
      UP_1 = 0;
      DOWN_1 = 1;
     }
   ObjectCreate("Trend_MAfast_1", OBJ_LABEL, WindowFind("MultiChange"), 0, 0);
   ObjectSetText("Trend_MAfast_1",MAfast_Trend_1,8, "Verdana", color_indic);
   ObjectSet("Trend_MAfast_1", OBJPROP_CORNER, 0);
   ObjectSet("Trend_MAfast_1", OBJPROP_XDISTANCE, x);
   ObjectSet("Trend_MAfast_1", OBJPROP_YDISTANCE,41);

   double FastMA_1_5 = iMA(NULL,PERIOD_M5,FastMAPeriod,0,MAMethod,MAPrice,shift_5);
   double FastMA_2_5 = iMA(NULL,PERIOD_M5,FastMAPeriod,0,MAMethod,MAPrice,shift_5+1);

   if((FastMA_1_5 > FastMA_2_5))
     {
      MAfast_Trend_5 = "多";
      x = 50;
      color_indic = Lime;
      UP_2 = 1;
      DOWN_2 = 0;
     }
   if((FastMA_1_5 < FastMA_2_5))
     {
      MAfast_Trend_5 = "空";
      x = 50;
      color_indic = Red;
      UP_2 = 0;
      DOWN_2 = 1;
     }
   ObjectCreate("Trend_MAfast_5", OBJ_LABEL, WindowFind("MultiChange"), 0, 0);
   ObjectSetText("Trend_MAfast_5",MAfast_Trend_5,8, "Verdana", color_indic);
   ObjectSet("Trend_MAfast_5", OBJPROP_CORNER, 0);
   ObjectSet("Trend_MAfast_5", OBJPROP_XDISTANCE, x);
   ObjectSet("Trend_MAfast_5", OBJPROP_YDISTANCE,54);

   double FastMA_1_15 = iMA(NULL,PERIOD_M15,FastMAPeriod,0,MAMethod,MAPrice,shift_15);
   double FastMA_2_15 = iMA(NULL,PERIOD_M15,FastMAPeriod,0,MAMethod,MAPrice,shift_15+1);

   if((FastMA_1_15 > FastMA_2_15))
     {
      MAfast_Trend_15 = "多";
      x = 50;
      color_indic = Lime;
      UP_3 = 1;
      DOWN_3 = 0;
     }
   if((FastMA_1_15 < FastMA_2_15))
     {
      MAfast_Trend_15 = "空";
      x = 50;
      color_indic = Red;
      UP_3 = 0;
      DOWN_3 = 1;
     }
   ObjectCreate("Trend_MAfast_15", OBJ_LABEL, WindowFind("MultiChange"), 0, 0);
   ObjectSetText("Trend_MAfast_15",MAfast_Trend_15,8, "Verdana", color_indic);
   ObjectSet("Trend_MAfast_15", OBJPROP_CORNER, 0);
   ObjectSet("Trend_MAfast_15", OBJPROP_XDISTANCE, x);
   ObjectSet("Trend_MAfast_15", OBJPROP_YDISTANCE,68);

   double FastMA_1_30 = iMA(NULL,PERIOD_M30,FastMAPeriod,0,MAMethod,MAPrice,shift_30);
   double FastMA_2_30 = iMA(NULL,PERIOD_M30,FastMAPeriod,0,MAMethod,MAPrice,shift_30+1);

   if((FastMA_1_30 > FastMA_2_30))
     {
      MAfast_Trend_30 = "多";
      x = 50;
      color_indic = Lime;
      UP_4 = 1;
      DOWN_4 = 0;
     }
   if((FastMA_1_30 < FastMA_2_30))
     {
      MAfast_Trend_30 = "空";
      x = 50;
      color_indic = Red;
      UP_4 = 0;
      DOWN_4 = 1;
     }
   ObjectCreate("Trend_MAfast_30", OBJ_LABEL, WindowFind("MultiChange"), 0, 0);
   ObjectSetText("Trend_MAfast_30",MAfast_Trend_30,8, "Verdana", color_indic);
   ObjectSet("Trend_MAfast_30", OBJPROP_CORNER, 0);
   ObjectSet("Trend_MAfast_30", OBJPROP_XDISTANCE, x);
   ObjectSet("Trend_MAfast_30", OBJPROP_YDISTANCE,83);

   double FastMA_1_60 = iMA(NULL,PERIOD_H1,FastMAPeriod,0,MAMethod,MAPrice,shift_60);
   double FastMA_2_60 = iMA(NULL,PERIOD_H1,FastMAPeriod,0,MAMethod,MAPrice,shift_60+1);

   if((FastMA_1_60 > FastMA_2_60))
     {
      MAfast_Trend_60 = "多";
      x = 50;
      color_indic = Lime;
      UP_5 = 1;
      DOWN_5 = 0;
     }
   if((FastMA_1_60 < FastMA_2_60))
     {
      MAfast_Trend_60 = "空";
      x = 50;
      color_indic = Red;
      UP_5 = 0;
      DOWN_5 = 1;
     }
   ObjectCreate("Trend_MAfast_60", OBJ_LABEL, WindowFind("MultiChange"), 0, 0);
   ObjectSetText("Trend_MAfast_60",MAfast_Trend_60,8, "Verdana", color_indic);
   ObjectSet("Trend_MAfast_60", OBJPROP_CORNER, 0);
   ObjectSet("Trend_MAfast_60", OBJPROP_XDISTANCE, x);
   ObjectSet("Trend_MAfast_60", OBJPROP_YDISTANCE,98);

   double FastMA_1_240 = iMA(NULL,PERIOD_H4,FastMAPeriod,0,MAMethod,MAPrice,shift_240);
   double FastMA_2_240 = iMA(NULL,PERIOD_H4,FastMAPeriod,0,MAMethod,MAPrice,shift_240+1);

   if((FastMA_1_240 > FastMA_2_240))
     {
      MAfast_Trend_240 = "多";
      x = 50;
      color_indic = Lime;
      UP_6 = 1;
      DOWN_6 = 0;
     }
   if((FastMA_1_240 < FastMA_2_240))
     {
      MAfast_Trend_240 = "空";
      x = 50;
      color_indic = Red;
      UP_6 = 0;
      DOWN_6 = 1;
     }
   ObjectCreate("Trend_MAfast_240", OBJ_LABEL, WindowFind("MultiChange"), 0, 0);
   ObjectSetText("Trend_MAfast_240",MAfast_Trend_240,8, "Verdana", color_indic);
   ObjectSet("Trend_MAfast_240", OBJPROP_CORNER, 0);
   ObjectSet("Trend_MAfast_240", OBJPROP_XDISTANCE, x);
   ObjectSet("Trend_MAfast_240", OBJPROP_YDISTANCE,113);

   double FastMA_1_1440 = iMA(NULL,PERIOD_D1,FastMAPeriod,0,MAMethod,MAPrice,shift_1440);
   double FastMA_2_1440 = iMA(NULL,PERIOD_D1,FastMAPeriod,0,MAMethod,MAPrice,shift_1440+1);

   if((FastMA_1_1440 > FastMA_2_1440))
     {
      MAfast_Trend_1440 = "多";
      x = 50;
      color_indic = Lime;
      UP_7 = 1;
      DOWN_7 = 0;
     }
   if((FastMA_1_1440 < FastMA_2_1440))
     {
      MAfast_Trend_1440 = "空";
      x = 50;
      color_indic = Red;
      UP_7 = 0;
      DOWN_7 = 1;
     }
   ObjectCreate("Trend_MAfast_1440", OBJ_LABEL, WindowFind("MultiChange"), 0, 0);
   ObjectSetText("Trend_MAfast_1440",MAfast_Trend_1440,8, "Verdana", color_indic);
   ObjectSet("Trend_MAfast_1440", OBJPROP_CORNER, 0);
   ObjectSet("Trend_MAfast_1440", OBJPROP_XDISTANCE, x);
   ObjectSet("Trend_MAfast_1440", OBJPROP_YDISTANCE,128);

   double FastMA_1_10080 = iMA(NULL,PERIOD_W1,FastMAPeriod,0,MAMethod,MAPrice,shift_10080);
   double FastMA_2_10080 = iMA(NULL,PERIOD_W1,FastMAPeriod,0,MAMethod,MAPrice,shift_10080+1);

   if((FastMA_1_10080 > FastMA_2_10080))
     {
      MAfast_Trend_10080 = "多";
      x = 50;
      color_indic = Lime;
      UP_8 = 1;
      DOWN_8 = 0;
     }
   if((FastMA_1_10080 < FastMA_2_10080))
     {
      MAfast_Trend_10080 = "空";
      x = 50;
      color_indic = Red;
      UP_8 = 0;
      DOWN_8 = 1;
     }
   ObjectCreate("Trend_MAfast_10080", OBJ_LABEL, WindowFind("MultiChange"), 0, 0);
   ObjectSetText("Trend_MAfast_10080",MAfast_Trend_10080,8, "Verdana", color_indic);
   ObjectSet("Trend_MAfast_10080", OBJPROP_CORNER, 0);
   ObjectSet("Trend_MAfast_10080", OBJPROP_XDISTANCE, x);
   ObjectSet("Trend_MAfast_10080", OBJPROP_YDISTANCE,143);

// MEDIUM

   double m;
   if(MediumMAPeriod < 10)
     {
      m=260;
     }
   if(MediumMAPeriod >= 10)
     {
      m=90;
     }
   if(MediumMAPeriod >= 100)
     {
      m=252;
     }

   ObjectCreate("mamedium", OBJ_LABEL, WindowFind("MultiChange"), 0, 0);
   ObjectSetText("mamedium","MA"+DoubleToStr(MediumMAPeriod,0),8, "Verdana", color_ind);
   ObjectSet("mamedium", OBJPROP_CORNER, 0);
   ObjectSet("mamedium", OBJPROP_XDISTANCE, m);
   ObjectSet("mamedium", OBJPROP_YDISTANCE, 29);

   double MediumMA_1_1 = iMA(NULL,PERIOD_M1,MediumMAPeriod,0,MAMethod,MAPrice,shift_1);
   double MediumMA_2_1 = iMA(NULL,PERIOD_M1,MediumMAPeriod,0,MAMethod,MAPrice,shift_1+1);

   if((MediumMA_1_1 > MediumMA_2_1))
     {
      MAmedium_Trend_1 = "多";
      x = 100;
      color_indic = Lime;
      UP_9 = 1;
      DOWN_9 = 0;
     }
   if((MediumMA_1_1 < MediumMA_2_1))
     {
      MAmedium_Trend_1 = "空";
      x = 100;
      color_indic = Red;
      UP_9 = 0;
      DOWN_9 = 1;
     }
   ObjectCreate("Trend_MAmedium_1", OBJ_LABEL, WindowFind("MultiChange"), 0, 0);
   ObjectSetText("Trend_MAmedium_1",MAmedium_Trend_1,8, "Verdana", color_indic);
   ObjectSet("Trend_MAmedium_1", OBJPROP_CORNER, 0);
   ObjectSet("Trend_MAmedium_1", OBJPROP_XDISTANCE, x);
   ObjectSet("Trend_MAmedium_1", OBJPROP_YDISTANCE,41);

   double MediumMA_1_5 = iMA(NULL,PERIOD_M5,MediumMAPeriod,0,MAMethod,MAPrice,shift_5);
   double MediumMA_2_5 = iMA(NULL,PERIOD_M5,MediumMAPeriod,0,MAMethod,MAPrice,shift_5+1);

   if((MediumMA_1_5 > MediumMA_2_5))
     {
      MAmedium_Trend_5 = "多";
      x = 100;
      color_indic = Lime;
      UP_10 = 1;
      DOWN_10 = 0;
     }
   if((MediumMA_1_5 < MediumMA_2_5))
     {
      MAmedium_Trend_5 = "空";
      x = 100;
      color_indic = Red;
      UP_10 = 0;
      DOWN_10 = 1;
     }
   ObjectCreate("Trend_MAmedium_5", OBJ_LABEL, WindowFind("MultiChange"), 0, 0);
   ObjectSetText("Trend_MAmedium_5",MAmedium_Trend_5,8, "Verdana", color_indic);
   ObjectSet("Trend_MAmedium_5", OBJPROP_CORNER, 0);
   ObjectSet("Trend_MAmedium_5", OBJPROP_XDISTANCE, x);
   ObjectSet("Trend_MAmedium_5", OBJPROP_YDISTANCE,54);

   double MediumMA_1_15 = iMA(NULL,PERIOD_M15,MediumMAPeriod,0,MAMethod,MAPrice,shift_15);
   double MediumMA_2_15 = iMA(NULL,PERIOD_M15,MediumMAPeriod,0,MAMethod,MAPrice,shift_15+1);

   if((MediumMA_1_15 > MediumMA_2_15))
     {
      MAmedium_Trend_15 = "多";
      x = 100;
      color_indic = Lime;
      UP_11 = 1;
      DOWN_11 = 0;
     }
   if((MediumMA_1_15 < MediumMA_2_15))
     {
      MAmedium_Trend_15 = "空";
      x = 100;
      color_indic = Red;
      UP_11 = 0;
      DOWN_11 = 1;
     }
   ObjectCreate("Trend_MAmedium_15", OBJ_LABEL, WindowFind("MultiChange"), 0, 0);
   ObjectSetText("Trend_MAmedium_15",MAmedium_Trend_15,8, "Verdana", color_indic);
   ObjectSet("Trend_MAmedium_15", OBJPROP_CORNER, 0);
   ObjectSet("Trend_MAmedium_15", OBJPROP_XDISTANCE, x);
   ObjectSet("Trend_MAmedium_15", OBJPROP_YDISTANCE,68);

   double MediumMA_1_30 = iMA(NULL,PERIOD_M30,MediumMAPeriod,0,MAMethod,MAPrice,shift_30);
   double MediumMA_2_30 = iMA(NULL,PERIOD_M30,MediumMAPeriod,0,MAMethod,MAPrice,shift_30+1);

   if((MediumMA_1_30 > MediumMA_2_30))
     {
      MAmedium_Trend_30 = "多";
      x = 100;
      color_indic = Lime;
      UP_12 = 1;
      DOWN_12 = 0;
     }
   if((MediumMA_1_30 < MediumMA_2_30))
     {
      MAmedium_Trend_30 = "空";
      x = 100;
      color_indic = Red;
      UP_12 = 0;
      DOWN_12 = 1;
     }
   ObjectCreate("Trend_MAmedium_30", OBJ_LABEL, WindowFind("MultiChange"), 0, 0);
   ObjectSetText("Trend_MAmedium_30",MAmedium_Trend_30,8, "Verdana", color_indic);
   ObjectSet("Trend_MAmedium_30", OBJPROP_CORNER, 0);
   ObjectSet("Trend_MAmedium_30", OBJPROP_XDISTANCE, x);
   ObjectSet("Trend_MAmedium_30", OBJPROP_YDISTANCE,83);

   double MediumMA_1_60 = iMA(NULL,PERIOD_H1,MediumMAPeriod,0,MAMethod,MAPrice,shift_60);
   double MediumMA_2_60 = iMA(NULL,PERIOD_H1,MediumMAPeriod,0,MAMethod,MAPrice,shift_60+1);

   if((MediumMA_1_60 > MediumMA_2_60))
     {
      MAmedium_Trend_60 = "多";
      x = 100;
      color_indic = Lime;
      UP_13 = 1;
      DOWN_13 = 0;
     }
   if((MediumMA_1_60 < MediumMA_2_60))
     {
      MAmedium_Trend_60 = "空";
      x = 100;
      color_indic = Red;
      UP_13 = 0;
      DOWN_13 = 1;
     }
   ObjectCreate("Trend_MAmedium_60", OBJ_LABEL, WindowFind("MultiChange"), 0, 0);
   ObjectSetText("Trend_MAmedium_60",MAmedium_Trend_60,8, "Verdana", color_indic);
   ObjectSet("Trend_MAmedium_60", OBJPROP_CORNER, 0);
   ObjectSet("Trend_MAmedium_60", OBJPROP_XDISTANCE, x);
   ObjectSet("Trend_MAmedium_60", OBJPROP_YDISTANCE,98);

   double MediumMA_1_240 = iMA(NULL,PERIOD_H4,MediumMAPeriod,0,MAMethod,MAPrice,shift_240);
   double MediumMA_2_240 = iMA(NULL,PERIOD_H4,MediumMAPeriod,0,MAMethod,MAPrice,shift_240+1);

   if((MediumMA_1_240 > MediumMA_2_240))
     {
      MAmedium_Trend_240 = "多";
      x = 100;
      color_indic = Lime;
      UP_14 = 1;
      DOWN_14 = 0;
     }
   if((MediumMA_1_240 < MediumMA_2_240))
     {
      MAmedium_Trend_240 = "空";
      x = 100;
      color_indic = Red;
      UP_14 = 0;
      DOWN_14 = 1;
     }
   ObjectCreate("Trend_MAmedium_240", OBJ_LABEL, WindowFind("MultiChange"), 0, 0);
   ObjectSetText("Trend_MAmedium_240",MAmedium_Trend_240,8, "Verdana", color_indic);
   ObjectSet("Trend_MAmedium_240", OBJPROP_CORNER, 0);
   ObjectSet("Trend_MAmedium_240", OBJPROP_XDISTANCE, x);
   ObjectSet("Trend_MAmedium_240", OBJPROP_YDISTANCE,113);

   double MediumMA_1_1440 = iMA(NULL,PERIOD_D1,MediumMAPeriod,0,MAMethod,MAPrice,shift_1440);
   double MediumMA_2_1440 = iMA(NULL,PERIOD_D1,MediumMAPeriod,0,MAMethod,MAPrice,shift_1440+1);

   if((MediumMA_1_1440 > MediumMA_2_1440))
     {
      MAmedium_Trend_1440 = "多";
      x = 100;
      color_indic = Lime;
      UP_15 = 1;
      DOWN_15 = 0;
     }
   if((MediumMA_1_1440 < MediumMA_2_1440))
     {
      MAmedium_Trend_1440 = "空";
      x = 100;
      color_indic = Red;
      UP_15 = 0;
      DOWN_15 = 1;
     }
   ObjectCreate("Trend_MAmedium_1440", OBJ_LABEL, WindowFind("MultiChange"), 0, 0);
   ObjectSetText("Trend_MAmedium_1440",MAmedium_Trend_1440,8, "Verdana", color_indic);
   ObjectSet("Trend_MAmedium_1440", OBJPROP_CORNER, 0);
   ObjectSet("Trend_MAmedium_1440", OBJPROP_XDISTANCE, x);
   ObjectSet("Trend_MAmedium_1440", OBJPROP_YDISTANCE,128);

   double MediumMA_1_10080 = iMA(NULL,PERIOD_W1,MediumMAPeriod,0,MAMethod,MAPrice,shift_10080);
   double MediumMA_2_10080 = iMA(NULL,PERIOD_W1,MediumMAPeriod,0,MAMethod,MAPrice,shift_10080+1);

   if((MediumMA_1_10080 > MediumMA_2_10080))
     {
      MAmedium_Trend_10080 = "多";
      x = 100;
      color_indic = Lime;
      UP_16 = 1;
      DOWN_16 = 0;
     }
   if((MediumMA_1_10080 < MediumMA_2_10080))
     {
      MAmedium_Trend_10080 = "空";
      x = 100;
      color_indic = Red;
      UP_16 = 0;
      DOWN_16 = 1;
     }
   ObjectCreate("Trend_MAmedium_10080", OBJ_LABEL, WindowFind("MultiChange"), 0, 0);
   ObjectSetText("Trend_MAmedium_10080",MAmedium_Trend_10080,8, "Verdana", color_indic);
   ObjectSet("Trend_MAmedium_10080", OBJPROP_CORNER, 0);
   ObjectSet("Trend_MAmedium_10080", OBJPROP_XDISTANCE, x);
   ObjectSet("Trend_MAmedium_10080", OBJPROP_YDISTANCE,143);

// SLOW

   double n;
   if(SlowMAPeriod < 10)
     {
      n=310;
     }
   if(SlowMAPeriod >= 10)
     {
      n=140;
     }
   if(SlowMAPeriod >= 100)
     {
      n=302;
     }

   ObjectCreate("maslow", OBJ_LABEL, WindowFind("MultiChange"), 0, 0);
   ObjectSetText("maslow","MA"+DoubleToStr(SlowMAPeriod,0),8, "Verdana", color_ind);
   ObjectSet("maslow", OBJPROP_CORNER, 0);
   ObjectSet("maslow", OBJPROP_XDISTANCE, 140);
   ObjectSet("maslow", OBJPROP_YDISTANCE, 29);

   double SlowMA_1_1 = iMA(NULL,PERIOD_M1,SlowMAPeriod,0,MAMethod,MAPrice,shift_1);
   double SlowMA_2_1 = iMA(NULL,PERIOD_M1,SlowMAPeriod,0,MAMethod,MAPrice,shift_1+1);

   if((SlowMA_1_1 > SlowMA_2_1))
     {
      MAslow_Trend_1 = "多";
      x = 150;
      color_indic = Lime;
      UP_17 = 1;
      DOWN_17 = 0;
     }
   if((SlowMA_1_1 < SlowMA_2_1))
     {
      MAslow_Trend_1 = "空";
      x = 150;
      color_indic = Red;
      UP_17 = 0;
      DOWN_17 = 1;
     }
   ObjectCreate("Trend_MAslow_1", OBJ_LABEL, WindowFind("MultiChange"), 0, 0);
   ObjectSetText("Trend_MAslow_1",MAslow_Trend_1,8, "Verdana", color_indic);
   ObjectSet("Trend_MAslow_1", OBJPROP_CORNER, 0);
   ObjectSet("Trend_MAslow_1", OBJPROP_XDISTANCE, x);
   ObjectSet("Trend_MAslow_1", OBJPROP_YDISTANCE,41);

   double SlowMA_1_5 = iMA(NULL,PERIOD_M5,SlowMAPeriod,0,MAMethod,MAPrice,shift_5);
   double SlowMA_2_5 = iMA(NULL,PERIOD_M5,SlowMAPeriod,0,MAMethod,MAPrice,shift_5+1);

   if((SlowMA_1_5 > SlowMA_2_5))
     {
      MAslow_Trend_5 = "多";
      x = 150;
      color_indic = Lime;
      UP_18 = 1;
      DOWN_18 = 0;
     }
   if((SlowMA_1_5 < SlowMA_2_5))
     {
      MAslow_Trend_5 = "空";
      x = 150;
      color_indic = Red;
      UP_18 = 0;
      DOWN_18 = 1;
     }
   ObjectCreate("Trend_MAslow_5", OBJ_LABEL, WindowFind("MultiChange"), 0, 0);
   ObjectSetText("Trend_MAslow_5",MAslow_Trend_5,8, "Verdana", color_indic);
   ObjectSet("Trend_MAslow_5", OBJPROP_CORNER, 0);
   ObjectSet("Trend_MAslow_5", OBJPROP_XDISTANCE, x);
   ObjectSet("Trend_MAslow_5", OBJPROP_YDISTANCE,54);

   double SlowMA_1_15 = iMA(NULL,PERIOD_M15,SlowMAPeriod,0,MAMethod,MAPrice,shift_15);
   double SlowMA_2_15 = iMA(NULL,PERIOD_M15,SlowMAPeriod,0,MAMethod,MAPrice,shift_15+1);

   if((SlowMA_1_15 > SlowMA_2_15))
     {
      MAslow_Trend_15 = "多";
      x = 150;
      color_indic = Lime;
      UP_19 = 1;
      DOWN_19 = 0;
     }
   if((SlowMA_1_15 < SlowMA_2_15))
     {
      MAslow_Trend_15 = "空";
      x = 150;
      color_indic = Red;
      UP_19 = 0;
      DOWN_19 = 1;
     }
   ObjectCreate("Trend_MAslow_15", OBJ_LABEL, WindowFind("MultiChange"), 0, 0);
   ObjectSetText("Trend_MAslow_15",MAslow_Trend_15,8, "Verdana", color_indic);
   ObjectSet("Trend_MAslow_15", OBJPROP_CORNER, 0);
   ObjectSet("Trend_MAslow_15", OBJPROP_XDISTANCE, x);
   ObjectSet("Trend_MAslow_15", OBJPROP_YDISTANCE,68);

   double SlowMA_1_30 = iMA(NULL,PERIOD_M30,SlowMAPeriod,0,MAMethod,MAPrice,shift_30);
   double SlowMA_2_30 = iMA(NULL,PERIOD_M30,SlowMAPeriod,0,MAMethod,MAPrice,shift_30+1);

   if((SlowMA_1_30 > SlowMA_2_30))
     {
      MAslow_Trend_30 = "多";
      x = 150;
      color_indic = Lime;
      UP_20 = 1;
      DOWN_20 = 0;
     }
   if((SlowMA_1_30 < SlowMA_2_30))
     {
      MAslow_Trend_30 = "空";
      x = 150;
      color_indic = Red;
      UP_20 = 0;
      DOWN_20 = 1;
     }
   ObjectCreate("Trend_MAslow_30", OBJ_LABEL, WindowFind("MultiChange"), 0, 0);
   ObjectSetText("Trend_MAslow_30",MAslow_Trend_30,8, "Verdana", color_indic);
   ObjectSet("Trend_MAslow_30", OBJPROP_CORNER, 0);
   ObjectSet("Trend_MAslow_30", OBJPROP_XDISTANCE, x);
   ObjectSet("Trend_MAslow_30", OBJPROP_YDISTANCE,83);

   double SlowMA_1_60 = iMA(NULL,PERIOD_H1,SlowMAPeriod,0,MAMethod,MAPrice,shift_60);
   double SlowMA_2_60 = iMA(NULL,PERIOD_H1,SlowMAPeriod,0,MAMethod,MAPrice,shift_60+1);

   if((SlowMA_1_60 > SlowMA_2_60))
     {
      MAslow_Trend_60 = "多";
      x = 150;
      color_indic = Lime;
      UP_21 = 1;
      DOWN_21 = 0;
     }
   if((SlowMA_1_60 < SlowMA_2_60))
     {
      MAslow_Trend_60 = "空";
      x = 150;
      color_indic = Red;
      UP_21 = 0;
      DOWN_21 = 1;
     }
   ObjectCreate("Trend_MAslow_60", OBJ_LABEL, WindowFind("MultiChange"), 0, 0);
   ObjectSetText("Trend_MAslow_60",MAslow_Trend_60,8, "Verdana", color_indic);
   ObjectSet("Trend_MAslow_60", OBJPROP_CORNER, 0);
   ObjectSet("Trend_MAslow_60", OBJPROP_XDISTANCE, x);
   ObjectSet("Trend_MAslow_60", OBJPROP_YDISTANCE,98);

   double SlowMA_1_240 = iMA(NULL,PERIOD_H4,SlowMAPeriod,0,MAMethod,MAPrice,shift_240);
   double SlowMA_2_240 = iMA(NULL,PERIOD_H4,SlowMAPeriod,0,MAMethod,MAPrice,shift_240+1);

   if((SlowMA_1_240 > SlowMA_2_240))
     {
      MAslow_Trend_240 = "多";
      x = 150;
      color_indic = Lime;
      UP_22 = 1;
      DOWN_22 = 0;
     }
   if((SlowMA_1_240 < SlowMA_2_240))
     {
      MAslow_Trend_240 = "空";
      x = 150;
      color_indic = Red;
      UP_22 = 0;
      DOWN_22 = 1;
     }
   ObjectCreate("Trend_MAslow_240", OBJ_LABEL, WindowFind("MultiChange"), 0, 0);
   ObjectSetText("Trend_MAslow_240",MAslow_Trend_240,8, "Verdana", color_indic);
   ObjectSet("Trend_MAslow_240", OBJPROP_CORNER, 0);
   ObjectSet("Trend_MAslow_240", OBJPROP_XDISTANCE, x);
   ObjectSet("Trend_MAslow_240", OBJPROP_YDISTANCE,113);

   double SlowMA_1_1440 = iMA(NULL,PERIOD_D1,SlowMAPeriod,0,MAMethod,MAPrice,shift_1440);
   double SlowMA_2_1440 = iMA(NULL,PERIOD_D1,SlowMAPeriod,0,MAMethod,MAPrice,shift_1440+1);

   if((SlowMA_1_1440 > SlowMA_2_1440))
     {
      MAslow_Trend_1440 = "多";
      x = 150;
      color_indic = Lime;
      UP_23 = 1;
      DOWN_23 = 0;
     }
   if((SlowMA_1_1440 < SlowMA_2_1440))
     {
      MAslow_Trend_1440 = "空";
      x = 150;
      color_indic = Red;
      UP_23 = 0;
      DOWN_23 = 1;
     }
   ObjectCreate("Trend_MAslow_1440", OBJ_LABEL, WindowFind("MultiChange"), 0, 0);
   ObjectSetText("Trend_MAslow_1440",MAslow_Trend_1440,8, "Verdana", color_indic);
   ObjectSet("Trend_MAslow_1440", OBJPROP_CORNER, 0);
   ObjectSet("Trend_MAslow_1440", OBJPROP_XDISTANCE, x);
   ObjectSet("Trend_MAslow_1440", OBJPROP_YDISTANCE,128);

   double SlowMA_1_10080 = iMA(NULL,PERIOD_W1,SlowMAPeriod,0,MAMethod,MAPrice,shift_10080);
   double SlowMA_2_10080 = iMA(NULL,PERIOD_W1,SlowMAPeriod,0,MAMethod,MAPrice,shift_10080+1);

   if((SlowMA_1_10080 > SlowMA_2_10080))
     {
      MAslow_Trend_10080 = "多";
      x = 150;
      color_indic = Lime;
      UP_24 = 1;
      DOWN_24 = 0;
     }
   if((SlowMA_1_10080 < SlowMA_2_10080))
     {
      MAslow_Trend_10080 = "空";
      x = 150;
      color_indic = Red;
      UP_24 = 0;
      DOWN_24 = 1;
     }
   ObjectCreate("Trend_MAslow_10080", OBJ_LABEL, WindowFind("MultiChange"), 0, 0);
   ObjectSetText("Trend_MAslow_10080",MAslow_Trend_10080,8, "Verdana", color_indic);
   ObjectSet("Trend_MAslow_10080", OBJPROP_CORNER, 0);
   ObjectSet("Trend_MAslow_10080", OBJPROP_XDISTANCE, x);
   ObjectSet("Trend_MAslow_10080", OBJPROP_YDISTANCE,143);

// Indicator (CCI)

   ObjectCreate("cci", OBJ_LABEL, WindowFind("MultiChange"), 0, 0);
   ObjectSetText("cci","CCI"+DoubleToStr(CCIPeriod,0),8, "Verdana", color_ind);
   ObjectSet("cci", OBJPROP_CORNER, 0);
   ObjectSet("cci", OBJPROP_XDISTANCE, 190);
   ObjectSet("cci", OBJPROP_YDISTANCE, 29);

   string CCI_Trend_1, CCI_Trend_5, CCI_Trend_15, CCI_Trend_30, CCI_Trend_60, CCI_Trend_240, CCI_Trend_1440, CCI_Trend_10080;

   double CCI_1=iCCI(NULL,PERIOD_M1,CCIPeriod,CCIPrice,shift_1);

   if((CCI_1 > 0))
     {
      CCI_Trend_1 = "多";
      x = 200;
      color_indic = Lime;
      UP_25 = 1;
      DOWN_25 = 0;
     }
   if((CCI_1 < 0))
     {
      CCI_Trend_1 = "空";
      x = 200;
      color_indic = Red;
      UP_25 = 0;
      DOWN_25 = 1;
     }
   ObjectCreate("Trend_CCI_1", OBJ_LABEL, WindowFind("MultiChange"), 0, 0);
   ObjectSetText("Trend_CCI_1",CCI_Trend_1,8, "Verdana", color_indic);
   ObjectSet("Trend_CCI_1", OBJPROP_CORNER, 0);
   ObjectSet("Trend_CCI_1", OBJPROP_XDISTANCE, x);
   ObjectSet("Trend_CCI_1", OBJPROP_YDISTANCE,41);

   double CCI_5=iCCI(NULL,PERIOD_M5,CCIPeriod,CCIPrice,shift_5);

   if((CCI_5 > 0))
     {
      CCI_Trend_5 = "多";
      x = 200;
      color_indic = Lime;
      UP_26 = 1;
      DOWN_26 = 0;
     }
   if((CCI_5 < 0))
     {
      CCI_Trend_5 = "空";
      x = 200;
      color_indic = Red;
      UP_26 = 0;
      DOWN_26 = 1;
     }
   ObjectCreate("Trend_CCI_5", OBJ_LABEL, WindowFind("MultiChange"), 0, 0);
   ObjectSetText("Trend_CCI_5",CCI_Trend_5,8, "Verdana", color_indic);
   ObjectSet("Trend_CCI_5", OBJPROP_CORNER, 0);
   ObjectSet("Trend_CCI_5", OBJPROP_XDISTANCE, x);
   ObjectSet("Trend_CCI_5", OBJPROP_YDISTANCE,54);

   double CCI_15=iCCI(NULL,PERIOD_M15,CCIPeriod,CCIPrice,shift_15);

   if((CCI_15 > 0))
     {
      CCI_Trend_15 = "多";
      x = 200;
      color_indic = Lime;
      UP_27 = 1;
      DOWN_27 = 0;
     }
   if((CCI_15 < 0))
     {
      CCI_Trend_15 = "空";
      x = 200;
      color_indic = Red;
      UP_27 = 0;
      DOWN_27 = 1;
     }
   ObjectCreate("Trend_CCI_15", OBJ_LABEL, WindowFind("MultiChange"), 0, 0);
   ObjectSetText("Trend_CCI_15",CCI_Trend_15,8, "Verdana", color_indic);
   ObjectSet("Trend_CCI_15", OBJPROP_CORNER, 0);
   ObjectSet("Trend_CCI_15", OBJPROP_XDISTANCE, x);
   ObjectSet("Trend_CCI_15", OBJPROP_YDISTANCE,68);

   double CCI_30=iCCI(NULL,PERIOD_M30,CCIPeriod,CCIPrice,shift_30);

   if((CCI_30 > 0))
     {
      CCI_Trend_30 = "多";
      x = 200;
      color_indic = Lime;
      UP_28 = 1;
      DOWN_28 = 0;
     }
   if((CCI_30 < 0))
     {
      CCI_Trend_30 = "空";
      x = 200;
      color_indic = Red;
      UP_28 = 0;
      DOWN_28 = 1;
     }
   ObjectCreate("Trend_CCI_30", OBJ_LABEL, WindowFind("MultiChange"), 0, 0);
   ObjectSetText("Trend_CCI_30",CCI_Trend_30,8, "Verdana", color_indic);
   ObjectSet("Trend_CCI_30", OBJPROP_CORNER, 0);
   ObjectSet("Trend_CCI_30", OBJPROP_XDISTANCE, x);
   ObjectSet("Trend_CCI_30", OBJPROP_YDISTANCE,83);

   double CCI_60=iCCI(NULL,PERIOD_H1,CCIPeriod,CCIPrice,shift_60);

   if((CCI_60 > 0))
     {
      CCI_Trend_60 = "多";
      x = 200;
      color_indic = Lime;
      UP_29 = 1;
      DOWN_29 = 0;
     }
   if((CCI_60 < 0))
     {
      CCI_Trend_60 = "空";
      x = 200;
      color_indic = Red;
      UP_29 = 0;
      DOWN_29 = 1;
     }
   ObjectCreate("Trend_CCI_60", OBJ_LABEL, WindowFind("MultiChange"), 0, 0);
   ObjectSetText("Trend_CCI_60",CCI_Trend_60,8, "Verdana", color_indic);
   ObjectSet("Trend_CCI_60", OBJPROP_CORNER, 0);
   ObjectSet("Trend_CCI_60", OBJPROP_XDISTANCE, x);
   ObjectSet("Trend_CCI_60", OBJPROP_YDISTANCE,98);

   double CCI_240=iCCI(NULL,PERIOD_H4,CCIPeriod,CCIPrice,shift_240);

   if((CCI_240 > 0))
     {
      CCI_Trend_240 = "多";
      x = 200;
      color_indic = Lime;
      UP_30 = 1;
      DOWN_30 = 0;
     }
   if((CCI_240 < 0))
     {
      CCI_Trend_240 = "空";
      x = 200;
      color_indic = Red;
      UP_30 = 0;
      DOWN_30 = 1;
     }
   ObjectCreate("Trend_CCI_240", OBJ_LABEL, WindowFind("MultiChange"), 0, 0);
   ObjectSetText("Trend_CCI_240",CCI_Trend_240,8, "Verdana", color_indic);
   ObjectSet("Trend_CCI_240", OBJPROP_CORNER, 0);
   ObjectSet("Trend_CCI_240", OBJPROP_XDISTANCE, x);
   ObjectSet("Trend_CCI_240", OBJPROP_YDISTANCE,113);

   double CCI_1440=iCCI(NULL,PERIOD_D1,CCIPeriod,CCIPrice,shift_1440);

   if((CCI_1440 > 0))
     {
      CCI_Trend_1440 = "多";
      x = 200;
      color_indic = Lime;
      UP_31 = 1;
      DOWN_31 = 0;
     }
   if((CCI_1440 < 0))
     {
      CCI_Trend_1440 = "空";
      x = 200;
      color_indic = Red;
      UP_31 = 0;
      DOWN_31 = 1;
     }
   ObjectCreate("Trend_CCI_1440", OBJ_LABEL, WindowFind("MultiChange"), 0, 0);
   ObjectSetText("Trend_CCI_1440",CCI_Trend_1440,8, "Verdana", color_indic);
   ObjectSet("Trend_CCI_1440", OBJPROP_CORNER, 0);
   ObjectSet("Trend_CCI_1440", OBJPROP_XDISTANCE, x);
   ObjectSet("Trend_CCI_1440", OBJPROP_YDISTANCE,128);

   double CCI_10080=iCCI(NULL,PERIOD_W1,CCIPeriod,CCIPrice,shift_10080);

   if((CCI_10080 > 0))
     {
      CCI_Trend_10080 = "多";
      x = 200;
      color_indic = Lime;
      UP_32 = 1;
      DOWN_32 = 0;
     }
   if((CCI_10080 < 0))
     {
      CCI_Trend_10080 = "空";
      x = 200;
      color_indic = Red;
      UP_32 = 0;
      DOWN_32 = 1;
     }
   ObjectCreate("Trend_CCI_10080", OBJ_LABEL, WindowFind("MultiChange"), 0, 0);
   ObjectSetText("Trend_CCI_10080",CCI_Trend_10080,8, "Verdana", color_indic);
   ObjectSet("Trend_CCI_10080", OBJPROP_CORNER, 0);
   ObjectSet("Trend_CCI_10080", OBJPROP_XDISTANCE, x);
   ObjectSet("Trend_CCI_10080", OBJPROP_YDISTANCE,143);

// Indicator (MACD)

   ObjectCreate("macd", OBJ_LABEL, WindowFind("MultiChange"), 0, 0);
   ObjectSetText("macd","MACD",8, "Verdana", color_ind);
   ObjectSet("macd", OBJPROP_CORNER, 0);
   ObjectSet("macd", OBJPROP_XDISTANCE, 240);
   ObjectSet("macd", OBJPROP_YDISTANCE, 29);

   string MACD_Trend_1, MACD_Trend_5, MACD_Trend_15, MACD_Trend_30, MACD_Trend_60, MACD_Trend_240, MACD_Trend_1440, MACD_Trend_10080;


   double MACD_m_1=iMACD(NULL,PERIOD_M1,MACDFast,MACDSlow,MACDSignal,PRICE_CLOSE,MODE_MAIN,shift_1);
   double MACD_s_1=iMACD(NULL,PERIOD_M1,MACDFast,MACDSlow,MACDSignal,PRICE_CLOSE,MODE_SIGNAL,shift_1);

   if((MACD_m_1 > MACD_s_1))
     {
      MACD_Trend_1 = "多";
      x = 250;
      color_indic = Lime;
      UP_33 = 1;
      DOWN_33 = 0;
     }
   if((MACD_m_1 < MACD_s_1))
     {
      MACD_Trend_1 = "空";
      x = 250;
      color_indic = Red;
      UP_33 = 0;
      DOWN_33 = 1;
     }
   ObjectCreate("Trend_MACD_1", OBJ_LABEL, WindowFind("MultiChange"), 0, 0);
   ObjectSetText("Trend_MACD_1",MACD_Trend_1,8, "Verdana", color_indic);
   ObjectSet("Trend_MACD_1", OBJPROP_CORNER, 0);
   ObjectSet("Trend_MACD_1", OBJPROP_XDISTANCE, x);
   ObjectSet("Trend_MACD_1", OBJPROP_YDISTANCE,41);

   double MACD_m_5=iMACD(NULL,PERIOD_M5,MACDFast,MACDSlow,MACDSignal,PRICE_CLOSE,MODE_MAIN,shift_5);
   double MACD_s_5=iMACD(NULL,PERIOD_M5,MACDFast,MACDSlow,MACDSignal,PRICE_CLOSE,MODE_SIGNAL,shift_5);

   if((MACD_m_5 > MACD_s_5))
     {
      MACD_Trend_5 = "多";
      x = 250;
      color_indic = Lime;
      UP_34 = 1;
      DOWN_34 = 0;
     }
   if((MACD_m_5 < MACD_s_5))
     {
      MACD_Trend_5 = "空";
      x = 250;
      color_indic = Red;
      UP_34 = 0;
      DOWN_34 = 1;
     }
   ObjectCreate("Trend_MACD_5", OBJ_LABEL, WindowFind("MultiChange"), 0, 0);
   ObjectSetText("Trend_MACD_5",MACD_Trend_5,8, "Verdana", color_indic);
   ObjectSet("Trend_MACD_5", OBJPROP_CORNER, 0);
   ObjectSet("Trend_MACD_5", OBJPROP_XDISTANCE, x);
   ObjectSet("Trend_MACD_5", OBJPROP_YDISTANCE,54);

   double MACD_m_15=iMACD(NULL,PERIOD_M15,MACDFast,MACDSlow,MACDSignal,PRICE_CLOSE,MODE_MAIN,shift_15);
   double MACD_s_15=iMACD(NULL,PERIOD_M15,MACDFast,MACDSlow,MACDSignal,PRICE_CLOSE,MODE_SIGNAL,shift_15);

   if((MACD_m_15 > MACD_s_15))
     {
      MACD_Trend_15 = "多";
      x = 250;
      color_indic = Lime;
      UP_35 = 1;
      DOWN_35 = 0;
     }
   if((MACD_m_15 < MACD_s_15))
     {
      MACD_Trend_15 = "空";
      x = 250;
      color_indic = Red;
      UP_35 = 0;
      DOWN_35 = 1;
     }
   ObjectCreate("Trend_MACD_15", OBJ_LABEL, WindowFind("MultiChange"), 0, 0);
   ObjectSetText("Trend_MACD_15",MACD_Trend_15,8, "Verdana", color_indic);
   ObjectSet("Trend_MACD_15", OBJPROP_CORNER, 0);
   ObjectSet("Trend_MACD_15", OBJPROP_XDISTANCE, x);
   ObjectSet("Trend_MACD_15", OBJPROP_YDISTANCE,68);

   double MACD_m_30=iMACD(NULL,PERIOD_M30,MACDFast,MACDSlow,MACDSignal,PRICE_CLOSE,MODE_MAIN,shift_30);
   double MACD_s_30=iMACD(NULL,PERIOD_M30,MACDFast,MACDSlow,MACDSignal,PRICE_CLOSE,MODE_SIGNAL,shift_30);

   if((MACD_m_30 > MACD_s_30))
     {
      MACD_Trend_30 = "多";
      x = 250;
      color_indic = Lime;
      UP_36 = 1;
      DOWN_36 = 0;
     }
   if((MACD_m_30 < MACD_s_30))
     {
      MACD_Trend_30 = "空";
      x = 250;
      color_indic = Red;
      UP_36 = 0;
      DOWN_36 = 1;
     }
   ObjectCreate("Trend_MACD_30", OBJ_LABEL, WindowFind("MultiChange"), 0, 0);
   ObjectSetText("Trend_MACD_30",MACD_Trend_30,8, "Verdana", color_indic);
   ObjectSet("Trend_MACD_30", OBJPROP_CORNER, 0);
   ObjectSet("Trend_MACD_30", OBJPROP_XDISTANCE, x);
   ObjectSet("Trend_MACD_30", OBJPROP_YDISTANCE,83);

   double MACD_m_60=iMACD(NULL,PERIOD_H1,MACDFast,MACDSlow,MACDSignal,PRICE_CLOSE,MODE_MAIN,shift_60);
   double MACD_s_60=iMACD(NULL,PERIOD_H1,MACDFast,MACDSlow,MACDSignal,PRICE_CLOSE,MODE_SIGNAL,shift_60);

   if((MACD_m_60 > MACD_s_60))
     {
      MACD_Trend_60 = "多";
      x = 250;
      color_indic = Lime;
      UP_37 = 1;
      DOWN_37 = 0;
     }
   if((MACD_m_60 < MACD_s_60))
     {
      MACD_Trend_60 = "空";
      x = 250;
      color_indic = Red;
      UP_37 = 0;
      DOWN_37 = 1;
     }
   ObjectCreate("Trend_MACD_60", OBJ_LABEL, WindowFind("MultiChange"), 0, 0);
   ObjectSetText("Trend_MACD_60",MACD_Trend_60,8, "Verdana", color_indic);
   ObjectSet("Trend_MACD_60", OBJPROP_CORNER, 0);
   ObjectSet("Trend_MACD_60", OBJPROP_XDISTANCE, x);
   ObjectSet("Trend_MACD_60", OBJPROP_YDISTANCE,98);

   double MACD_m_240=iMACD(NULL,PERIOD_H4,MACDFast,MACDSlow,MACDSignal,PRICE_CLOSE,MODE_MAIN,shift_240);
   double MACD_s_240=iMACD(NULL,PERIOD_H4,MACDFast,MACDSlow,MACDSignal,PRICE_CLOSE,MODE_SIGNAL,shift_240);

   if((MACD_m_240 > MACD_s_240))
     {
      MACD_Trend_240 = "多";
      x = 250;
      color_indic = Lime;
      UP_38 = 1;
      DOWN_38 = 0;
     }
   if((MACD_m_240 < MACD_s_240))
     {
      MACD_Trend_240 = "空";
      x = 250;
      color_indic = Red;
      UP_38 = 0;
      DOWN_38 = 1;
     }
   ObjectCreate("Trend_MACD_240", OBJ_LABEL, WindowFind("MultiChange"), 0, 0);
   ObjectSetText("Trend_MACD_240",MACD_Trend_240,8, "Verdana", color_indic);
   ObjectSet("Trend_MACD_240", OBJPROP_CORNER, 0);
   ObjectSet("Trend_MACD_240", OBJPROP_XDISTANCE, x);
   ObjectSet("Trend_MACD_240", OBJPROP_YDISTANCE,113);

   double MACD_m_1440=iMACD(NULL,PERIOD_D1,MACDFast,MACDSlow,MACDSignal,PRICE_CLOSE,MODE_MAIN,shift_1440);
   double MACD_s_1440=iMACD(NULL,PERIOD_D1,MACDFast,MACDSlow,MACDSignal,PRICE_CLOSE,MODE_SIGNAL,shift_1440);

   if((MACD_m_1440 > MACD_s_1440))
     {
      MACD_Trend_1440 = "多";
      x = 250;
      color_indic = Lime;
      UP_39 = 1;
      DOWN_39 = 0;
     }
   if((MACD_m_1440 < MACD_s_1440))
     {
      MACD_Trend_1440 = "空";
      x = 250;
      color_indic = Red;
      UP_39 = 0;
      DOWN_39 = 1;
     }
   ObjectCreate("Trend_MACD_1440", OBJ_LABEL, WindowFind("MultiChange"), 0, 0);
   ObjectSetText("Trend_MACD_1440",MACD_Trend_1440,8, "Verdana", color_indic);
   ObjectSet("Trend_MACD_1440", OBJPROP_CORNER, 0);
   ObjectSet("Trend_MACD_1440", OBJPROP_XDISTANCE, x);
   ObjectSet("Trend_MACD_1440", OBJPROP_YDISTANCE,128);

   double MACD_m_10080=iMACD(NULL,PERIOD_W1,MACDFast,MACDSlow,MACDSignal,PRICE_CLOSE,MODE_MAIN,shift_10080);
   double MACD_s_10080=iMACD(NULL,PERIOD_W1,MACDFast,MACDSlow,MACDSignal,PRICE_CLOSE,MODE_SIGNAL,shift_10080);

   if((MACD_m_10080 > MACD_s_10080))
     {
      MACD_Trend_10080 = "多";
      x = 250;
      color_indic = Lime;
      UP_40 = 1;
      DOWN_40 = 0;
     }
   if((MACD_m_10080 < MACD_s_10080))
     {
      MACD_Trend_10080 = "空";
      x = 250;
      color_indic = Red;
      UP_40 = 0;
      DOWN_40 = 1;
     }
   ObjectCreate("Trend_MACD_10080", OBJ_LABEL, WindowFind("MultiChange"), 0, 0);
   ObjectSetText("Trend_MACD_10080",MACD_Trend_10080,8, "Verdana", color_indic);
   ObjectSet("Trend_MACD_10080", OBJPROP_CORNER, 0);
   ObjectSet("Trend_MACD_10080", OBJPROP_XDISTANCE, x);
   ObjectSet("Trend_MACD_10080", OBJPROP_YDISTANCE,143);

// Indicator (ADX)

   ObjectCreate("adx", OBJ_LABEL, WindowFind("MultiChange"), 0, 0);
   ObjectSetText("adx","ADX"+DoubleToStr(ADXPeriod,0),8, "Verdana", color_ind);
   ObjectSet("adx", OBJPROP_CORNER, 0);
   ObjectSet("adx", OBJPROP_XDISTANCE, 290);
   ObjectSet("adx", OBJPROP_YDISTANCE, 29);

   string ADX_Trend_1, ADX_Trend_5, ADX_Trend_15, ADX_Trend_30, ADX_Trend_60, ADX_Trend_240, ADX_Trend_1440, ADX_Trend_10080;

   double ADX_plus_1=iADX(NULL,PERIOD_M1,ADXPeriod,ADXPrice,MODE_PLUSDI,shift_1);
   double ADX_minus_1=iADX(NULL,PERIOD_M1,ADXPeriod,ADXPrice,MODE_MINUSDI,shift_1);

   if((ADX_plus_1 > ADX_minus_1))
     {
      ADX_Trend_1 = "多";
      x = 300;
      color_indic = Lime;
      UP_41 = 1;
      DOWN_41 = 0;
     }
   if((ADX_plus_1 < ADX_minus_1))
     {
      ADX_Trend_1 = "空";
      x = 300;
      color_indic = Red;
      UP_41 = 0;
      DOWN_41 = 1;
     }
   ObjectCreate("Trend_ADX_1", OBJ_LABEL, WindowFind("MultiChange"), 0, 0);
   ObjectSetText("Trend_ADX_1",ADX_Trend_1,8, "Verdana", color_indic);
   ObjectSet("Trend_ADX_1", OBJPROP_CORNER, 0);
   ObjectSet("Trend_ADX_1", OBJPROP_XDISTANCE, x);
   ObjectSet("Trend_ADX_1", OBJPROP_YDISTANCE,41);

   double ADX_plus_5=iADX(NULL,PERIOD_M5,ADXPeriod,ADXPrice,MODE_PLUSDI,shift_5);
   double ADX_minus_5=iADX(NULL,PERIOD_M5,ADXPeriod,ADXPrice,MODE_MINUSDI,shift_5);

   if((ADX_plus_5 > ADX_minus_5))
     {
      ADX_Trend_5 = "多";
      x = 300;
      color_indic = Lime;
      UP_42 = 1;
      DOWN_42 = 0;
     }
   if((ADX_plus_5 < ADX_minus_5))
     {
      ADX_Trend_5 = "空";
      x = 300;
      color_indic = Red;
      UP_42 = 0;
      DOWN_42 = 1;
     }
   ObjectCreate("Trend_ADX_5", OBJ_LABEL, WindowFind("MultiChange"), 0, 0);
   ObjectSetText("Trend_ADX_5",ADX_Trend_5,8, "Verdana", color_indic);
   ObjectSet("Trend_ADX_5", OBJPROP_CORNER, 0);
   ObjectSet("Trend_ADX_5", OBJPROP_XDISTANCE, x);
   ObjectSet("Trend_ADX_5", OBJPROP_YDISTANCE,54);

   double ADX_plus_15=iADX(NULL,PERIOD_M15,ADXPeriod,ADXPrice,MODE_PLUSDI,shift_15);
   double ADX_minus_15=iADX(NULL,PERIOD_M15,ADXPeriod,ADXPrice,MODE_MINUSDI,shift_15);

   if((ADX_plus_15 > ADX_minus_15))
     {
      ADX_Trend_15 = "多";
      x = 300;
      color_indic = Lime;
      UP_43 = 1;
      DOWN_43 = 0;
     }
   if((ADX_plus_15 < ADX_minus_15))
     {
      ADX_Trend_15 = "空";
      x = 300;
      color_indic = Red;
      UP_43 = 0;
      DOWN_43 = 1;
     }
   ObjectCreate("Trend_ADX_15", OBJ_LABEL, WindowFind("MultiChange"), 0, 0);
   ObjectSetText("Trend_ADX_15",ADX_Trend_15,8, "Verdana", color_indic);
   ObjectSet("Trend_ADX_15", OBJPROP_CORNER, 0);
   ObjectSet("Trend_ADX_15", OBJPROP_XDISTANCE, x);
   ObjectSet("Trend_ADX_15", OBJPROP_YDISTANCE,68);

   double ADX_plus_30=iADX(NULL,PERIOD_M30,ADXPeriod,ADXPrice,MODE_PLUSDI,shift_30);
   double ADX_minus_30=iADX(NULL,PERIOD_M30,ADXPeriod,ADXPrice,MODE_MINUSDI,shift_30);

   if((ADX_plus_30 > ADX_minus_30))
     {
      ADX_Trend_30 = "多";
      x = 300;
      color_indic = Lime;
      UP_44 = 1;
      DOWN_44 = 0;
     }
   if((ADX_plus_30 < ADX_minus_30))
     {
      ADX_Trend_30 = "空";
      x = 300;
      color_indic = Red;
      UP_44 = 0;
      DOWN_44 = 1;
     }
   ObjectCreate("Trend_ADX_30", OBJ_LABEL, WindowFind("MultiChange"), 0, 0);
   ObjectSetText("Trend_ADX_30",ADX_Trend_30,8, "Verdana", color_indic);
   ObjectSet("Trend_ADX_30", OBJPROP_CORNER, 0);
   ObjectSet("Trend_ADX_30", OBJPROP_XDISTANCE, x);
   ObjectSet("Trend_ADX_30", OBJPROP_YDISTANCE,83);

   double ADX_plus_60=iADX(NULL,PERIOD_H1,ADXPeriod,ADXPrice,MODE_PLUSDI,shift_60);
   double ADX_minus_60=iADX(NULL,PERIOD_H1,ADXPeriod,ADXPrice,MODE_MINUSDI,shift_60);

   if((ADX_plus_60 > ADX_minus_60))
     {
      ADX_Trend_60 = "多";
      x = 300;
      color_indic = Lime;
      UP_45 = 1;
      DOWN_45 = 0;
     }
   if((ADX_plus_60 < ADX_minus_60))
     {
      ADX_Trend_60 = "空";
      x = 300;
      color_indic = Red;
      UP_45 = 0;
      DOWN_45 = 1;
     }
   ObjectCreate("Trend_ADX_60", OBJ_LABEL, WindowFind("MultiChange"), 0, 0);
   ObjectSetText("Trend_ADX_60",ADX_Trend_60,8, "Verdana", color_indic);
   ObjectSet("Trend_ADX_60", OBJPROP_CORNER, 0);
   ObjectSet("Trend_ADX_60", OBJPROP_XDISTANCE, x);
   ObjectSet("Trend_ADX_60", OBJPROP_YDISTANCE,98);

   double ADX_plus_240=iADX(NULL,PERIOD_H4,ADXPeriod,ADXPrice,MODE_PLUSDI,shift_240);
   double ADX_minus_240=iADX(NULL,PERIOD_H4,ADXPeriod,ADXPrice,MODE_MINUSDI,shift_240);

   if((ADX_plus_240 > ADX_minus_240))
     {
      ADX_Trend_240 = "多";
      x = 300;
      color_indic = Lime;
      UP_46 = 1;
      DOWN_46 = 0;
     }
   if((ADX_plus_240 < ADX_minus_240))
     {
      ADX_Trend_240 = "空";
      x = 300;
      color_indic = Red;
      UP_46 = 0;
      DOWN_46 = 1;
     }
   ObjectCreate("Trend_ADX_240", OBJ_LABEL, WindowFind("MultiChange"), 0, 0);
   ObjectSetText("Trend_ADX_240",ADX_Trend_240,8, "Verdana", color_indic);
   ObjectSet("Trend_ADX_240", OBJPROP_CORNER, 0);
   ObjectSet("Trend_ADX_240", OBJPROP_XDISTANCE, x);
   ObjectSet("Trend_ADX_240", OBJPROP_YDISTANCE,113);

   double ADX_plus_1440=iADX(NULL,PERIOD_D1,ADXPeriod,ADXPrice,MODE_PLUSDI,shift_1440);
   double ADX_minus_1440=iADX(NULL,PERIOD_D1,ADXPeriod,ADXPrice,MODE_MINUSDI,shift_1440);

   if((ADX_plus_1440 > ADX_minus_1440))
     {
      ADX_Trend_1440 = "多";
      x = 300;
      color_indic = Lime;
      UP_47 = 1;
      DOWN_47 = 0;
     }
   if((ADX_plus_1440 < ADX_minus_1440))
     {
      ADX_Trend_1440 = "空";
      x = 300;
      color_indic = Red;
      UP_47 = 0;
      DOWN_47 = 1;
     }
   ObjectCreate("Trend_ADX_1440", OBJ_LABEL, WindowFind("MultiChange"), 0, 0);
   ObjectSetText("Trend_ADX_1440",ADX_Trend_1440,8, "Verdana", color_indic);
   ObjectSet("Trend_ADX_1440", OBJPROP_CORNER, 0);
   ObjectSet("Trend_ADX_1440", OBJPROP_XDISTANCE, x);
   ObjectSet("Trend_ADX_1440", OBJPROP_YDISTANCE,128);

   double ADX_plus_10080=iADX(NULL,PERIOD_W1,ADXPeriod,ADXPrice,MODE_PLUSDI,shift_10080);
   double ADX_minus_10080=iADX(NULL,PERIOD_W1,ADXPeriod,ADXPrice,MODE_MINUSDI,shift_10080);

   if((ADX_plus_10080 > ADX_minus_10080))
     {
      ADX_Trend_10080 = "多";
      x = 300;
      color_indic = Lime;
      UP_48 = 1;
      DOWN_48 = 0;
     }
   if((ADX_plus_10080 < ADX_minus_10080))
     {
      ADX_Trend_10080 = "空";
      x = 300;
      color_indic = Red;
      UP_48 = 0;
      DOWN_48 = 1;
     }
   ObjectCreate("Trend_ADX_10080", OBJ_LABEL, WindowFind("MultiChange"), 0, 0);
   ObjectSetText("Trend_ADX_10080",ADX_Trend_10080,8, "Verdana", color_indic);
   ObjectSet("Trend_ADX_10080", OBJPROP_CORNER, 0);
   ObjectSet("Trend_ADX_10080", OBJPROP_XDISTANCE, x);
   ObjectSet("Trend_ADX_10080", OBJPROP_YDISTANCE,143);

// Indicator (BULLS)

   ObjectCreate("bulls", OBJ_LABEL, WindowFind("MultiChange"), 0, 0);
   ObjectSetText("bulls","BULLS",8, "Verdana", color_ind);
   ObjectSet("bulls", OBJPROP_CORNER, 0);
   ObjectSet("bulls", OBJPROP_XDISTANCE, 340);
   ObjectSet("bulls", OBJPROP_YDISTANCE, 29);

   string BULLS_Trend_1, BULLS_Trend_5, BULLS_Trend_15, BULLS_Trend_30, BULLS_Trend_60, BULLS_Trend_240, BULLS_Trend_1440, BULLS_Trend_10080;

   double bulls_1=iBullsPower(NULL,PERIOD_M1,BULLSPeriod,BULLSPrice,shift_1);

   if((bulls_1 > 0))
     {
      BULLS_Trend_1 = "多";
      x = 350;
      color_indic = Lime;
      UP_49 = 1;
      DOWN_49 = 0;
     }
   if((bulls_1 < 0))
     {
      BULLS_Trend_1 = "空";
      x = 350;
      color_indic = Red;
      UP_49 = 0;
      DOWN_49 = 1;
     }
   ObjectCreate("Trend_BULLS_1", OBJ_LABEL, WindowFind("MultiChange"), 0, 0);
   ObjectSetText("Trend_BULLS_1",BULLS_Trend_1,8, "Verdana", color_indic);
   ObjectSet("Trend_BULLS_1", OBJPROP_CORNER, 0);
   ObjectSet("Trend_BULLS_1", OBJPROP_XDISTANCE, x);
   ObjectSet("Trend_BULLS_1", OBJPROP_YDISTANCE,41);

   double bulls_5=iBullsPower(NULL,PERIOD_M5,BULLSPeriod,BULLSPrice,shift_5);

   if((bulls_5 > 0))
     {
      BULLS_Trend_5 = "多";
      x = 350;
      color_indic = Lime;
      UP_50 = 1;
      DOWN_50 = 0;
     }
   if((bulls_5 < 0))
     {
      BULLS_Trend_5 = "空";
      x = 350;
      color_indic = Red;
      UP_50 = 0;
      DOWN_50 = 1;
     }
   ObjectCreate("Trend_BULLS_5", OBJ_LABEL, WindowFind("MultiChange"), 0, 0);
   ObjectSetText("Trend_BULLS_5",BULLS_Trend_5,8, "Verdana", color_indic);
   ObjectSet("Trend_BULLS_5", OBJPROP_CORNER, 0);
   ObjectSet("Trend_BULLS_5", OBJPROP_XDISTANCE, x);
   ObjectSet("Trend_BULLS_5", OBJPROP_YDISTANCE,54);

   double bulls_15=iBullsPower(NULL,PERIOD_M15,BULLSPeriod,BULLSPrice,shift_15);

   if((bulls_15 > 0))
     {
      BULLS_Trend_15 = "多";
      x = 350;
      color_indic = Lime;
      UP_51 = 1;
      DOWN_51 = 0;
     }
   if((bulls_15 < 0))
     {
      BULLS_Trend_15 = "空";
      x = 350;
      color_indic = Red;
      UP_51 = 0;
      DOWN_51 = 1;
     }
   ObjectCreate("Trend_BULLS_15", OBJ_LABEL, WindowFind("MultiChange"), 0, 0);
   ObjectSetText("Trend_BULLS_15",BULLS_Trend_15,8, "Verdana", color_indic);
   ObjectSet("Trend_BULLS_15", OBJPROP_CORNER, 0);
   ObjectSet("Trend_BULLS_15", OBJPROP_XDISTANCE, x);
   ObjectSet("Trend_BULLS_15", OBJPROP_YDISTANCE,68);

   double bulls_30=iBullsPower(NULL,PERIOD_M30,BULLSPeriod,BULLSPrice,shift_30);

   if((bulls_30 > 0))
     {
      BULLS_Trend_30 = "多";
      x = 350;
      color_indic = Lime;
      UP_52 = 1;
      DOWN_52 = 0;
     }
   if((bulls_30 < 0))
     {
      BULLS_Trend_30 = "空";
      x = 350;
      color_indic = Red;
      UP_52 = 0;
      DOWN_52 = 1;
     }
   ObjectCreate("Trend_BULLS_30", OBJ_LABEL, WindowFind("MultiChange"), 0, 0);
   ObjectSetText("Trend_BULLS_30",BULLS_Trend_30,8, "Verdana", color_indic);
   ObjectSet("Trend_BULLS_30", OBJPROP_CORNER, 0);
   ObjectSet("Trend_BULLS_30", OBJPROP_XDISTANCE, x);
   ObjectSet("Trend_BULLS_30", OBJPROP_YDISTANCE,83);

   double bulls_60=iBullsPower(NULL,PERIOD_H1,BULLSPeriod,BULLSPrice,shift_60);

   if((bulls_60 > 0))
     {
      BULLS_Trend_60 = "多";
      x = 350;
      color_indic = Lime;
      UP_53 = 1;
      DOWN_53 = 0;
     }
   if((bulls_60 < 0))
     {
      BULLS_Trend_60 = "空";
      x = 350;
      color_indic = Red;
      UP_53 = 0;
      DOWN_53 = 1;
     }
   ObjectCreate("Trend_BULLS_60", OBJ_LABEL, WindowFind("MultiChange"), 0, 0);
   ObjectSetText("Trend_BULLS_60",BULLS_Trend_60,8, "Verdana", color_indic);
   ObjectSet("Trend_BULLS_60", OBJPROP_CORNER, 0);
   ObjectSet("Trend_BULLS_60", OBJPROP_XDISTANCE, x);
   ObjectSet("Trend_BULLS_60", OBJPROP_YDISTANCE,98);

   double bulls_240=iBullsPower(NULL,PERIOD_H4,BULLSPeriod,BULLSPrice,shift_240);

   if((bulls_240 > 0))
     {
      BULLS_Trend_240 = "多";
      x = 350;
      color_indic = Lime;
      UP_54 = 1;
      DOWN_54 = 0;
     }
   if((bulls_240 < 0))
     {
      BULLS_Trend_240 = "空";
      x = 350;
      color_indic = Red;
      UP_54 = 0;
      DOWN_54 = 1;
     }
   ObjectCreate("Trend_BULLS_240", OBJ_LABEL, WindowFind("MultiChange"), 0, 0);
   ObjectSetText("Trend_BULLS_240",BULLS_Trend_240,8, "Verdana", color_indic);
   ObjectSet("Trend_BULLS_240", OBJPROP_CORNER, 0);
   ObjectSet("Trend_BULLS_240", OBJPROP_XDISTANCE, x);
   ObjectSet("Trend_BULLS_240", OBJPROP_YDISTANCE,113);

   double bulls_1440=iBullsPower(NULL,PERIOD_D1,BULLSPeriod,BULLSPrice,shift_1440);

   if((bulls_1440 > 0))
     {
      BULLS_Trend_1440 = "多";
      x = 350;
      color_indic = Lime;
      UP_55 = 1;
      DOWN_55 = 0;
     }
   if((bulls_1440 < 0))
     {
      BULLS_Trend_1440 = "空";
      x = 350;
      color_indic = Red;
      UP_55 = 0;
      DOWN_55 = 1;
     }
   ObjectCreate("Trend_BULLS_1440", OBJ_LABEL, WindowFind("MultiChange"), 0, 0);
   ObjectSetText("Trend_BULLS_1440",BULLS_Trend_1440,8, "Verdana", color_indic);
   ObjectSet("Trend_BULLS_1440", OBJPROP_CORNER, 0);
   ObjectSet("Trend_BULLS_1440", OBJPROP_XDISTANCE, x);
   ObjectSet("Trend_BULLS_1440", OBJPROP_YDISTANCE,128);

   double bulls_10080=iBullsPower(NULL,PERIOD_W1,BULLSPeriod,BULLSPrice,shift_10080);

   if((bulls_10080 > 0))
     {
      BULLS_Trend_10080 = "多";
      x = 350;
      color_indic = Lime;
      UP_56 = 1;
      DOWN_56 = 0;
     }
   if((bulls_10080 < 0))
     {
      BULLS_Trend_10080 = "空";
      x = 350;
      color_indic = Red;
      UP_56 = 0;
      DOWN_56 = 1;
     }
   ObjectCreate("Trend_BULLS_10080", OBJ_LABEL, WindowFind("MultiChange"), 0, 0);
   ObjectSetText("Trend_BULLS_10080",BULLS_Trend_10080,8, "Verdana", color_indic);
   ObjectSet("Trend_BULLS_10080", OBJPROP_CORNER, 0);
   ObjectSet("Trend_BULLS_10080", OBJPROP_XDISTANCE, x);
   ObjectSet("Trend_BULLS_10080", OBJPROP_YDISTANCE,143);

// Indicator (BEARS)

   ObjectCreate("bears", OBJ_LABEL, WindowFind("MultiChange"), 0, 0);
   ObjectSetText("bears","BEARS",8, "Verdana", color_ind);
   ObjectSet("bears", OBJPROP_CORNER, 0);
   ObjectSet("bears", OBJPROP_XDISTANCE, 390);
   ObjectSet("bears", OBJPROP_YDISTANCE, 29);

   string BEARS_Trend_1, BEARS_Trend_5, BEARS_Trend_15, BEARS_Trend_30, BEARS_Trend_60, BEARS_Trend_240, BEARS_Trend_1440, BEARS_Trend_10080;

   double bears_1=iBearsPower(NULL,PERIOD_M1,BEARSPeriod,BEARSPrice,shift_1);

   if((bears_1 > 0))
     {
      BEARS_Trend_1 = "多";
      x = 400;
      color_indic = Lime;
      UP_57 = 1;
      DOWN_57 = 0;
     }
   if((bears_1 < 0))
     {
      BEARS_Trend_1 = "空";
      x = 400;
      color_indic = Red;
      UP_57 = 0;
      DOWN_57 = 1;
     }
   ObjectCreate("Trend_BEARS_1", OBJ_LABEL, WindowFind("MultiChange"), 0, 0);
   ObjectSetText("Trend_BEARS_1",BEARS_Trend_1,8, "Verdana", color_indic);
   ObjectSet("Trend_BEARS_1", OBJPROP_CORNER, 0);
   ObjectSet("Trend_BEARS_1", OBJPROP_XDISTANCE, x);
   ObjectSet("Trend_BEARS_1", OBJPROP_YDISTANCE,41);

   double bears_5=iBearsPower(NULL,PERIOD_M5,BEARSPeriod,BEARSPrice,shift_5);

   if((bears_5 > 0))
     {
      BEARS_Trend_5 = "多";
      x = 400;
      color_indic = Lime;
      UP_58 = 1;
      DOWN_58 = 0;
     }
   if((bears_5 < 0))
     {
      BEARS_Trend_5 = "空";
      x = 400;
      color_indic = Red;
      UP_58 = 0;
      DOWN_58 = 1;
     }
   ObjectCreate("Trend_BEARS_5", OBJ_LABEL, WindowFind("MultiChange"), 0, 0);
   ObjectSetText("Trend_BEARS_5",BEARS_Trend_5,8, "Verdana", color_indic);
   ObjectSet("Trend_BEARS_5", OBJPROP_CORNER, 0);
   ObjectSet("Trend_BEARS_5", OBJPROP_XDISTANCE, x);
   ObjectSet("Trend_BEARS_5", OBJPROP_YDISTANCE,54);

   double bears_15=iBearsPower(NULL,PERIOD_M15,BEARSPeriod,BEARSPrice,shift_15);

   if((bears_15 > 0))
     {
      BEARS_Trend_15 = "多";
      x = 400;
      color_indic = Lime;
      UP_59 = 1;
      DOWN_59 = 0;
     }
   if((bears_15 < 0))
     {
      BEARS_Trend_15 = "空";
      x = 400;
      color_indic = Red;
      UP_59 = 0;
      DOWN_59 = 1;
     }
   ObjectCreate("Trend_BEARS_15", OBJ_LABEL, WindowFind("MultiChange"), 0, 0);
   ObjectSetText("Trend_BEARS_15",BEARS_Trend_15,8, "Verdana", color_indic);
   ObjectSet("Trend_BEARS_15", OBJPROP_CORNER, 0);
   ObjectSet("Trend_BEARS_15", OBJPROP_XDISTANCE, x);
   ObjectSet("Trend_BEARS_15", OBJPROP_YDISTANCE,68);

   double bears_30=iBearsPower(NULL,PERIOD_M30,BEARSPeriod,BEARSPrice,shift_30);

   if((bears_30 > 0))
     {
      BEARS_Trend_30 = "多";
      x = 400;
      color_indic = Lime;
      UP_60 = 1;
      DOWN_60 = 0;
     }
   if((bears_30 < 0))
     {
      BEARS_Trend_30 = "空";
      x = 400;
      color_indic = Red;
      UP_60 = 0;
      DOWN_60 = 1;
     }
   ObjectCreate("Trend_BEARS_30", OBJ_LABEL, WindowFind("MultiChange"), 0, 0);
   ObjectSetText("Trend_BEARS_30",BEARS_Trend_30,8, "Verdana", color_indic);
   ObjectSet("Trend_BEARS_30", OBJPROP_CORNER, 0);
   ObjectSet("Trend_BEARS_30", OBJPROP_XDISTANCE, x);
   ObjectSet("Trend_BEARS_30", OBJPROP_YDISTANCE,83);

   double bears_60=iBearsPower(NULL,PERIOD_H1,BEARSPeriod,BEARSPrice,shift_60);

   if((bears_60 > 0))
     {
      BEARS_Trend_60 = "多";
      x = 400;
      color_indic = Lime;
      UP_61 = 1;
      DOWN_61 = 0;
     }
   if((bears_60 < 0))
     {
      BEARS_Trend_60 = "空";
      x = 400;
      color_indic = Red;
      UP_61 = 0;
      DOWN_61 = 1;
     }
   ObjectCreate("Trend_BEARS_60", OBJ_LABEL, WindowFind("MultiChange"), 0, 0);
   ObjectSetText("Trend_BEARS_60",BEARS_Trend_60,8, "Verdana", color_indic);
   ObjectSet("Trend_BEARS_60", OBJPROP_CORNER, 0);
   ObjectSet("Trend_BEARS_60", OBJPROP_XDISTANCE, x);
   ObjectSet("Trend_BEARS_60", OBJPROP_YDISTANCE,98);

   double bears_240=iBearsPower(NULL,PERIOD_H4,BEARSPeriod,BEARSPrice,shift_240);

   if((bears_240 > 0))
     {
      BEARS_Trend_240 = "多";
      x = 400;
      color_indic = Lime;
      UP_62 = 1;
      DOWN_62 = 0;
     }
   if((bears_240 < 0))
     {
      BEARS_Trend_240 = "空";
      x = 400;
      color_indic = Red;
      UP_62 = 0;
      DOWN_62 = 1;
     }
   ObjectCreate("Trend_BEARS_240", OBJ_LABEL, WindowFind("MultiChange"), 0, 0);
   ObjectSetText("Trend_BEARS_240",BEARS_Trend_240,8, "Verdana", color_indic);
   ObjectSet("Trend_BEARS_240", OBJPROP_CORNER, 0);
   ObjectSet("Trend_BEARS_240", OBJPROP_XDISTANCE, x);
   ObjectSet("Trend_BEARS_240", OBJPROP_YDISTANCE,113);

   double bears_1440=iBearsPower(NULL,PERIOD_D1,BEARSPeriod,BEARSPrice,shift_1440);

   if((bears_1440 > 0))
     {
      BEARS_Trend_1440 = "多";
      x = 400;
      color_indic = Lime;
      UP_63 = 1;
      DOWN_63 = 0;
     }
   if((bears_1440 < 0))
     {
      BEARS_Trend_1440 = "空";
      x = 400;
      color_indic = Red;
      UP_63 = 0;
      DOWN_63 = 1;
     }
   ObjectCreate("Trend_BEARS_1440", OBJ_LABEL, WindowFind("MultiChange"), 0, 0);
   ObjectSetText("Trend_BEARS_1440",BEARS_Trend_1440,8, "Verdana", color_indic);
   ObjectSet("Trend_BEARS_1440", OBJPROP_CORNER, 0);
   ObjectSet("Trend_BEARS_1440", OBJPROP_XDISTANCE, x);
   ObjectSet("Trend_BEARS_1440", OBJPROP_YDISTANCE,128);

   double bears_10080=iBearsPower(NULL,PERIOD_W1,BEARSPeriod,BEARSPrice,shift_10080);

   if((bears_10080 > 0))
     {
      BEARS_Trend_10080 = "多";
      x = 400;
      color_indic = Lime;
      UP_64 = 1;
      DOWN_64 = 0;
     }
   if((bears_10080 < 0))
     {
      BEARS_Trend_10080 = "空";
      x = 400;
      color_indic = Red;
      UP_64 = 0;
      DOWN_64 = 1;
     }
   ObjectCreate("Trend_BEARS_10080", OBJ_LABEL, WindowFind("MultiChange"), 0, 0);
   ObjectSetText("Trend_BEARS_10080",BEARS_Trend_10080,8, "Verdana", color_indic);
   ObjectSet("Trend_BEARS_10080", OBJPROP_CORNER, 0);
   ObjectSet("Trend_BEARS_10080", OBJPROP_XDISTANCE, x);
   ObjectSet("Trend_BEARS_10080", OBJPROP_YDISTANCE,143);

//Calculation of the trend

   double Trend_UP = UP_1 + UP_2 + UP_3 + UP_4 + UP_5 + UP_6 + UP_7 + UP_8 + UP_9 + UP_10
                     + UP_11 + UP_12 + UP_13 + UP_14 + UP_15 + UP_16 + UP_17 + UP_18 + UP_19 + UP_20
                     + UP_21 + UP_22 + UP_23 + UP_24 + UP_25 + UP_26 + UP_27 + UP_28 + UP_29 + UP_30
                     + UP_31 + UP_32 + UP_33 + UP_34 + UP_35 + UP_36 + UP_37 + UP_38 + UP_39 + UP_40
                     + UP_41 + UP_42 + UP_43 + UP_44 + UP_45 + UP_46 + UP_47 + UP_48 + UP_49 + UP_50
                     + UP_51 + UP_52 + UP_53 + UP_54 + UP_55 + UP_56 + UP_57 + UP_58 + UP_59 + UP_60
                     + UP_61 + UP_62 + UP_63 + UP_64;
   double Trend_DOWN = DOWN_1 + DOWN_2 + DOWN_3 + DOWN_4 + DOWN_5 + DOWN_6 + DOWN_7 + DOWN_8 + DOWN_9 + DOWN_10
                       + DOWN_11 + DOWN_12 + DOWN_13 + DOWN_14 + DOWN_15 + DOWN_16 + DOWN_17 + DOWN_18 + DOWN_19 + DOWN_20
                       + DOWN_21 + DOWN_22 + DOWN_23 + DOWN_24 + DOWN_25 + DOWN_26 + DOWN_27 + DOWN_28 + DOWN_29 + DOWN_30
                       + DOWN_31 + DOWN_32 + DOWN_33 + DOWN_34 + DOWN_35 + DOWN_36 + DOWN_37 + DOWN_38 + DOWN_39 + DOWN_40
                       + DOWN_41 + DOWN_42 + DOWN_43 + DOWN_44 + DOWN_45 + DOWN_46 + DOWN_47 + DOWN_48 + DOWN_49 + DOWN_50
                       + DOWN_51 + DOWN_52 + DOWN_53 + DOWN_54 + DOWN_55 + DOWN_56 + DOWN_57 + DOWN_58 + DOWN_59 + DOWN_60
                       + DOWN_61 + DOWN_62 + DOWN_63 + DOWN_64;

   UPBuffer[0] = Trend_UP;
   DOWNBuffer[0] = Trend_DOWN;

   if((56>Trend_UP)&&(Trend_UP>=36))
     {
      trendtext="(买入)";
      color_indic = Lime;
     }
   if(Trend_UP>=56)
     {
      trendtext="(强力买入)";
      color_indic = Lime;
     }
   if(Trend_UP<=8)
     {
      trendtext="(强力卖出)";
      color_indic = Red;
     }
   if((8<Trend_UP) && (Trend_UP<=28))
     {
      trendtext="(卖出)";
      color_indic = Red;
     }
   if((28<Trend_UP) && (Trend_UP<36))
     {
      trendtext="(中性)";
      color_indic = White;
     }

   ObjectCreate("trend", OBJ_LABEL, WindowFind("MultiChange"), 0, 0);
   ObjectSetText("trend",trendtext,12, "Arial", color_indic);
   ObjectSet("trend", OBJPROP_CORNER, 0);
   ObjectSet("trend", OBJPROP_XDISTANCE, 395);
   ObjectSet("trend", OBJPROP_YDISTANCE, 8);

   double vol=(iHigh(Symbol(),1440,0)-iLow(Symbol(),1440,0))/MarketInfo(Symbol(),MODE_POINT);

   ObjectCreate("range1", OBJ_LABEL, WindowFind("MultiChange"), 0, 0);
   ObjectSetText("range1","振幅：",8, "Arial", White);
   ObjectSet("range1", OBJPROP_CORNER, 0);
   ObjectSet("range1", OBJPROP_XDISTANCE, 480);
   ObjectSet("range1", OBJPROP_YDISTANCE, 75);
   ObjectCreate("range", OBJ_LABEL, WindowFind("MultiChange"), 0, 0);
   ObjectSetText("range",DoubleToStr(vol,0)+" pips",8, "Arial", White);
   ObjectSet("range", OBJPROP_CORNER, 0);
   ObjectSet("range", OBJPROP_XDISTANCE, 470);
   ObjectSet("range", OBJPROP_YDISTANCE, 90);



   string CheckDayMA_text,CheckDayMA_note;
   color color_day;
   double CheckDayMA = iMA(NULL,PERIOD_D1,5,0,MODE_EMA,PRICE_CLOSE,0);
   if(askprice>=CheckDayMA)
     {
      CheckDayMA_text="$$ 5日均线之上 $$";
      CheckDayMA_note="!! 只做多 !!";
      color_day=Lime;
     }
   else
     {
      CheckDayMA_text="$$ 5日均线之下 $$";
      CheckDayMA_note="!! 只做空 !!";
      color_day=Red;
     }


   ObjectCreate("Warning", OBJ_LABEL, WindowFind("MultiChange"), 0, 0);
   ObjectSetText("Warning",CheckDayMA_text,10, "Arial", PaleGoldenrod);
   ObjectSet("Warning", OBJPROP_CORNER, 0);
   ObjectSet("Warning", OBJPROP_XDISTANCE, 445);
   ObjectSet("Warning", OBJPROP_YDISTANCE, 35);
   ObjectCreate("Warning2", OBJ_LABEL, WindowFind("MultiChange"), 0, 0);
   ObjectSetText("Warning2",CheckDayMA_note,11, "Arial", color_day);
   ObjectSet("Warning2", OBJPROP_CORNER, 0);
   ObjectSet("Warning2", OBJPROP_XDISTANCE, 460);
   ObjectSet("Warning2", OBJPROP_YDISTANCE, 50);





   RefreshRates();}
//--- return value of prev_calculated for next call
   return(rates_total);
  }

//+------------------------------------------------------------------+
void TextCreate(string name,string neirong,int x,int y,int daxiao,color yanse)
  {
    if(ObjectFind(name)<0)
     {
        ObjectCreate(name,OBJ_LABEL,0,0,0);
        ObjectSetText(name,neirong,daxiao,"宋体",yanse);
        ObjectSet(name,OBJPROP_XDISTANCE,x);
        ObjectSet(name,OBJPROP_YDISTANCE,y);
        ObjectSet(name,OBJPROP_CORNER,0);
     }
    else
     {
        ObjectSetText(name,neirong,daxiao,"宋体",yanse);
        WindowRedraw();
     }
  }