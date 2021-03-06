//+------------------------------------------------------------------+
//|                                                  SymbolCheck.mq4 |
//|                        Copyright 2020, Horse Technology Corp. MZ |
//|                                   https://www.horsegroup.net/en/ |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, Horse Technology Corp. MZ"
#property link      "https://www.horsegroup.net/en/"
#property version   "1.00"
#property strict

#property indicator_separate_window
#property indicator_minimum 0
#property indicator_maximum 1
#property indicator_buffers 2
#property indicator_color1 Lime
#property indicator_color2 Red
#property description "交易标的实时监测统计指标" 
#property description "注意：需要在市场观察中显示所有货币对！" 
#property description "指标所有权和归属权归于马汇科技@Horseforex" 
#property description "如需修改及自定义指标请联系VX:306599003" 
#property description "开户链接: https://secure.horsegroup.net/register/" 
#property description "Symbol Check&Monitor Indicators. Copyright@Horseforex" 
#property description "Open Account: https://secure.horsegroup.net/register/" 

input     string symbol1="USDIDX";
input     string symbol2="EURUSD";
input     string symbol3="GBPUSD";
input     string symbol4="AUDUSD";
input     string symbol5="USDJPY";
input     string symbol6="USDCAD";
input     string symbol7="WTI";
input     string symbol8="US500f";
input     string symbol9="XAUUSD";
input     string symbol10="BTCUSD";
//---- buffers
double UPBuffer[];
double DOWNBuffer[];

//string customsymbol[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   IndicatorShortName("SymbolCheck");
   SetIndexBuffer(0,UPBuffer);
   SetIndexBuffer(1,DOWNBuffer);
     if(AccountInfoString(ACCOUNT_COMPANY)=="Horse Forex Ltd")
         {           
               // TextCreate("PASS","Horse Technology @copyright",15,15,10,Red);
               // flag=1;
         }
    else {
            Alert("Invaild Broker !");
            Alert("Please Change Account !");
            Alert("Failed Authorization !");
            return(INIT_FAILED);
         }  
//---
   string symbol=Symbol();
   ObjectCreate("timef", OBJ_LABEL, WindowFind("SymbolCheck"), 0, 0);
   ObjectSetText("timef",Symbol(),8, "Verdana",PaleGoldenrod);
   ObjectSet("timef", OBJPROP_CORNER, 0);
   ObjectSet("timef", OBJPROP_XDISTANCE, 6);
   ObjectSet("timef", OBJPROP_YDISTANCE, 14);

   ObjectCreate("line1", OBJ_LABEL, WindowFind("SymbolCheck"), 0, 0);
   ObjectSetText("line1","------------------------------------------------------",6, "Verdana", White);
   ObjectSet("line1", OBJPROP_CORNER, 0);
   ObjectSet("line1", OBJPROP_XDISTANCE, 6);
   ObjectSet("line1", OBJPROP_YDISTANCE, 24);
   ObjectCreate("line2", OBJ_LABEL, WindowFind("SymbolCheck"), 0, 0);
   ObjectSetText("line2","-------------------------------------------------------------------------",6, "Verdana", White);
   ObjectSet("line2", OBJPROP_CORNER, 0);
   ObjectSet("line2", OBJPROP_XDISTANCE, 221);
   ObjectSet("line2", OBJPROP_YDISTANCE, 24);
   Comment("Horse Technology @copyright\nhttps://www.horsegroup.net/\nOpen Account: https://secure.horsegroup.net/register/");
   return(INIT_SUCCEEDED);
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
   string text;
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
   text=StringConcatenate("Day: ",DoubleToString(DayPercentage,2)," %");
   ObjectCreate("DayChange", OBJ_LABEL, WindowFind("SymbolCheck"), 0, 0);
   ObjectSetText("DayChange",text,9, "Verdana", color_indic);
   ObjectSet("DayChange", OBJPROP_CORNER, 0);
   ObjectSet("DayChange", OBJPROP_XDISTANCE, 70);
   ObjectSet("DayChange", OBJPROP_YDISTANCE, 13);
//---Yesterday change
   double YesOpen=iOpen(NULL,PERIOD_D1,1);
   double YesClose=iClose(NULL,PERIOD_D1,1);
   double YesPercentage=(YesClose-YesOpen)/YesOpen*100;
   double YesPoint=(YesClose-YesOpen)/MarketInfo(NULL,MODE_POINT)/10;
   //if(askprice>2) YesPoint=YesPoint/1000;
   if(YesPercentage>=0)
     {
      color_indic = Lime;
     }
   else
     {
      color_indic = Red;
     }
   ObjectCreate("YesChange", OBJ_LABEL, WindowFind("SymbolCheck"), 0, 0);
   text=StringConcatenate("Yesterday: ",DoubleToString(YesPercentage,2)," % ("+DoubleToStr(YesPoint,0)+" pips)");
   ObjectSetText("YesChange",text,9, "Verdana", color_indic);
   ObjectSet("YesChange", OBJPROP_CORNER, 0);
   ObjectSet("YesChange", OBJPROP_XDISTANCE, 170);
   ObjectSet("YesChange", OBJPROP_YDISTANCE, 13);
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
   ObjectCreate("WeekChange", OBJ_LABEL, WindowFind("SymbolCheck"), 0, 0);
   text=StringConcatenate("Week: ",DoubleToString(WeekPercentage,2)," %");
   ObjectSetText("WeekChange",text,9, "Verdana", color_indic);
   ObjectSet("WeekChange", OBJPROP_CORNER, 0);
   ObjectSet("WeekChange", OBJPROP_XDISTANCE, 370);
   ObjectSet("WeekChange", OBJPROP_YDISTANCE, 13);
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
   ObjectCreate("MonthChange", OBJ_LABEL, WindowFind("SymbolCheck"), 0, 0);
   text=StringConcatenate("Month: ",DoubleToString(MonthPercentage,2)," %");
   ObjectSetText("MonthChange",text,9, "Verdana", color_indic);
   ObjectSet("MonthChange", OBJPROP_CORNER, 0);
   ObjectSet("MonthChange", OBJPROP_XDISTANCE, 480);
   ObjectSet("MonthChange", OBJPROP_YDISTANCE, 13);
   
////=============================================================
////=====   custom symbol not for loop
////==============================================================
   //customsymbol[2]='GBPUSD','AUDUSD';

   int j=1;
   string text1;
   color color_indic1;
   double askpricec=SymbolInfoDouble(symbol1,SYMBOL_ASK);
   //printf(askpricec);
   ObjectCreate("timeframe1", OBJ_LABEL, WindowFind("SymbolCheck"), 0, 0);
   ObjectSetText("timeframe1",symbol1,8, "Verdana",PaleGoldenrod);
   ObjectSet("timeframe1", OBJPROP_CORNER, 0);
   ObjectSet("timeframe1", OBJPROP_XDISTANCE, 6);
   ObjectSet("timeframe1", OBJPROP_YDISTANCE, 13+j*20);   
//---day change between yesterday close price and current price
   double DayOpenc=iOpen(symbol1,PERIOD_D1,0);
   double DayClosec=iClose(symbol1,PERIOD_D1,1);
   double DayPercentagec=(askpricec-DayClosec)/DayClosec*100;
   if(DayPercentagec>=0)
     {
      color_indic1 = Lime;
     }
   else
     {
      color_indic1 = Red;
     }
   text1=StringConcatenate("Day: ",DoubleToString(DayPercentagec,2)," %");
   ObjectCreate("DayChange1", OBJ_LABEL, WindowFind("SymbolCheck"), 0, 0);
   ObjectSetText("DayChange1",text1,9, "Verdana", color_indic1);
   ObjectSet("DayChange1", OBJPROP_CORNER, 0);
   ObjectSet("DayChange1", OBJPROP_XDISTANCE, 70);
   ObjectSet("DayChange1", OBJPROP_YDISTANCE, 14+j*20);
//---Yesterday change
   double YesOpenc=iOpen(symbol1,PERIOD_D1,1);
   double YesClosec=iClose(symbol1,PERIOD_D1,1);
   double YesPercentagec=(YesClosec-YesOpenc)/YesOpenc*100;
      double YesPointc=(YesClosec-YesOpenc)/MarketInfo(symbol1,MODE_POINT)/10;
   //if(askpricec>2) YesPointc=YesPointc/1000;
   if(YesPercentagec>=0)
     {
      color_indic1 = Lime;
     }
   else
     {
      color_indic1 = Red;
     }
   ObjectCreate("YesChange1", OBJ_LABEL, WindowFind("SymbolCheck"), 0, 0);
   text1=StringConcatenate("Yesterday: ",DoubleToString(YesPercentagec,2)," % ("+DoubleToStr(YesPointc,0)+" pips)");
   ObjectSetText("YesChange1",text1,9, "Verdana", color_indic1);
   ObjectSet("YesChange1", OBJPROP_CORNER, 0);
   ObjectSet("YesChange1", OBJPROP_XDISTANCE, 170);
   ObjectSet("YesChange1", OBJPROP_YDISTANCE, 13+j*20);
//---week change
    double WeekOpenc=iOpen(symbol1,PERIOD_W1,0);
   double WeekClosec=iClose(symbol1,PERIOD_W1,1);
   double WeekPercentagec=(askpricec-WeekOpenc)/WeekClosec*100;
   if(WeekPercentagec>=0)
     {
      color_indic1 = Lime;
     }
   else
     {
      color_indic1 = Red;
     }
   ObjectCreate("WeekChange1", OBJ_LABEL, WindowFind("SymbolCheck"), 0, 0);
   text1=StringConcatenate("Week: ",DoubleToString(WeekPercentagec,2)," %");
   ObjectSetText("WeekChange1",text1,9, "Verdana", color_indic1);
   ObjectSet("WeekChange1", OBJPROP_CORNER, 0);
   ObjectSet("WeekChange1", OBJPROP_XDISTANCE, 370);
   ObjectSet("WeekChange1", OBJPROP_YDISTANCE, 13+j*20);
//---Month change
   double MonthOpenc=iOpen(symbol1,PERIOD_MN1,0);
   double MonthClosec=iClose(symbol1,PERIOD_MN1,1);
   double MonthPercentagec=(askpricec-MonthOpenc)/WeekClosec*100;
   if(MonthPercentagec>=0)
     {
      color_indic1 = Lime;
     }
   else
     {
      color_indic1 = Red;
     }
   ObjectCreate("MonthChange1", OBJ_LABEL, WindowFind("SymbolCheck"), 0, 0);
   text1=StringConcatenate("Month: ",DoubleToString(MonthPercentagec,2)," %");
   ObjectSetText("MonthChange1",text1,9, "Verdana", color_indic1);
   ObjectSet("MonthChange1", OBJPROP_CORNER, 0);
   ObjectSet("MonthChange1", OBJPROP_XDISTANCE, 480);
   ObjectSet("MonthChange1", OBJPROP_YDISTANCE, 13+j*20);
////==============================================================   

   j=2;
   string text2;
   color color_indic2;
   double askpricec2=SymbolInfoDouble(symbol2,SYMBOL_ASK);
   //printf(askpricec);
   ObjectCreate("timeframe2", OBJ_LABEL, WindowFind("SymbolCheck"), 0, 0);
   ObjectSetText("timeframe2",symbol2,8, "Verdana",PaleGoldenrod);
   ObjectSet("timeframe2", OBJPROP_CORNER, 0);
   ObjectSet("timeframe2", OBJPROP_XDISTANCE, 6);
   ObjectSet("timeframe2", OBJPROP_YDISTANCE, 13+j*20);   
//---day change between yesterday close price and current price
   double DayOpenc2=iOpen(symbol2,PERIOD_D1,0);
   double DayClosec2=iClose(symbol2,PERIOD_D1,1);
   double DayPercentagec2=(askpricec2-DayClosec2)/DayClosec2*100;
   if(DayPercentagec2>=0)
     {
      color_indic2 = Lime;
     }
   else
     {
      color_indic2 = Red;
     }
   text2=StringConcatenate("Day: ",DoubleToString(DayPercentagec2,2)," %");
   ObjectCreate("DayChange2", OBJ_LABEL, WindowFind("SymbolCheck"), 0, 0);
   ObjectSetText("DayChange2",text2,9, "Verdana", color_indic2);
   ObjectSet("DayChange2", OBJPROP_CORNER, 0);
   ObjectSet("DayChange2", OBJPROP_XDISTANCE, 70);
   ObjectSet("DayChange2", OBJPROP_YDISTANCE, 14+j*20);
//---Yesterday change
   double YesOpenc2=iOpen(symbol2,PERIOD_D1,1);
   double YesClosec2=iClose(symbol2,PERIOD_D1,1);
   double YesPercentagec2=(YesClosec2-YesOpenc2)/YesOpenc2*100;
         double YesPointc2=(YesClosec2-YesOpenc2)/MarketInfo(symbol2,MODE_POINT)/10;
   //if(askpricec2>2) YesPointc2=YesPointc2/1000;
   if(YesPercentagec2>=0)
     {
      color_indic2 = Lime;
     }
   else
     {
      color_indic2 = Red;
     }
   ObjectCreate("YesChange2", OBJ_LABEL, WindowFind("SymbolCheck"), 0, 0);
   text2=StringConcatenate("Yesterday: ",DoubleToString(YesPercentagec2,2)," % ("+DoubleToStr(YesPointc2,0)+" pips)");
   ObjectSetText("YesChange2",text2,9, "Verdana", color_indic1);
   ObjectSet("YesChange2", OBJPROP_CORNER, 0);
   ObjectSet("YesChange2", OBJPROP_XDISTANCE, 170);
   ObjectSet("YesChange2", OBJPROP_YDISTANCE, 13+j*20);
//---week change
    double WeekOpenc2=iOpen(symbol2,PERIOD_W1,0);
   double WeekClosec2=iClose(symbol2,PERIOD_W1,1);
   double WeekPercentagec2=(askpricec2-WeekOpenc2)/WeekClosec2*100;
   if(WeekPercentagec2>=0)
     {
      color_indic2 = Lime;
     }
   else
     {
      color_indic2 = Red;
     }
   ObjectCreate("WeekChange2", OBJ_LABEL, WindowFind("SymbolCheck"), 0, 0);
   text2=StringConcatenate("Week: ",DoubleToString(WeekPercentagec2,2)," %");
   ObjectSetText("WeekChange2",text2,9, "Verdana", color_indic1);
   ObjectSet("WeekChange2", OBJPROP_CORNER, 0);
   ObjectSet("WeekChange2", OBJPROP_XDISTANCE, 370);
   ObjectSet("WeekChange2", OBJPROP_YDISTANCE, 13+j*20);
//---Month change
   double MonthOpenc2=iOpen(symbol2,PERIOD_MN1,0);
   double MonthClosec2=iClose(symbol2,PERIOD_MN1,1);
   double MonthPercentagec2=(askpricec2-MonthOpenc2)/WeekClosec2*100;
   if(MonthPercentagec2>=0)
     {
      color_indic2 = Lime;
     }
   else
     {
      color_indic2 = Red;
     }
   ObjectCreate("MonthChange2", OBJ_LABEL, WindowFind("SymbolCheck"), 0, 0);
   text2=StringConcatenate("Month: ",DoubleToString(MonthPercentagec2,2)," %");
   ObjectSetText("MonthChange2",text2,9, "Verdana", color_indic2);
   ObjectSet("MonthChange2", OBJPROP_CORNER, 0);
   ObjectSet("MonthChange2", OBJPROP_XDISTANCE, 480);
   ObjectSet("MonthChange2", OBJPROP_YDISTANCE, 13+j*20);
////==============================================================   

   j=3;
   string text3;
   color color_indic3;
   double askpricec3=SymbolInfoDouble(symbol3,SYMBOL_ASK);
   //printf(askpricec);
   ObjectCreate("timeframe3", OBJ_LABEL, WindowFind("SymbolCheck"), 0, 0);
   ObjectSetText("timeframe3",symbol3,8, "Verdana",PaleGoldenrod);
   ObjectSet("timeframe3", OBJPROP_CORNER, 0);
   ObjectSet("timeframe3", OBJPROP_XDISTANCE, 6);
   ObjectSet("timeframe3", OBJPROP_YDISTANCE, 13+j*20);   
//---day change between yesterday close price and current price
   double DayOpenc3=iOpen(symbol3,PERIOD_D1,0);
   double DayClosec3=iClose(symbol3,PERIOD_D1,1);
   double DayPercentagec3=(askpricec3-DayClosec3)/DayClosec3*100;
   if(DayPercentagec3>=0)
     {
      color_indic3 = Lime;
     }
   else
     {
      color_indic3 = Red;
     }
   text3=StringConcatenate("Day: ",DoubleToString(DayPercentagec3,2)," %");
   ObjectCreate("DayChange3", OBJ_LABEL, WindowFind("SymbolCheck"), 0, 0);
   ObjectSetText("DayChange3",text3,9, "Verdana", color_indic3);
   ObjectSet("DayChange3", OBJPROP_CORNER, 0);
   ObjectSet("DayChange3", OBJPROP_XDISTANCE, 70);
   ObjectSet("DayChange3", OBJPROP_YDISTANCE, 14+j*20);
//---Yesterday change
   double YesOpenc3=iOpen(symbol3,PERIOD_D1,1);
   double YesClosec3=iClose(symbol3,PERIOD_D1,1);
   double YesPercentagec3=(YesClosec3-YesOpenc3)/YesOpenc3*100;
            double YesPointc3=(YesClosec3-YesOpenc3)/MarketInfo(symbol3,MODE_POINT)/10;
   //if(askpricec3>2) YesPointc3=YesPointc3/1000;
   if(YesPercentagec3>=0)
     {
      color_indic3 = Lime;
     }
   else
     {
      color_indic3 = Red;
     }
   ObjectCreate("YesChange3", OBJ_LABEL, WindowFind("SymbolCheck"), 0, 0);
   text3=StringConcatenate("Yesterday: ",DoubleToString(YesPercentagec3,2)," % ("+DoubleToStr(YesPointc3,0)+" pips)");
   ObjectSetText("YesChange3",text3,9, "Verdana", color_indic3);
   ObjectSet("YesChange3", OBJPROP_CORNER, 0);
   ObjectSet("YesChange3", OBJPROP_XDISTANCE, 170);
   ObjectSet("YesChange3", OBJPROP_YDISTANCE, 13+j*20);
//---week change
    double WeekOpenc3=iOpen(symbol3,PERIOD_W1,0);
   double WeekClosec3=iClose(symbol3,PERIOD_W1,1);
   double WeekPercentagec3=(askpricec3-WeekOpenc3)/WeekClosec3*100;
   if(WeekPercentagec3>=0)
     {
      color_indic3 = Lime;
     }
   else
     {
      color_indic3 = Red;
     }
   ObjectCreate("WeekChange3", OBJ_LABEL, WindowFind("SymbolCheck"), 0, 0);
   text3=StringConcatenate("Week: ",DoubleToString(WeekPercentagec3,2)," %");
   ObjectSetText("WeekChange3",text3,9, "Verdana", color_indic3);
   ObjectSet("WeekChange3", OBJPROP_CORNER, 0);
   ObjectSet("WeekChange3", OBJPROP_XDISTANCE, 370);
   ObjectSet("WeekChange3", OBJPROP_YDISTANCE, 13+j*20);
//---Month change
   double MonthOpenc3=iOpen(symbol3,PERIOD_MN1,0);
   double MonthClosec3=iClose(symbol3,PERIOD_MN1,1);
   double MonthPercentagec3=(askpricec3-MonthOpenc3)/WeekClosec3*100;
   if(MonthPercentagec3>=0)
     {
      color_indic3 = Lime;
     }
   else
     {
      color_indic3 = Red;
     }
   ObjectCreate("MonthChange3", OBJ_LABEL, WindowFind("SymbolCheck"), 0, 0);
   text3=StringConcatenate("Month: ",DoubleToString(MonthPercentagec3,2)," %");
   ObjectSetText("MonthChange3",text3,9, "Verdana", color_indic3);
   ObjectSet("MonthChange3", OBJPROP_CORNER, 0);
   ObjectSet("MonthChange3", OBJPROP_XDISTANCE, 480);
   ObjectSet("MonthChange3", OBJPROP_YDISTANCE, 13+j*20);
   ////==============================================================   

   j=4;
   string text4;
   color color_indic4;
   double askpricec4=SymbolInfoDouble(symbol4,SYMBOL_ASK);
   //printf(askpricec);
   ObjectCreate("timeframe4", OBJ_LABEL, WindowFind("SymbolCheck"), 0, 0);
   ObjectSetText("timeframe4",symbol4,8, "Verdana",PaleGoldenrod);
   ObjectSet("timeframe4", OBJPROP_CORNER, 0);
   ObjectSet("timeframe4", OBJPROP_XDISTANCE, 6);
   ObjectSet("timeframe4", OBJPROP_YDISTANCE, 13+j*20);   
//---day change between yesterday close price and current price
   double DayOpenc4=iOpen(symbol4,PERIOD_D1,0);
   double DayClosec4=iClose(symbol4,PERIOD_D1,1);
   double DayPercentagec4=(askpricec4-DayClosec4)/DayClosec4*100;
   if(DayPercentagec4>=0)
     {
      color_indic4 = Lime;
     }
   else
     {
      color_indic4 = Red;
     }
   text4=StringConcatenate("Day: ",DoubleToString(DayPercentagec4,2)," %");
   ObjectCreate("DayChange4", OBJ_LABEL, WindowFind("SymbolCheck"), 0, 0);
   ObjectSetText("DayChange4",text4,9, "Verdana", color_indic4);
   ObjectSet("DayChange4", OBJPROP_CORNER, 0);
   ObjectSet("DayChange4", OBJPROP_XDISTANCE, 70);
   ObjectSet("DayChange4", OBJPROP_YDISTANCE, 14+j*20);
//---Yesterday change
   double YesOpenc4=iOpen(symbol4,PERIOD_D1,1);
   double YesClosec4=iClose(symbol4,PERIOD_D1,1);
   double YesPercentagec4=(YesClosec4-YesOpenc4)/YesOpenc4*100;
   double YesPointc4=(YesClosec4-YesOpenc4)/MarketInfo(symbol4,MODE_POINT)/10;
   //if(askpricec4>2) YesPointc4=YesPointc4/1000;
   if(YesPercentagec4>=0)
     {
      color_indic4 = Lime;
     }
   else
     {
      color_indic4 = Red;
     }
   ObjectCreate("YesChange4", OBJ_LABEL, WindowFind("SymbolCheck"), 0, 0);
   text4=StringConcatenate("Yesterday: ",DoubleToString(YesPercentagec4,2)," % ("+DoubleToStr(YesPointc4,0)+" pips)");
   ObjectSetText("YesChange4",text4,9, "Verdana", color_indic4);
   ObjectSet("YesChange4", OBJPROP_CORNER, 0);
   ObjectSet("YesChange4", OBJPROP_XDISTANCE, 170);
   ObjectSet("YesChange4", OBJPROP_YDISTANCE, 13+j*20);
//---week change
    double WeekOpenc4=iOpen(symbol4,PERIOD_W1,0);
   double WeekClosec4=iClose(symbol4,PERIOD_W1,1);
   double WeekPercentagec4=(askpricec4-WeekOpenc4)/WeekClosec4*100;
   if(WeekPercentagec4>=0)
     {
      color_indic4 = Lime;
     }
   else
     {
      color_indic4 = Red;
     }
   ObjectCreate("WeekChange4", OBJ_LABEL, WindowFind("SymbolCheck"), 0, 0);
   text4=StringConcatenate("Week: ",DoubleToString(WeekPercentagec4,2)," %");
   ObjectSetText("WeekChange4",text4,9, "Verdana", color_indic4);
   ObjectSet("WeekChange4", OBJPROP_CORNER, 0);
   ObjectSet("WeekChange4", OBJPROP_XDISTANCE, 370);
   ObjectSet("WeekChange4", OBJPROP_YDISTANCE, 13+j*20);
//---Month change
   double MonthOpenc4=iOpen(symbol4,PERIOD_MN1,0);
   double MonthClosec4=iClose(symbol4,PERIOD_MN1,1);
   double MonthPercentagec4=(askpricec4-MonthOpenc4)/WeekClosec4*100;
   if(MonthPercentagec4>=0)
     {
      color_indic4 = Lime;
     }
   else
     {
      color_indic4 = Red;
     }
   ObjectCreate("MonthChange4", OBJ_LABEL, WindowFind("SymbolCheck"), 0, 0);
   text4=StringConcatenate("Month: ",DoubleToString(MonthPercentagec4,2)," %");
   ObjectSetText("MonthChange4",text4,9, "Verdana", color_indic4);
   ObjectSet("MonthChange4", OBJPROP_CORNER, 0);
   ObjectSet("MonthChange4", OBJPROP_XDISTANCE, 480);
   ObjectSet("MonthChange4", OBJPROP_YDISTANCE, 13+j*20);
//=========================================================================
   j=5;
   string text5;
   color color_indic5;
   double askpricec5=SymbolInfoDouble(symbol5,SYMBOL_ASK);
   //printf(askpricec);
   ObjectCreate("timeframe5", OBJ_LABEL, WindowFind("SymbolCheck"), 0, 0);
   ObjectSetText("timeframe5",symbol5,8, "Verdana",PaleGoldenrod);
   ObjectSet("timeframe5", OBJPROP_CORNER, 0);
   ObjectSet("timeframe5", OBJPROP_XDISTANCE, 6);
   ObjectSet("timeframe5", OBJPROP_YDISTANCE, 13+j*20);   
//---day change between yesterday close price and current price
   double DayOpenc5=iOpen(symbol5,PERIOD_D1,0);
   double DayClosec5=iClose(symbol5,PERIOD_D1,1);
   double DayPercentagec5=(askpricec5-DayClosec5)/DayClosec5*100;
   if(DayPercentagec5>=0)
     {
      color_indic5 = Lime;
     }
   else
     {
      color_indic5 = Red;
     }
   text5=StringConcatenate("Day: ",DoubleToString(DayPercentagec5,2)," %");
   ObjectCreate("DayChange5", OBJ_LABEL, WindowFind("SymbolCheck"), 0, 0);
   ObjectSetText("DayChange5",text5,9, "Verdana", color_indic5);
   ObjectSet("DayChange5", OBJPROP_CORNER, 0);
   ObjectSet("DayChange5", OBJPROP_XDISTANCE, 70);
   ObjectSet("DayChange5", OBJPROP_YDISTANCE, 14+j*20);
//---Yesterday change
   double YesOpenc5=iOpen(symbol5,PERIOD_D1,1);
   double YesClosec5=iClose(symbol5,PERIOD_D1,1);
   double YesPercentagec5=(YesClosec5-YesOpenc5)/YesOpenc5*100;
   double YesPointc5=(YesClosec5-YesOpenc5)/MarketInfo(symbol5,MODE_POINT)/10 ;
   //if(askpricec5>2) YesPointc5=YesPointc5/1000;
   if(YesPercentagec5>=0)
     {
      color_indic5 = Lime;
     }
   else
     {
      color_indic5 = Red;
     }
   ObjectCreate("YesChange5", OBJ_LABEL, WindowFind("SymbolCheck"), 0, 0);
   text5=StringConcatenate("Yesterday: ",DoubleToString(YesPercentagec5,2)," % ("+DoubleToStr(YesPointc5,0)+" pips)");
   ObjectSetText("YesChange5",text5,9, "Verdana", color_indic5);
   ObjectSet("YesChange5", OBJPROP_CORNER, 0);
   ObjectSet("YesChange5", OBJPROP_XDISTANCE, 170);
   ObjectSet("YesChange5", OBJPROP_YDISTANCE, 13+j*20);
//---week change
    double WeekOpenc5=iOpen(symbol5,PERIOD_W1,0);
   double WeekClosec5=iClose(symbol5,PERIOD_W1,1);
   double WeekPercentagec5=(askpricec5-WeekOpenc5)/WeekClosec5*100;
   if(WeekPercentagec5>=0)
     {
      color_indic5 = Lime;
     }
   else
     {
      color_indic5 = Red;
     }
   ObjectCreate("WeekChange5", OBJ_LABEL, WindowFind("SymbolCheck"), 0, 0);
   text5=StringConcatenate("Week: ",DoubleToString(WeekPercentagec5,2)," %");
   ObjectSetText("WeekChange5",text5,9, "Verdana", color_indic5);
   ObjectSet("WeekChange5", OBJPROP_CORNER, 0);
   ObjectSet("WeekChange5", OBJPROP_XDISTANCE, 370);
   ObjectSet("WeekChange5", OBJPROP_YDISTANCE, 13+j*20);
//---Month change
   double MonthOpenc5=iOpen(symbol5,PERIOD_MN1,0);
   double MonthClosec5=iClose(symbol5,PERIOD_MN1,1);
   double MonthPercentagec5=(askpricec5-MonthOpenc5)/WeekClosec5*100;
   if(MonthPercentagec5>=0)
     {
      color_indic5 = Lime;
     }
   else
     {
      color_indic5 = Red;
     }
   ObjectCreate("MonthChange5", OBJ_LABEL, WindowFind("SymbolCheck"), 0, 0);
   text5=StringConcatenate("Month: ",DoubleToString(MonthPercentagec5,2)," %");
   ObjectSetText("MonthChange5",text5,9, "Verdana", color_indic5);
   ObjectSet("MonthChange5", OBJPROP_CORNER, 0);
   ObjectSet("MonthChange5", OBJPROP_XDISTANCE, 480);
   ObjectSet("MonthChange5", OBJPROP_YDISTANCE, 13+j*20);   
   //=========================================================================
   j=6;
   string text6;
   color color_indic6;
   double askpricec6=SymbolInfoDouble(symbol6,SYMBOL_ASK);
   //printf(askpricec);
   ObjectCreate("timeframe6", OBJ_LABEL, WindowFind("SymbolCheck"), 0, 0);
   ObjectSetText("timeframe6",symbol6,8, "Verdana",PaleGoldenrod);
   ObjectSet("timeframe6", OBJPROP_CORNER, 0);
   ObjectSet("timeframe6", OBJPROP_XDISTANCE, 6);
   ObjectSet("timeframe6", OBJPROP_YDISTANCE, 13+j*20);   
//---day change between yesterday close price and current price
   double DayOpenc6=iOpen(symbol6,PERIOD_D1,0);
   double DayClosec6=iClose(symbol6,PERIOD_D1,1);
   double DayPercentagec6=(askpricec6-DayClosec6)/DayClosec6*100;
   if(DayPercentagec6>=0)
     {
      color_indic6 = Lime;
     }
   else
     {
      color_indic6 = Red;
     }
   text6=StringConcatenate("Day: ",DoubleToString(DayPercentagec6,2)," %");
   ObjectCreate("DayChange6", OBJ_LABEL, WindowFind("SymbolCheck"), 0, 0);
   ObjectSetText("DayChange6",text6,9, "Verdana", color_indic6);
   ObjectSet("DayChange6", OBJPROP_CORNER, 0);
   ObjectSet("DayChange6", OBJPROP_XDISTANCE, 70);
   ObjectSet("DayChange6", OBJPROP_YDISTANCE, 14+j*20);
//---Yesterday change
   double YesOpenc6=iOpen(symbol6,PERIOD_D1,1);
   double YesClosec6=iClose(symbol6,PERIOD_D1,1);
   double YesPercentagec6=(YesClosec6-YesOpenc6)/YesOpenc6*100;
      double YesPointc6=(YesClosec6-YesOpenc6)/MarketInfo(symbol6,MODE_POINT)/10 ;
   //if(askpricec6>2) YesPointc6=YesPointc6/1000;
   if(YesPercentagec6>=0)
     {
      color_indic6 = Lime;
     }
   else
     {
      color_indic6 = Red;
     }
   ObjectCreate("YesChange6", OBJ_LABEL, WindowFind("SymbolCheck"), 0, 0);
   text6=StringConcatenate("Yesterday: ",DoubleToString(YesPercentagec6,2)," % ("+DoubleToStr(YesPointc6,0)+" pips)");
   ObjectSetText("YesChange6",text6,9, "Verdana", color_indic6);
   ObjectSet("YesChange6", OBJPROP_CORNER, 0);
   ObjectSet("YesChange6", OBJPROP_XDISTANCE, 170);
   ObjectSet("YesChange6", OBJPROP_YDISTANCE, 13+j*20);
//---week change
    double WeekOpenc6=iOpen(symbol6,PERIOD_W1,0);
   double WeekClosec6=iClose(symbol6,PERIOD_W1,1);
   double WeekPercentagec6=(askpricec6-WeekOpenc6)/WeekClosec6*100;
   if(WeekPercentagec6>=0)
     {
      color_indic6 = Lime;
     }
   else
     {
      color_indic6 = Red;
     }
   ObjectCreate("WeekChange6", OBJ_LABEL, WindowFind("SymbolCheck"), 0, 0);
   text6=StringConcatenate("Week: ",DoubleToString(WeekPercentagec6,2)," %");
   ObjectSetText("WeekChange6",text6,9, "Verdana", color_indic6);
   ObjectSet("WeekChange6", OBJPROP_CORNER, 0);
   ObjectSet("WeekChange6", OBJPROP_XDISTANCE, 370);
   ObjectSet("WeekChange6", OBJPROP_YDISTANCE, 13+j*20);
//---Month change
   double MonthOpenc6=iOpen(symbol6,PERIOD_MN1,0);
   double MonthClosec6=iClose(symbol6,PERIOD_MN1,1);
   double MonthPercentagec6=(askpricec6-MonthOpenc6)/WeekClosec6*100;
   if(MonthPercentagec6>=0)
     {
      color_indic6 = Lime;
     }
   else
     {
      color_indic6 = Red;
     }
   ObjectCreate("MonthChange6", OBJ_LABEL, WindowFind("SymbolCheck"), 0, 0);
   text6=StringConcatenate("Month: ",DoubleToString(MonthPercentagec6,2)," %");
   ObjectSetText("MonthChange6",text6,9, "Verdana", color_indic6);
   ObjectSet("MonthChange6", OBJPROP_CORNER, 0);
   ObjectSet("MonthChange6", OBJPROP_XDISTANCE, 480);
   ObjectSet("MonthChange6", OBJPROP_YDISTANCE, 13+j*20);   
      //=========================================================================
   j=7;
   string text7;
   color color_indic7;
   double askpricec7=SymbolInfoDouble(symbol7,SYMBOL_ASK);
   //printf(askpricec);
   ObjectCreate("timeframe7", OBJ_LABEL, WindowFind("SymbolCheck"), 0, 0);
   ObjectSetText("timeframe7",symbol7,8, "Verdana",PaleGoldenrod);
   ObjectSet("timeframe7", OBJPROP_CORNER, 0);
   ObjectSet("timeframe7", OBJPROP_XDISTANCE, 6);
   ObjectSet("timeframe7", OBJPROP_YDISTANCE, 13+j*20);   
//---day change between yesterday close price and current price
   double DayOpenc7=iOpen(symbol7,PERIOD_D1,0);
   double DayClosec7=iClose(symbol7,PERIOD_D1,1);
   double DayPercentagec7=(askpricec7-DayClosec7)/DayClosec7*100;
   if(DayPercentagec7>=0)
     {
      color_indic7 = Lime;
     }
   else
     {
      color_indic7 = Red;
     }
   text7=StringConcatenate("Day: ",DoubleToString(DayPercentagec7,2)," %");
   ObjectCreate("DayChange7", OBJ_LABEL, WindowFind("SymbolCheck"), 0, 0);
   ObjectSetText("DayChange7",text7,9, "Verdana", color_indic7);
   ObjectSet("DayChange7", OBJPROP_CORNER, 0);
   ObjectSet("DayChange7", OBJPROP_XDISTANCE, 70);
   ObjectSet("DayChange7", OBJPROP_YDISTANCE, 14+j*20);
//---Yesterday change
   double YesOpenc7=iOpen(symbol7,PERIOD_D1,1);
   double YesClosec7=iClose(symbol7,PERIOD_D1,1);
   double YesPercentagec7=(YesClosec7-YesOpenc7)/YesOpenc7*100;
   double YesPointc7=(YesClosec7-YesOpenc7)/MarketInfo(symbol7,MODE_POINT)/10 ;
   //if(askpricec7>2) YesPointc7=YesPointc7/1000;
   if(YesPercentagec7>=0)
     {
      color_indic7 = Lime;
     }
   else
     {
      color_indic7 = Red;
     }
   ObjectCreate("YesChange7", OBJ_LABEL, WindowFind("SymbolCheck"), 0, 0);
   text7=StringConcatenate("Yesterday: ",DoubleToString(YesPercentagec7,2)," % ("+DoubleToStr(YesPointc7,0)+" pips)");
   ObjectSetText("YesChange7",text7,9, "Verdana", color_indic7);
   ObjectSet("YesChange7", OBJPROP_CORNER, 0);
   ObjectSet("YesChange7", OBJPROP_XDISTANCE, 170);
   ObjectSet("YesChange7", OBJPROP_YDISTANCE, 13+j*20);
//---week change
    double WeekOpenc7=iOpen(symbol7,PERIOD_W1,0);
   double WeekClosec7=iClose(symbol7,PERIOD_W1,1);
   double WeekPercentagec7=(askpricec7-WeekOpenc7)/WeekClosec7*100;
   if(WeekPercentagec7>=0)
     {
      color_indic7 = Lime;
     }
   else
     {
      color_indic7 = Red;
     }
   ObjectCreate("WeekChange7", OBJ_LABEL, WindowFind("SymbolCheck"), 0, 0);
   text7=StringConcatenate("Week: ",DoubleToString(WeekPercentagec7,2)," %");
   ObjectSetText("WeekChange7",text7,9, "Verdana", color_indic7);
   ObjectSet("WeekChange7", OBJPROP_CORNER, 0);
   ObjectSet("WeekChange7", OBJPROP_XDISTANCE, 370);
   ObjectSet("WeekChange7", OBJPROP_YDISTANCE, 13+j*20);
//---Month change
   double MonthOpenc7=iOpen(symbol7,PERIOD_MN1,0);
   double MonthClosec7=iClose(symbol7,PERIOD_MN1,1);
   double MonthPercentagec7=(askpricec7-MonthOpenc7)/WeekClosec7*100;
   if(MonthPercentagec7>=0)
     {
      color_indic7 = Lime;
     }
   else
     {
      color_indic7 = Red;
     }
   ObjectCreate("MonthChange7", OBJ_LABEL, WindowFind("SymbolCheck"), 0, 0);
   text7=StringConcatenate("Month: ",DoubleToString(MonthPercentagec7,2)," %");
   ObjectSetText("MonthChange7",text7,9, "Verdana", color_indic7);
   ObjectSet("MonthChange7", OBJPROP_CORNER, 0);
   ObjectSet("MonthChange7", OBJPROP_XDISTANCE, 480);
   ObjectSet("MonthChange7", OBJPROP_YDISTANCE, 13+j*20); 
         //=========================================================================
   j=8;
   string text8;
   color color_indic8;
   double askpricec8=SymbolInfoDouble(symbol8,SYMBOL_ASK);
   //printf(askpricec);
   ObjectCreate("timeframe8", OBJ_LABEL, WindowFind("SymbolCheck"), 0, 0);
   ObjectSetText("timeframe8",symbol8,8, "Verdana",PaleGoldenrod);
   ObjectSet("timeframe8", OBJPROP_CORNER, 0);
   ObjectSet("timeframe8", OBJPROP_XDISTANCE, 6);
   ObjectSet("timeframe8", OBJPROP_YDISTANCE, 13+j*20);   
//---day change between yesterday close price and current price
   double DayOpenc8=iOpen(symbol8,PERIOD_D1,0);
   double DayClosec8=iClose(symbol8,PERIOD_D1,1);
   double DayPercentagec8=(askpricec8-DayClosec8)/DayClosec8*100;
   if(DayPercentagec8>=0)
     {
      color_indic8 = Lime;
     }
   else
     {
      color_indic8 = Red;
     }
   text8=StringConcatenate("Day: ",DoubleToString(DayPercentagec8,2)," %");
   ObjectCreate("DayChange8", OBJ_LABEL, WindowFind("SymbolCheck"), 0, 0);
   ObjectSetText("DayChange8",text8,9, "Verdana", color_indic8);
   ObjectSet("DayChange8", OBJPROP_CORNER, 0);
   ObjectSet("DayChange8", OBJPROP_XDISTANCE, 70);
   ObjectSet("DayChange8", OBJPROP_YDISTANCE, 14+j*20);
//---Yesterday change
   double YesOpenc8=iOpen(symbol8,PERIOD_D1,1);
   double YesClosec8=iClose(symbol8,PERIOD_D1,1);
   double YesPercentagec8=(YesClosec8-YesOpenc8)/YesOpenc8*100;
      double YesPointc8=(YesClosec8-YesOpenc8)/MarketInfo(symbol8,MODE_POINT)/10 ;
   //YesPointc8=YesPointc8/10;
   if(YesPercentagec8>=0)
     {
      color_indic8 = Lime;
     }
   else
     {
      color_indic8 = Red;
     }
   ObjectCreate("YesChange8", OBJ_LABEL, WindowFind("SymbolCheck"), 0, 0);
   text8=StringConcatenate("Yesterday: ",DoubleToString(YesPercentagec8,2)," % ("+DoubleToStr(YesPointc8,0)+" pips)");
   ObjectSetText("YesChange8",text8,9, "Verdana", color_indic8);
   ObjectSet("YesChange8", OBJPROP_CORNER, 0);
   ObjectSet("YesChange8", OBJPROP_XDISTANCE, 170);
   ObjectSet("YesChange8", OBJPROP_YDISTANCE, 13+j*20);
//---week change
    double WeekOpenc8=iOpen(symbol8,PERIOD_W1,0);
   double WeekClosec8=iClose(symbol8,PERIOD_W1,1);
   double WeekPercentagec8=(askpricec8-WeekOpenc8)/WeekClosec8*100;
   if(WeekPercentagec8>=0)
     {
      color_indic8 = Lime;
     }
   else
     {
      color_indic8 = Red;
     }
   ObjectCreate("WeekChange8", OBJ_LABEL, WindowFind("SymbolCheck"), 0, 0);
   text8=StringConcatenate("Week: ",DoubleToString(WeekPercentagec8,2)," %");
   ObjectSetText("WeekChange8",text8,9, "Verdana", color_indic8);
   ObjectSet("WeekChange8", OBJPROP_CORNER, 0);
   ObjectSet("WeekChange8", OBJPROP_XDISTANCE, 370);
   ObjectSet("WeekChange8", OBJPROP_YDISTANCE, 13+j*20);
//---Month change
   double MonthOpenc8=iOpen(symbol8,PERIOD_MN1,0);
   double MonthClosec8=iClose(symbol8,PERIOD_MN1,1);
   double MonthPercentagec8=(askpricec8-MonthOpenc8)/WeekClosec8*100;
   if(MonthPercentagec8>=0)
     {
      color_indic8 = Lime;
     }
   else
     {
      color_indic8 = Red;
     }
   ObjectCreate("MonthChange8", OBJ_LABEL, WindowFind("SymbolCheck"), 0, 0);
   text8=StringConcatenate("Month: ",DoubleToString(MonthPercentagec8,2)," %");
   ObjectSetText("MonthChange8",text8,9, "Verdana", color_indic7);
   ObjectSet("MonthChange8", OBJPROP_CORNER, 0);
   ObjectSet("MonthChange8", OBJPROP_XDISTANCE, 480);
   ObjectSet("MonthChange8", OBJPROP_YDISTANCE, 13+j*20); 
//=========================================================================
   j=9;
   string text9;
   color color_indic9;
   double askpricec9=SymbolInfoDouble(symbol9,SYMBOL_ASK);
   //printf(askpricec);
   ObjectCreate("timeframe9", OBJ_LABEL, WindowFind("SymbolCheck"), 0, 0);
   ObjectSetText("timeframe9",symbol9,8, "Verdana",PaleGoldenrod);
   ObjectSet("timeframe9", OBJPROP_CORNER, 0);
   ObjectSet("timeframe9", OBJPROP_XDISTANCE, 6);
   ObjectSet("timeframe9", OBJPROP_YDISTANCE, 13+j*20);   
//---day change between yesterday close price and current price
   double DayOpenc9=iOpen(symbol9,PERIOD_D1,0);
   double DayClosec9=iClose(symbol9,PERIOD_D1,1);
   double DayPercentagec9=(askpricec9-DayClosec9)/DayClosec9*100;
   if(DayPercentagec9>=0)
     {
      color_indic9 = Lime;
     }
   else
     {
      color_indic9 = Red;
     }
   text9=StringConcatenate("Day: ",DoubleToString(DayPercentagec9,2)," %");
   ObjectCreate("DayChange9", OBJ_LABEL, WindowFind("SymbolCheck"), 0, 0);
   ObjectSetText("DayChange9",text9,9, "Verdana", color_indic8);
   ObjectSet("DayChange9", OBJPROP_CORNER, 0);
   ObjectSet("DayChange9", OBJPROP_XDISTANCE, 70);
   ObjectSet("DayChange9", OBJPROP_YDISTANCE, 14+j*20);
//---Yesterday change
   double YesOpenc9=iOpen(symbol9,PERIOD_D1,1);
   double YesClosec9=iClose(symbol9,PERIOD_D1,1);
   double YesPercentagec9=(YesClosec9-YesOpenc9)/YesOpenc9*100;
      double YesPointc9=(YesClosec9-YesOpenc9)/MarketInfo(symbol9,MODE_POINT)/10 ;
   //YesPointc8=YesPointc8/10;
   if(YesPercentagec9>=0)
     {
      color_indic9 = Lime;
     }
   else
     {
      color_indic9 = Red;
     }
   ObjectCreate("YesChange9", OBJ_LABEL, WindowFind("SymbolCheck"), 0, 0);
   text9=StringConcatenate("Yesterday: ",DoubleToString(YesPercentagec9,2)," % ("+DoubleToStr(YesPointc9,0)+" pips)");
   ObjectSetText("YesChange9",text9,9, "Verdana", color_indic9);
   ObjectSet("YesChange9", OBJPROP_CORNER, 0);
   ObjectSet("YesChange9", OBJPROP_XDISTANCE, 170);
   ObjectSet("YesChange9", OBJPROP_YDISTANCE, 13+j*20);
//---week change
    double WeekOpenc9=iOpen(symbol9,PERIOD_W1,0);
   double WeekClosec9=iClose(symbol9,PERIOD_W1,1);
   double WeekPercentagec9=(askpricec9-WeekOpenc9)/WeekClosec9*100;
   if(WeekPercentagec9>=0)
     {
      color_indic9 = Lime;
     }
   else
     {
      color_indic9 = Red;
     }
   ObjectCreate("WeekChange9", OBJ_LABEL, WindowFind("SymbolCheck"), 0, 0);
   text9=StringConcatenate("Week: ",DoubleToString(WeekPercentagec9,2)," %");
   ObjectSetText("WeekChange9",text9,9, "Verdana", color_indic9);
   ObjectSet("WeekChange9", OBJPROP_CORNER, 0);
   ObjectSet("WeekChange9", OBJPROP_XDISTANCE, 370);
   ObjectSet("WeekChange9", OBJPROP_YDISTANCE, 13+j*20);
//---Month change
   double MonthOpenc9=iOpen(symbol9,PERIOD_MN1,0);
   double MonthClosec9=iClose(symbol9,PERIOD_MN1,1);
   double MonthPercentagec9=(askpricec9-MonthOpenc9)/WeekClosec9*100;
   if(MonthPercentagec8>=0)
     {
      color_indic9 = Lime;
     }
   else
     {
      color_indic9 = Red;
     }
   ObjectCreate("MonthChange9", OBJ_LABEL, WindowFind("SymbolCheck"), 0, 0);
   text9=StringConcatenate("Month: ",DoubleToString(MonthPercentagec9,2)," %");
   ObjectSetText("MonthChange9",text9,9, "Verdana", color_indic9);
   ObjectSet("MonthChange9", OBJPROP_CORNER, 0);
   ObjectSet("MonthChange9", OBJPROP_XDISTANCE, 480);
   ObjectSet("MonthChange9", OBJPROP_YDISTANCE, 13+j*20); 
//=========================================================================
   j=10;
   string text10;
   color color_indic10;
   double askpricec10=SymbolInfoDouble(symbol10,SYMBOL_ASK);
   //printf(askpricec);
   ObjectCreate("timeframe10", OBJ_LABEL, WindowFind("SymbolCheck"), 0, 0);
   ObjectSetText("timeframe10",symbol10,8, "Verdana",PaleGoldenrod);
   ObjectSet("timeframe10", OBJPROP_CORNER, 0);
   ObjectSet("timeframe10", OBJPROP_XDISTANCE, 6);
   ObjectSet("timeframe10", OBJPROP_YDISTANCE, 13+j*20);   
//---day change between yesterday close price and current price
   double DayOpenc10=iOpen(symbol10,PERIOD_D1,0);
   double DayClosec10=iClose(symbol10,PERIOD_D1,1);
   double DayPercentagec10=(askpricec10-DayClosec10)/DayClosec10*100;
   if(DayPercentagec10>=0)
     {
      color_indic10 = Lime;
     }
   else
     {
      color_indic10 = Red;
     }
   text10=StringConcatenate("Day: ",DoubleToString(DayPercentagec10,2)," %");
   ObjectCreate("DayChange10", OBJ_LABEL, WindowFind("SymbolCheck"), 0, 0);
   ObjectSetText("DayChange10",text10,9, "Verdana", color_indic10);
   ObjectSet("DayChange10", OBJPROP_CORNER, 0);
   ObjectSet("DayChange10", OBJPROP_XDISTANCE, 70);
   ObjectSet("DayChange10", OBJPROP_YDISTANCE, 14+j*20);
//---Yesterday change
   double YesOpenc10=iOpen(symbol10,PERIOD_D1,1);
   double YesClosec10=iClose(symbol10,PERIOD_D1,1);
   double YesPercentagec10=(YesClosec10-YesOpenc10)/YesOpenc10*100;
      double YesPointc10=(YesClosec10-YesOpenc10)/MarketInfo(symbol10,MODE_POINT)/10 ;
   //YesPointc8=YesPointc8/10;
   if(YesPercentagec10>=0)
     {
      color_indic10 = Lime;
     }
   else
     {
      color_indic10 = Red;
     }
   ObjectCreate("YesChange10", OBJ_LABEL, WindowFind("SymbolCheck"), 0, 0);
   text10=StringConcatenate("Yesterday: ",DoubleToString(YesPercentagec10,2)," % ("+DoubleToStr(YesPointc10,0)+" pips)");
   ObjectSetText("YesChange10",text10,9, "Verdana", color_indic10);
   ObjectSet("YesChange10", OBJPROP_CORNER, 0);
   ObjectSet("YesChange10", OBJPROP_XDISTANCE, 170);
   ObjectSet("YesChange10", OBJPROP_YDISTANCE, 13+j*20);
//---week change
    double WeekOpenc10=iOpen(symbol10,PERIOD_W1,0);
   double WeekClosec10=iClose(symbol10,PERIOD_W1,1);
   double WeekPercentagec10=(askpricec10-WeekOpenc10)/WeekClosec10*100;
   if(WeekPercentagec10>=0)
     {
      color_indic10 = Lime;
     }
   else
     {
      color_indic10 = Red;
     }
   ObjectCreate("WeekChange10", OBJ_LABEL, WindowFind("SymbolCheck"), 0, 0);
   text10=StringConcatenate("Week: ",DoubleToString(WeekPercentagec10,2)," %");
   ObjectSetText("WeekChange10",text10,9, "Verdana", color_indic10);
   ObjectSet("WeekChange10", OBJPROP_CORNER, 0);
   ObjectSet("WeekChange10", OBJPROP_XDISTANCE, 370);
   ObjectSet("WeekChange10", OBJPROP_YDISTANCE, 13+j*20);
//---Month change
   double MonthOpenc10=iOpen(symbol10,PERIOD_MN1,0);
   double MonthClosec10=iClose(symbol10,PERIOD_MN1,1);
   double MonthPercentagec10=(askpricec10-MonthOpenc10)/WeekClosec10*100;
   if(MonthPercentagec10>=0)
     {
      color_indic10 = Lime;
     }
   else
     {
      color_indic10 = Red;
     }
   ObjectCreate("MonthChange10", OBJ_LABEL, WindowFind("SymbolCheck"), 0, 0);
   text10=StringConcatenate("Month: ",DoubleToString(MonthPercentagec10,2)," %");
   ObjectSetText("MonthChange10",text10,9, "Verdana", color_indic10);
   ObjectSet("MonthChange10", OBJPROP_CORNER, 0);
   ObjectSet("MonthChange10", OBJPROP_XDISTANCE, 480);
   ObjectSet("MonthChange10", OBJPROP_YDISTANCE, 13+j*20); 
////=============================================================
////=====   custom symbol for loop failure
////==============================================================
/*   customsymbol[0]="GBPUSD";

   for(int j=0; j<2; j++) //if(j!=7&&j!=9){tempj++;}
   {
   ObjectCreate("timeframe"+IntegerToString(j), OBJ_LABEL, WindowFind("SymbolCheck"), 0, 0);
   ObjectSetText("timeframe",customsymbol[j],8, "Verdana",PaleGoldenrod);
   ObjectSet("timeframe"+IntegerToString(j), OBJPROP_CORNER, 0);
   ObjectSet("timeframe"+IntegerToString(j), OBJPROP_XDISTANCE, 6);
   ObjectSet("timeframe"+IntegerToString(j), OBJPROP_YDISTANCE, 24+j*10);   
   double askpricec=SymbolInfoDouble(customsymbol[j],SYMBOL_ASK);

//---day change between yesterday close price and current price
   double DayOpenc=iOpen(customsymbol[j],PERIOD_D1,0);
   double DayClosec=iClose(customsymbol[j],PERIOD_D1,1);
   double DayPercentagec=(askpricec-DayClosec)/DayClosec*100;
   if(DayPercentagec>=0)
     {
      color_indic = Lime;
     }
   else
     {
      color_indic = Red;
     }
   text=StringConcatenate("Day: ",DoubleToString(DayPercentagec,2)," %");
   ObjectCreate("DayChange"+IntegerToString(j), OBJ_LABEL, WindowFind("SymbolCheck"), 0, 0);
   ObjectSetText("DayChange",text,9, "Verdana", color_indic);
   ObjectSet("DayChange"+IntegerToString(j), OBJPROP_CORNER, 0);
   ObjectSet("DayChange"+IntegerToString(j), OBJPROP_XDISTANCE, 70);
   ObjectSet("DayChange"+IntegerToString(j), OBJPROP_YDISTANCE, 13+j*10);
//---Yesterday change
   double YesOpenc=iOpen(customsymbol[j],PERIOD_D1,1);
   double YesClosec=iClose(customsymbol[j],PERIOD_D1,1);
   double YesPercentagec=(YesClosec-YesOpenc)/YesOpenc*100;
   if(YesPercentagec>=0)
     {
      color_indic = Lime;
     }
   else
     {
      color_indic = Red;
     }
   ObjectCreate("YesChange"+IntegerToString(j), OBJ_LABEL, WindowFind("SymbolCheck"), 0, 0);
   text=StringConcatenate("Yesterday: ",DoubleToString(YesPercentagec,2)," %");
   ObjectSetText("YesChange",text,9, "Verdana", color_indic);
   ObjectSet("YesChange"+IntegerToString(j), OBJPROP_CORNER, 0);
   ObjectSet("YesChange"+IntegerToString(j), OBJPROP_XDISTANCE, 170);
   ObjectSet("YesChange"+IntegerToString(j), OBJPROP_YDISTANCE, 13+j*10);
//---week change
    double WeekOpenc=iOpen(customsymbol[j],PERIOD_W1,0);
   double WeekClosec=iClose(customsymbol[j],PERIOD_W1,1);
   double WeekPercentagec=(askpricec-WeekOpenc)/WeekClosec*100;
   if(WeekPercentagec>=0)
     {
      color_indic = Lime;
     }
   else
     {
      color_indic = Red;
     }
   ObjectCreate("WeekChange"+IntegerToString(j), OBJ_LABEL, WindowFind("SymbolCheck"), 0, 0);
   text=StringConcatenate("Week: ",DoubleToString(WeekPercentagec,2)," %");
   ObjectSetText("WeekChange",text,9, "Verdana", color_indic);
   ObjectSet("WeekChange"+IntegerToString(j), OBJPROP_CORNER, 0);
   ObjectSet("WeekChange"+IntegerToString(j), OBJPROP_XDISTANCE, 300);
   ObjectSet("WeekChange"+IntegerToString(j), OBJPROP_YDISTANCE, 13+j*10);
//---Month change
   double MonthOpenc=iOpen(customsymbol[j],PERIOD_MN1,0);
   double MonthClosec=iClose(customsymbol[j],PERIOD_MN1,1);
   double MonthPercentagec=(askpricec-MonthOpenc)/WeekClosec*100;
   if(MonthPercentagec>=0)
     {
      color_indic = Lime;
     }
   else
     {
      color_indic = Red;
     }
   ObjectCreate("MonthChange"+IntegerToString(j), OBJ_LABEL, WindowFind("SymbolCheck"), 0, 0);
   text=StringConcatenate("Month: ",DoubleToString(MonthPercentagec,2)," %");
   ObjectSetText("MonthChange",text,9, "Verdana", color_indic);
   ObjectSet("MonthChange"+IntegerToString(j), OBJPROP_CORNER, 0);
   ObjectSet("MonthChange"+IntegerToString(j), OBJPROP_XDISTANCE, 410);
   ObjectSet("MonthChange"+IntegerToString(j), OBJPROP_YDISTANCE, 13+j*10);
   }
*/   
   
//--- return value of prev_calculated for next call
   RefreshRates();
   ChartRedraw();
   return(rates_total);
  }
//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer()
  {
//---
   
  }
//+------------------------------------------------------------------+
