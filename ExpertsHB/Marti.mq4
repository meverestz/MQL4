//+------------------------------------------------------------------+
//|                                                       Matrix.mq4 |Martingale Arbitrage Strategy
//|                                         Copyright 2019, MZ Corp. |
//|                                             https://www.mql5.com |Open order position by Fibo retracement and close when hit previous level
//+------------------------------------------------------------------+8.12 Add MACD H1 Check
//+------------------------------------------------------------------+8.14 All in one and fix bug ///auto lots test // add 5day-ma check and close[1] to reduce noise
#property copyright "Copyright 2020, Horse Technology Corp. MZ"
#property link      "https://www.horsegroup.net/en/"
#property version   "1.00"
#property strict
#property description "Make sure have Allow live trading mode on !" 
#property description "We recommond use this Expert based on H1 Timeframe or H4!" 
#property description "This EA can be applied to a variety of Symbols."
#property description "Contact us to set the correct parameters:"  
#property description "MAV2 EA. Copyright@Horseforex" 
#property description "Open Account: https://secure.horsegroup.net/register/" 
#property description "--" 
//#property description "Author: Derek Mu" 
//#property description "Email: derek@horseforex.om" 
//#property description "Link: https://www.horsegroup.net/en/" 
#include <stderror.mqh> 
#include <stdlib.mqh> 
int MAGIC=666;
int account_code=825746;
//input
extern string code="8888"; //InputValidationCODE
extern bool   SetBuyOnly=true; //SetBuyOnly
extern bool   SetSellOnly=true; //SetSellOnly
 bool   AutoSetLots=false; //AutoSetLots
 int    MA_Day=5;        //SetMA_Day
extern int    countcandle=7;  //CountsCandleBarNumber
extern double Precentage=0.01;  //CheckRangePrecentage
extern int    countday=14;  //MaxDayCloseAllLimit
extern bool   StaticState=false; //SetStaticState
extern bool   SetWeekClose=false; //SetEveryWeekClose
extern bool   SetTradingTime=false; //SetTradingTime
input string  TimeSet="--GMT--Sunday-for-0--";//TimeParameter_Set
extern int    StartTradingTime=0; //SetStartTradingTime(GMT)
extern bool   SetTimeClose=false; //Set_23H_CloseAllPosition
extern int    BanTradingDay1=0; //BanTradingDay1
extern int    BanTradingDay2=6; //BanTradingDay2
double tradelots=0.1;   //OrderLots
extern bool   auto_tp=false;   //SetTotalProfitClose
extern double setprofit=10000;  //TotalTakeProfit
extern bool   auto_sl=false;   //SetTotalLossClose
extern double setloss=-1000;  //TotalStopLoss
input string FiboParameterSet="----Step--by--Step---";//FiboParameter_Set
extern int   Totalcount=6;     //MaxFiboOrderCounts
extern int   FiboTPCount=1;    //MaxTakeProfitCountsClose
extern bool   drawfibo=true;   //DrawFiboLine
input  color  LC = DodgerBlue; // FiboLineColor 
input  ENUM_LINE_STYLE LS = 0; // FiboLineStyle 
                               // Solid = 0, Dot = 2
input  int    LW = 1;          // FiboLineWidth
//Fibo trading parameter
input double FiboLevel_1=0.236;
input double FiboLevel_2=0.382;
input double FiboLevel_3=0.5;
input double FiboLevel_4=0.618;
input double FiboLevel_5=1.0;
input double FiboLevel_6=1.382;
input double FiboLevel_7=1.5;
input double FiboLevel_8=1.618;
input double FiboLevel_9=2.0;
input string FiboLotSet="----Step--by--Step---";//FiboTradingLots_Set
extern double FiboLot_1=0.1;
extern double FiboLot_2=0.2;
extern double FiboLot_3=0.3;
extern double FiboLot_4=0.5;
extern double FiboLot_5=0.7;
extern double FiboLot_6=1.0;
extern double FiboLot_7=1.8;
extern double FiboLot_8=3.5;
extern double FiboLot_9=6.8;
//trading parameter
string pairs;          //Symbol
double maxlots=100;    
double sl_point,sl_price,tp_point,tp_price;
int    ticket,slippage;     //order_ticket
bool   turn_alert=false;
double fiboValue0,fiboValue23,fiboValue38,fiboValue50,fiboValue61,fiboValue78,fiboValue100,fiboValue138,fiboValue168,fiboValue200;
double fiboValue0_Copy,fiboValue23_Copy,fiboValue38_Copy,fiboValue50_Copy,fiboValue61_Copy,fiboValue78_Copy,fiboValue100_Copy,fiboValue138_Copy,fiboValue168_Copy,fiboValue200_Copy;
double fiboPriceDiff,fiboPrice0,fiboPrice1,fiboPrecentage;
bool   FiboUptrend,FiboDowntrend;
datetime buytime=0;
datetime selltime=0;
datetime TimeTrigger;
double BuyPriceHigh,SellPriceLow;
double avgbuyprice,avgsellprice;
bool   checktime;
datetime Todaytime;
//common parameter
int    T;
int    buyordercounts,sellordercounts,pending;
bool   flag,flag_buy,flag_sell;
double pips;

bool flag_order1;
datetime testtime,testselltime;
double initalequity;
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
/*---
  OnTimer();   
  }
//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer()
{
/*///---
   //double orderprice,orderlots;

   pairs=Symbol();
   Todaytime=TimeCurrent();
   double AskPrice=MarketInfo(pairs,MODE_ASK);
   double BidPrice=MarketInfo(pairs,MODE_BID);
   int    vdigits = (int)MarketInfo(pairs,MODE_DIGITS); 
   double accountequity=AccountEquity();
   double ratio=accountequity/initalequity;

   CheckTradeTime();
   CreateFibo();
   if(drawfibo)DrawFibo();

//Auto set lots
   
   MqlDateTime tm6;
  
   if(TimeToStruct(Todaytime,tm6))
            { 
             if(AutoSetLots)
             if((tm6.day_of_year == 5) || (tm6.day_of_year == 180))
                 {    
                 if((ratio>2)&&(accountequity>600)){FiboLot_1=0.01;FiboLot_2=0.03;FiboLot_3=0.04;FiboLot_4=0.06;FiboLot_5=0.07;FiboLot_6=0.08;FiboLot_7=0.09;FiboLot_8=0.1;FiboLot_9=0.13;Sleep(1000);RefreshRates();}
                 if((ratio>3)&&(accountequity>900)){FiboLot_1=0.02;FiboLot_2=0.04;FiboLot_3=0.06;FiboLot_4=0.08;FiboLot_5=0.09;FiboLot_6=0.1;FiboLot_7=0.12;FiboLot_8=0.14;FiboLot_9=0.16;Sleep(1000);RefreshRates();}
                /*                          
                 if((ratio>2)&&(accountequity>20000)){FiboLot_1=0.15;FiboLot_2=0.3;FiboLot_3=0.45;FiboLot_4=0.8;FiboLot_5=1.0;FiboLot_6=1.8;Sleep(1000);RefreshRates();}
                 if((ratio>3)&&(accountequity>30000)){FiboLot_1=0.2;FiboLot_2=0.4;FiboLot_3=0.6;FiboLot_4=1.0;FiboLot_5=1.4;FiboLot_6=2;Sleep(1000);RefreshRates();}
                 if((ratio>4)&&(accountequity>40000)){FiboLot_1=0.25;FiboLot_2=0.45;FiboLot_3=0.7;FiboLot_4=1.2;FiboLot_5=1.6;FiboLot_6=2.5;Sleep(1000);RefreshRates();}
                 if((ratio>5)&&(accountequity>50000)){FiboLot_1=0.3;FiboLot_2=0.6;FiboLot_3=1.0;FiboLot_4=1.5;FiboLot_5=2.0;FiboLot_6=3.0;Sleep(1000);RefreshRates();}
                 if((ratio>6)&&(accountequity>60000)){FiboLot_1=0.4;FiboLot_2=0.8;FiboLot_3=1.2;FiboLot_4=1.8;FiboLot_5=2.5;FiboLot_6=3.6;Sleep(1000);RefreshRates();}
                 */
                 }
            }


   //double MACD_m_60=iMACD(pairs,PERIOD_CURRENT,12,26,9,PRICE_CLOSE,MODE_MAIN,0);
   //double MA_5D=iMA(pairs,PERIOD_CURRENT,MA_Day,0,MODE_EMA,PRICE_CLOSE,0);
        //printff(NormalizeDouble(fiboValue100,Digits()),NormalizeDouble(fiboValue168,Digits()));
//---Trading takeprofit condition   24hours check BuyCheck
   avgbuyprice=AverageBuyPrice();
   if(BuyOrderCount()>1){ flag_order1=true;}
   if(avgbuyprice>0 && BuyOrderCount()>1)          //check Total Order first and orders must be greater than two(1) 
      {
        BuyOrderModify_TP(FormatTPSL(avgbuyprice));              //modify average tp price
      }
   
   avgsellprice=AverageSellPrice();
   if(avgsellprice>0 && SellOrderCount()>1)          //check Total Order first and orders must be greater than two(1) 
      {
        SellOrderModify_TP(FormatTPSL(avgsellprice));              //modify average tp price
      }



//---check first condition   && flag==false
if(fiboPrecentage>Precentage )
   {  
      TimeTrigger=TimeCurrent();
      if(checktime)flag=true;
      else flag=false;
       
      RefreshRates();
      fiboValue0_Copy=fiboValue0;fiboValue23_Copy=fiboValue23;fiboValue38_Copy=fiboValue38;fiboValue50_Copy=fiboValue50;fiboValue61_Copy=fiboValue61;
      fiboValue78_Copy=fiboValue78;fiboValue100_Copy=fiboValue100;fiboValue138_Copy=fiboValue138;fiboValue168_Copy=fiboValue168;                                           

 
//+----------------Uptrend------------------------------------------+  
//---check second condition    
      if(FiboUptrend)    
       {
            if(flag)
            if(AskPrice>=fiboValue23_Copy)flag_buy=true;
            //---check trind condition and waiting for retracement and only buy         
                        if(BuyOrderCount()==0 && flag_buy)   //check total order = 0
                         {
                       if(SetBuyOnly)  
                       //if((MACD_m_60>=0)){    //MACD H1 Check
                       //if((MACD_m_60>=0)&&(Close[1]>=MA_5D)){    //MA  Check
                       //if((MACD_m_60>=0)&&(iClose(pairs,PERIOD_H4,1)>=MA_5D)){    //MACD H1 Check
                              //check first order fibo=0.236
                        {                                                          
                            if(PendingBuyOrderCount()==0)     // each bar only order once
                                 {
                                    BuyPriceHigh=fiboValue0_Copy;    //save start highest price
                                   // buytime=Time[1];                 //set buy start time and save copy Fibo_value
                                    //if(Totalcount>=1)BuyLimit(FormatPrice(fiboValue23_Copy),FormatLots(FiboLot_1),0,FormatTPSL(BuyPriceHigh),"Buy"+"FiboLevel_1",MAGIC);
                                    if(BuyLimit(FormatPrice(fiboValue23_Copy),FormatLots(FiboLot_1),0,FormatTPSL(BuyPriceHigh),"Buy"+"FiboLevel_1",MAGIC)>0)
                                    //set buy start time and save copy Fibo_value
                                          {buytime=Time[1]; }
                                    if(Totalcount>=2)BuyLimit(FormatPrice(fiboValue38_Copy),FormatLots(FiboLot_2),0,0,"Buy"+"FiboLevel_2",MAGIC); 
                                    if(Totalcount>=3)BuyLimit(FormatPrice(fiboValue50_Copy),FormatLots(FiboLot_3),0,0,"Buy"+"FiboLevel_3",MAGIC); 
                                    if(Totalcount>=4)BuyLimit(FormatPrice(fiboValue61_Copy),FormatLots(FiboLot_4),0,0,"Buy"+"FiboLevel_4",MAGIC); 
                                    if(Totalcount>=5)BuyLimit(FormatPrice(fiboValue78_Copy),FormatLots(FiboLot_5),0,0,"Buy"+"FiboLevel_5",MAGIC);   
                                    if(Totalcount>=6)BuyLimit(FormatPrice(fiboValue100_Copy),FormatLots(FiboLot_6),0,0,"Buy"+"FiboLevel_6",MAGIC);   
                                    if(Totalcount>=7)BuyLimit(FormatPrice(fiboValue138_Copy),FormatLots(FiboLot_7),0,0,"Buy"+"FiboLevel_7",MAGIC); 
                                    if(Totalcount>=8)BuyLimit(FormatPrice(fiboValue168_Copy),FormatLots(FiboLot_8),0,0,"Buy"+"FiboLevel_8",MAGIC); 
                                    if(Totalcount>=9)BuyLimit(FormatPrice(fiboValue200_Copy),FormatLots(FiboLot_9),0,0,"Buy"+"FiboLevel_9",MAGIC);                                             
                                 }
                             if(!StaticState){      
                                     if(PendingBuyOrderCount()!=0)     // each bar only order once
                                          {
                                              if(BuyPriceHigh != High[0])     // each bar only order once
                                                {     
                                                      //buytime_M=Time[0];                 //save modify time      
                                                      double modifyhighprice=High[0];            
                                                      if(Totalcount>=1)ModifySpecificOrder("Buy"+"FiboLevel_1",FormatPrice(fiboValue23_Copy),0,FormatTPSL(modifyhighprice));                           
                                                      if(Totalcount>=2)ModifySpecificOrder("Buy"+"FiboLevel_2",FormatPrice(fiboValue38_Copy),0,0); 
                                                      if(Totalcount>=3)ModifySpecificOrder("Buy"+"FiboLevel_3",FormatPrice(fiboValue50_Copy),0,0);
                                                      if(Totalcount>=4)ModifySpecificOrder("Buy"+"FiboLevel_4",FormatPrice(fiboValue61_Copy),0,0);
                                                      if(Totalcount>=5)ModifySpecificOrder("Buy"+"FiboLevel_5",FormatPrice(fiboValue78_Copy),0,0);   
                                                      if(Totalcount>=6)ModifySpecificOrder("Buy"+"FiboLevel_6",FormatPrice(fiboValue100_Copy),0,0);
                                                      if(Totalcount>=7)ModifySpecificOrder("Buy"+"FiboLevel_7",FormatPrice(fiboValue138_Copy),0,0); 
                                                      if(Totalcount>=8)ModifySpecificOrder("Buy"+"FiboLevel_8",FormatPrice(fiboValue168_Copy),0,0);
                                                      if(Totalcount>=9)ModifySpecificOrder("Buy"+"FiboLevel_9",FormatPrice(fiboValue200_Copy),0,0);  
                                                      Sleep(30000);RefreshRates();                                              
                                                }
                                          } }    
                         }
                        

                    }//finish                  
            
       }
       
//+----------------Downtrend------------------------------------------+         
       if(FiboDowntrend) 
       {
            if(flag)
            if(BidPrice<=fiboValue23_Copy)flag_sell=true;
            //---check trind condition and waiting for retracement and only sell         
                        if(SellOrderCount()==0 && flag_sell)   //check total order = 0
                         {
                      if(SetSellOnly)   
                      //if((MACD_m_60<0)){     //MACD H1 Check
                      //if((MACD_m_60<0)&&(Close[1]<MA_5D)){     //MA Check
                      //if((MACD_m_60<0)&&(iClose(pairs,PERIOD_H4,1)<MA_5D)){    //MACD H1 Check
                              //check first order fibo=0.236
                       {                                                           
                            if(PendingSellOrderCount()==0)     // each bar only order once
                                 {
                                    SellPriceLow=fiboValue0_Copy;    //save start highest price
                                    //selltime=Time[1];                 //set buy start time and save copy Fibo_value
                                   // if(Totalcount>=1)SellLimit(FormatPrice(fiboValue23_Copy),FormatLots(FiboLot_1),0,FormatTPSL(SellPriceLow),"Sell"+"FiboLevel_1",MAGIC);
                                    if(SellLimit(FormatPrice(fiboValue23_Copy),FormatLots(FiboLot_1),0,FormatTPSL(SellPriceLow),"Sell"+"FiboLevel_1",MAGIC)>0)
                                    //set buy start time and save copy Fibo_value
                                          {selltime=Time[1];  }
                                    if(Totalcount>=2)SellLimit(FormatPrice(fiboValue38_Copy),FormatLots(FiboLot_2),0,0,"Sell"+"FiboLevel_2",MAGIC); 
                                    if(Totalcount>=3)SellLimit(FormatPrice(fiboValue50_Copy),FormatLots(FiboLot_3),0,0,"Sell"+"FiboLevel_3",MAGIC); 
                                    if(Totalcount>=4)SellLimit(FormatPrice(fiboValue61_Copy),FormatLots(FiboLot_4),0,0,"Sell"+"FiboLevel_4",MAGIC); 
                                    if(Totalcount>=5)SellLimit(FormatPrice(fiboValue78_Copy),FormatLots(FiboLot_5),0,0,"Sell"+"FiboLevel_5",MAGIC);   
                                    if(Totalcount>=6)SellLimit(FormatPrice(fiboValue100_Copy),FormatLots(FiboLot_6),0,0,"Sell"+"FiboLevel_6",MAGIC);   
                                    if(Totalcount>=7)SellLimit(FormatPrice(fiboValue138_Copy),FormatLots(FiboLot_7),0,0,"Sell"+"FiboLevel_7",MAGIC); 
                                    if(Totalcount>=8)SellLimit(FormatPrice(fiboValue168_Copy),FormatLots(FiboLot_8),0,0,"Sell"+"FiboLevel_8",MAGIC); 
                                    if(Totalcount>=9)SellLimit(FormatPrice(fiboValue200_Copy),FormatLots(FiboLot_9),0,0,"Sell"+"FiboLevel_9",MAGIC);                                             
                                 }
                             if(!StaticState){     
                                     if(PendingSellOrderCount()!=0)     // each bar only order once
                                          {
                                              if(SellPriceLow != Low[0])     // each bar only order once
                                                {     
                                                      //buytime_M=Time[0];                 //save modify time  
                                                      double modifylowprice=Low[0];                 
                                                      if(Totalcount>=1)ModifySpecificOrder("Sell"+"FiboLevel_1",FormatPrice(fiboValue23_Copy),0,FormatTPSL(modifylowprice));                            
                                                      if(Totalcount>=2)ModifySpecificOrder("Sell"+"FiboLevel_2",FormatPrice(fiboValue38_Copy),0,0); 
                                                      if(Totalcount>=3)ModifySpecificOrder("Sell"+"FiboLevel_3",FormatPrice(fiboValue50_Copy),0,0);
                                                      if(Totalcount>=4)ModifySpecificOrder("Sell"+"FiboLevel_4",FormatPrice(fiboValue61_Copy),0,0);
                                                      if(Totalcount>=5)ModifySpecificOrder("Sell"+"FiboLevel_5",FormatPrice(fiboValue78_Copy),0,0);   
                                                      if(Totalcount>=6)ModifySpecificOrder("Sell"+"FiboLevel_6",FormatPrice(fiboValue100_Copy),0,0);
                                                      if(Totalcount>=7)ModifySpecificOrder("Sell"+"FiboLevel_7",FormatPrice(fiboValue138_Copy),0,0); 
                                                      if(Totalcount>=8)ModifySpecificOrder("Sell"+"FiboLevel_8",FormatPrice(fiboValue168_Copy),0,0);
                                                      if(Totalcount>=9)ModifySpecificOrder("Sell"+"FiboLevel_9",FormatPrice(fiboValue200_Copy),0,0);  
                                                      Sleep(30000);RefreshRates();                                              
                                                }
                                          } }    
                         }
                   }//finish  
       }
    }
   
    
       //waiting for retracement and only sell
/*       
            if(SellOrderCount()==0 && flag_sell)   //check total order = 0
             {
                  if(BidPrice==NormalizeDouble(fiboValue23,vdigits))  //check first order fibo=0.236
                  {
                
                     if(selltime!=Time[0])     // each bar only order once
                     {
                        //printff(NormalizeDouble(fiboValue0,Digits()));
                        if(SellOrder(FormatLots(FiboLot_1),0,NormalizeDouble(fiboValue0_Copy,vdigits),"Sell"+"FiboLevel_1",MAGIC)>0)
                              {
                                 selltime=Time[0];  //set buy last time and save copy Fibo_value
                               
                              }
                     }
                  }
             }
             
             if(SellOrderCount()<Totalcount && flag_sell)   //check total order < Max ordersend
             {
                  if(BidPrice==NormalizeDouble(fiboValue38_Copy,vdigits))  //check first order fibo=0.382
                  {
                     if(selltime!=Time[0])     // each bar only order once
                     {
                        if(SellOrder(FormatLots(FiboLot_2),0,0,"Sell"+"FiboLevel_2",MAGIC)>0){selltime=Time[0];  }//set buy last time
                        //Alert(NormalizeDouble(fiboValue23,Digits));
                     }
                  }
             }
             if(SellOrderCount()<Totalcount && flag_sell)   //check total order < Max ordersend
             {
                  if(BidPrice==NormalizeDouble(fiboValue50_Copy,vdigits))  //check first order fibo=0.50
                  {
                     if(selltime!=Time[0])     // each bar only order once
                     {
                        if(SellOrder(FormatLots(FiboLot_3),0,0,"Sell"+"FiboLevel_3",MAGIC)>0){selltime=Time[0]; }  //set buy last time
     
                     }
                  }
             }
             if(SellOrderCount()<Totalcount && flag_sell)   //check total order < Max ordersend
             {  //send all buy limit order
                     if(selltime!=Time[0])     // each bar only order once
                     {
                        selltime=Time[0];   //set buy last time
                        SellLimit(NormalizeDouble(fiboValue61_Copy,vdigits),FormatLots(FiboLot_4),0,0,"Sell"+"FiboLevel_4",MAGIC); 
                        SellLimit(NormalizeDouble(fiboValue78_Copy,vdigits),FormatLots(FiboLot_5),0,0,"Sell"+"FiboLevel_5",MAGIC);   
                        SellLimit(NormalizeDouble(fiboValue100_Copy,vdigits),FormatLots(FiboLot_6),0,0,"Sell"+"FiboLevel_6",MAGIC);   
                        SellLimit(NormalizeDouble(fiboValue138_Copy,vdigits),FormatLots(FiboLot_7),0,0,"Sell"+"FiboLevel_7",MAGIC); 
                        SellLimit(NormalizeDouble(fiboValue168_Copy,vdigits),FormatLots(FiboLot_8),0,0,"Sell"+"FiboLevel_8",MAGIC); 
                        SellLimit(NormalizeDouble(fiboValue200_Copy,vdigits),FormatLots(FiboLot_9),0,0,"Sell"+"FiboLevel_9",MAGIC);     
                     }
              }
           
             
       //finish  
           double avgsellprice=AverageSellPrice();
           if(avgsellprice>0 && SellOrderCount()>1)
            {
              SellOrderModify_TP(NormalizeDouble(avgsellprice,vdigits));
            }
*///+------------------------------------------------------------------+  
 
   //TP condition check FiboTPCount
   if(testtime!=Time[0])
   if(PendingBuyOrderCount()>0 && (HistoryCheckOrder_Buy(buytime)>FiboTPCount))
   {printf("Buy满足盈利出局");CloseBuyOrderPosition(); flag=false;flag_buy=false;buytime=0;Sleep(1000);RefreshRates();flag_order1=false;testtime=Time[0];  }     
   
   if(testtime!=Time[0])
   if(CheckTradingOrderBuy_Specific("Buy"+"FiboLevel_1")!=1)                                       //当找不到Level 1 Limit订单时
  // if(PendingBuyOrderCount()>0 && (HistoryCheckOrder_Specific(buytime,"Buy"+"FiboLevel_1")==1)) //存在挂单且之前Level 1订单已平仓------关闭所有订单  
   if(PendingBuyOrderCount()>0 && ((HistoryCheckOrder_Buy(buytime)==1)))      //挂单大于0且历史订单buy=1
   {printf("找不到buy Level 1重新计算");CloseBuyOrderPosition(); flag=false;flag_buy=false;buytime=0;Sleep(1000);RefreshRates();testtime=Time[0];}   
  // if(PendingBuyOrderCount()>0 && (HistoryCheckOrder_Specific(buytime,OP_BUY,"Buy"+"FiboLevel_1")==1))
  // {CloseBuyOrderPosition(); flag=false;flag_buy=false;buytime=0;Sleep(1000);RefreshRates();}   
  
  
   if(testselltime!=Time[0])
   if(PendingSellOrderCount()>0 && (HistoryCheckOrder_Sell(selltime)>FiboTPCount))
   {printf("Sell满足盈利出局");CloseSellOrderPosition();flag=false; flag_sell=false;selltime=0;Sleep(1000);RefreshRates();flag_order1=false;testselltime=Time[0];}   
   
   if(testselltime!=Time[0])
   if(CheckTradingOrderSell_Specific("Sell"+"FiboLevel_1")!=1)                                       //当找不到Level 1 Limit订单时
  // if(PendingBuyOrderCount()>0 && (HistoryCheckOrder_Specific(buytime,"Buy"+"FiboLevel_1")==1)) //存在挂单且之前Level 1订单已平仓------关闭所有订单  
   if(PendingSellOrderCount()>0 && ((HistoryCheckOrder_Sell(selltime)==1)))      //挂单大于0且历史订单buy=1
   {printf("找不到sell Level 1重新计算");CloseSellOrderPosition(); flag=false;flag_sell=false;selltime=0;Sleep(1000);RefreshRates();testselltime=Time[0];}   
  // if(PendingSellOrderCount()>0 && (HistoryCheckOrder_Specific(selltime,OP_SELL,"Sell"+"FiboLevel_1")==1))
  // {CloseSellOrderPosition(); flag=false;flag_buy=false;buytime=0;Sleep(1000);RefreshRates();}   
   //printff("%d  %d  %d",buyordercounts,sellordercounts,pending);
   //TP condition check FiboTPCount
   if(countday!=0)
   if(testtime!=Time[0])
   if(CheckDurationFromStart(buytime,TimeCurrent())>=countday)
      {
         if(OrdersTotal()>0)
         { printf("CountDay Close");CloseBuyOrderPosition();flag_buy=false;buytime=0;fiboPrecentage=0;TimeTrigger=0;FiboUptrend=false;FiboDowntrend=false;Sleep(1000);RefreshRates();testtime=Time[0];}     
      }   
      
   if(countday!=0)
   if(testselltime!=Time[0])
   if(CheckDurationFromStart(selltime,TimeCurrent())>=countday)
      {
         if(OrdersTotal()>0)
         {printf("CountDay Close");CloseSellOrderPosition();flag_sell=false;selltime=0;fiboPrecentage=0;TimeTrigger=0;FiboUptrend=false;FiboDowntrend=false;Sleep(1000);RefreshRates();testselltime=Time[0];}     
      }     
//Weekly Close
   MqlDateTime tm1;
   if(SetWeekClose)
         if(TimeToStruct(Todaytime,tm1))
                  {
                   if((tm1.day_of_week == 5)&&(tm1.hour == 22))
                            {                             
                                if(OrdersTotal()>0)
                                {CloseBuyOrderPosition();CloseSellOrderPosition();flag_sell=false;flag_buy=false;
                                fiboPrecentage=0;TimeTrigger=0;FiboUptrend=false;FiboDowntrend=false;Sleep(1000);RefreshRates();}
                            }
                  }
            
   if(auto_tp)if(AccountProfit()>=setprofit)
      {
         CloseBuyOrderPosition();CloseSellOrderPosition();
      }
   if(auto_sl)if((AccountEquity()-AccountBalance())<=setloss)
      {
         CloseBuyOrderPosition();CloseSellOrderPosition();
      }   
   
}
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {

//--- create timer
   //EventSetTimer(1);
   T=Period();
//---check ticksize   
   double ticksize=MarketInfo(Symbol(),MODE_TICKSIZE);
   if(ticksize==0.00001 || ticksize==0.001)
      pips=ticksize*10;
   else
      pips=ticksize;
//---check Account Code Fit
   //if(AccountNumber()!=account_code){MessageBox("Invaild Account Number!","Check it again!",0x00000000);ExpertRemove();}
     if(AccountInfoString(ACCOUNT_COMPANY)=="Horse Forex Ltd")
         {           
               // TextCreate("PASS","Horse Technology @copyright",15,15,10,Red);
               // flag=1;
         }
    else {
            Alert("Invaild Broker !");
            Alert("Please Change Account !");
            Alert("Failed Authorization !");
            ExpertRemove();
            return(INIT_FAILED);
         }  
      if(code=="88888888")
         {
       if(TimeLocal()<D'2021.01.31 00:00')
              {
                TextCreate("PASS","                 Passed Certification // Expiry Date 2021.01.31",15,15,10,Red);
                //flag=false;
              }
         }
    else {
            MessageBox("Invaild Account Number! Please Contact Author!","Failed Authorization!",0x00000000);
            ExpertRemove();
         }     
   Comment("Horse Technology @copyright\nhttps://www.horsegroup.net/\nOpen Account: https://secure.horsegroup.net/register/");
//---check symbol min lots       
   double    lotcheck = MarketInfo(pairs,MODE_MINLOT); 
   printf("Min Lots = %s ",DoubleToString(lotcheck,Digits()));
   initalequity=AccountEquity();
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   ObjectDelete("FIBO");
   ObjectDelete("PASS");
//--- destroy timer
   //EventKillTimer();
   
  }

//+------------------------------------------------------------------+
//| Trading Function                                                 |
//+------------------------------------------------------------------+
void buy_up()
{
   tradelots=NormalizeDouble(tradelots,2); //transform Format 
   if(tradelots<MarketInfo(Symbol(),MODE_MINLOT))
      {
         tradelots=MarketInfo(Symbol(),MODE_MINLOT);
      }
   if(tradelots>maxlots){tradelots=maxlots;}
   if(tradelots>MarketInfo(Symbol(),MODE_MAXLOT))
      {
         tradelots=MarketInfo(Symbol(),MODE_MAXLOT);
      }
   //Set take profit position
   if(tp_point==0){tp_price=0;}
   if(tp_point>0)
      {
         tp_price=(MarketInfo(Symbol(),MODE_ASK))+(tp_point*MarketInfo(Symbol(),MODE_POINT));
      }   
   //Set stop loss position      
   if(sl_point==0){sl_price=0;}
   if(sl_point>0)
      {
         sl_price=(MarketInfo(Symbol(),MODE_ASK))-(sl_point*MarketInfo(Symbol(),MODE_POINT));
      } 
    //Order execution  
    ticket=OrderSend(pairs,OP_BUY,tradelots,MarketInfo(Symbol(),MODE_ASK),slippage,sl_price,tp_price,"OrderBuy",MAGIC,0,Violet);
    if(ticket<0)
       {
         if(turn_alert){printf("Order Execution Error!",GetLastError());}
       } 
    else
       { 
         if(turn_alert){printf("OrderBuy Execution %s %d ",Symbol(),ticket);}
       }   
}

void sell_down()
{
   tradelots=NormalizeDouble(tradelots,2); //transform Format 
   if(tradelots<MarketInfo(Symbol(),MODE_MINLOT))
      {
         tradelots=MarketInfo(Symbol(),MODE_MINLOT);
      }
   if(tradelots>maxlots){tradelots=maxlots;}
   if(tradelots>MarketInfo(Symbol(),MODE_MAXLOT))
      {
         tradelots=MarketInfo(Symbol(),MODE_MAXLOT);
      }
   //Set take profit position
   if(tp_point==0){tp_price=0;}
   if(tp_point>0)
      {
         tp_price=(MarketInfo(Symbol(),MODE_ASK))-(tp_point*MarketInfo(Symbol(),MODE_POINT));
      }   
   //Set stop loss position      
   if(sl_point==0){sl_price=0;}
   if(sl_point>0)
      {
         sl_price=(MarketInfo(Symbol(),MODE_ASK))+(sl_point*MarketInfo(Symbol(),MODE_POINT));
      } 
    //Order execution  
    ticket=OrderSend(pairs,OP_SELL,tradelots,MarketInfo(Symbol(),MODE_BID),slippage,sl_price,tp_price,"OrderSell",MAGIC,0,GreenYellow);
    if(ticket<0)
       {
         if(turn_alert){printf("Order Execution Error!",GetLastError());}
       } 
    else
       { 
         if(turn_alert){printf("OrderSell Execution %s %d ",Symbol(),ticket);}
       }   
}

void close_buy()
{
   double myBid,myLot;
   int myType,i;
   bool result=false;
   int myTicket=0;
   
   for(i=OrdersTotal()-1;i>=0;i--)
      {
         if(OrderSelect(i,SELECT_BY_POS))
            { 
               if(OrdersTotal()>0&&OrderSymbol()==Symbol()&&OrderMagicNumber()==MAGIC)
                  {
                     myBid=MarketInfo(Symbol(),MODE_BID);
                     myTicket=OrderTicket();
                     myLot=OrderLots();
                     myType=OrderType();
                     switch(myType)
                     {
                        case OP_BUY:
                                   result=OrderClose(myTicket,myLot,myBid,slippage,Yellow);
                                   break;
                     }
                  }
            }
      }
}

void close_sell()
{
   double myBid,myLot;
   int myType,i;
   bool result=false;
   int myTicket=0;
   
   for(i=OrdersTotal()-1;i>=0;i--)
      {
         if(OrderSelect(i,SELECT_BY_POS))
            { 
               if(OrdersTotal()>0&&OrderSymbol()==Symbol()&&OrderMagicNumber()==MAGIC)
                  {
                     myBid=MarketInfo(Symbol(),MODE_ASK);
                     myTicket=OrderTicket();
                     myLot=OrderLots();
                     myType=OrderType();
                     switch(myType)
                     {
                        case OP_SELL:
                                   result=OrderClose(myTicket,myLot,myBid,slippage,Red);
                                   break;
                     }              
                  }
            }
      }
}

//+------------------------------------------------------------------+
//|   DRAW FIBONACCI ON CHART                                        |
//+------------------------------------------------------------------+
int DrawFibo()
{
     int fibHigh = iHighest(Symbol(),Period(),MODE_HIGH,countcandle,0);   //return bar count number
     int fibLow  = iLowest(Symbol(),Period(),MODE_LOW,countcandle,0);
     double fiboPriceHigh=High[fibHigh];
     double fiboPriceLow =Low[fibLow];
     datetime highTime = iTime(Symbol(),0,fibHigh);
     datetime lowTime  = iTime(Symbol(),0,fibLow);
     
     datetime T2=0;                     // Second time coordinate
     double t2=0;
     int Error;                          // Error code

     t2=ObjectGet("FIBO",OBJPROP_TIME2);  // Requesting t2 coord.
//T2=t2;
     Error=GetLastError();                // Getting an error code
     if(Error==4202)                      // If no object :(
     {
      // Check for New Bar (Compatible with both MQL4 and MQL5)
      static datetime dtBarCurrent=WRONG_VALUE;
      datetime dtBarPrevious=dtBarCurrent;
      dtBarCurrent=(datetime) SeriesInfoInteger(_Symbol,_Period,SERIES_LASTBAR_DATE);
      bool NewBarFlag=(dtBarCurrent!=dtBarPrevious);
      if(NewBarFlag)  CreateFibo();
     // T2=Time[price2];                  // Current value of t2 coordinate
      T2=iTime(NULL,Period(),fibLow);
     }
//--------------------------------------------------------------- 4 --
  // if(T2!=Time[price2])                 // If object is not in its place
     if(T2!=iTime(NULL,Period(),fibLow))                 // If object is not in its place
     {
      //Create coord.
           if(fibHigh>fibLow)
              {
                ObjectMove("FIBO",0,highTime,fiboPriceHigh);   // Anchor point number.
                ObjectMove("FIBO",1,lowTime,fiboPriceLow);     // 0 to high, 1 to low //Up trend                   
              }
               else
              {
                ObjectMove("FIBO",0,lowTime,fiboPriceLow);     // Fibo point_index
                ObjectMove("FIBO",1,highTime,fiboPriceHigh);   // 0 to low, 1 to high //Down trend
              }
      WindowRedraw();                  // Redrawing the image
     }
   return (0);
}
//----------------------------------------------------------------
int CreateFibo()                        // User-defined function..
{
// ..of object creation  
     int fibHigh = iHighest(Symbol(),Period(),MODE_HIGH,countcandle,1);   //return bar count number
     int fibLow  = iLowest(Symbol(),Period(),MODE_LOW,countcandle,1);     //!Check bar from 0!
     //printff("fibHigh=  %d  fibLow=  %d",fibHigh,fibLow); 

     double fiboPriceHigh=High[fibHigh];
     double fiboPriceLow =Low[fibLow];
     //printff("fiboPrice1=  %-.4f  fiboPrice2=  %-.4f",fiboPriceHigh,fiboPriceLow); 
     

    
     datetime highTime = iTime(Symbol(),0,fibHigh);
     datetime lowTime  = iTime(Symbol(),0,fibLow);
     MqlDateTime str1,str2;
     TimeToStruct(highTime,str1);TimeToStruct(lowTime,str2);
     //printff("%4d.%02d.%02d, %d:%d",str1.year,str1.mon,str1.day,str1.hour,str1.min); 
     //printff("%4d.%02d.%02d, %d:%d",str2.year,str2.mon,str2.day,str2.hour,str2.min); 

 //Fibo from 0% to 100%  Creation
     if(fibHigh>fibLow)
     {
       if(drawfibo)
       {
          WindowRedraw();
          ObjectCreate("FIBO",OBJ_FIBO,0,highTime,fiboPriceHigh,lowTime,fiboPriceLow);   //Down trend
       }
        fiboPrice1=fiboPriceHigh;
        fiboPrice0=fiboPriceLow;
        FiboDowntrend=true;
        //--- Cal Fibo Down Precentage 
        fiboPrecentage=(fiboPrice1-fiboPrice0)/fiboPrice1;
        //printff("Down Trend!   Fibo_Precentage = %.3f    ",fiboPrecentage);
     }
      else
     {
       if(drawfibo)
       {
       WindowRedraw();
       ObjectCreate("FIBO",OBJ_FIBO,0,lowTime,fiboPriceLow,highTime,fiboPriceHigh);   //Up trend   
       }   
        fiboPrice1=fiboPriceLow;
        fiboPrice0=fiboPriceHigh;
        FiboUptrend=true; 
        //--- Cal Fibo Up Precentage
        fiboPrecentage=(fiboPrice0-fiboPrice1)/fiboPrice1;
        //printff("Up Trend!   Fibo_Precentage = %.3f    ",fiboPrecentage);        
     }
     
//--- Check FiboDiff Price     
     //double fiboPrice0=ObjectGet("XIT_FIBO",OBJPROP_PRICE1);
     //double fiboPrice1=ObjectGet("XIT_FIBO",OBJPROP_PRICE2);
        fiboPriceDiff = fiboPrice0-fiboPrice1;
        fiboValue0 = fiboPrice0-fiboPriceDiff*0.0;
        fiboValue23 = fiboPrice0-fiboPriceDiff*FiboLevel_1;
        fiboValue38 = fiboPrice0-fiboPriceDiff*FiboLevel_2;
        fiboValue50 = fiboPrice0-fiboPriceDiff*FiboLevel_3;
        fiboValue61 = fiboPrice0-fiboPriceDiff*FiboLevel_4;
        fiboValue78 = fiboPrice0-fiboPriceDiff*FiboLevel_5;
        fiboValue100 = fiboPrice0-fiboPriceDiff*FiboLevel_6;
        fiboValue138 = fiboPrice0-fiboPriceDiff*FiboLevel_7;
        fiboValue168 = fiboPrice0-fiboPriceDiff*FiboLevel_8;
        fiboValue200 = fiboPrice0-fiboPriceDiff*FiboLevel_9;
        //printff("Fibo_0 = %.2f    Fibo_100 = %.2f    Fibo_PriceDiff = %.2f    ",fiboPrice0,fiboPrice1,fiboPriceDiff);
        //printff("Fibo_0 = %.2f    Fibo_382 = %.2f    Fibo_100 = %.2f    Fibo_168 = %.2f",fiboValue0,fiboValue38,fiboValue100,fiboValue168);

//--- set line color/description and width/sytle
     if(drawfibo)
     {
        ObjectSet("FIBO",OBJPROP_COLOR,LC);      //FIBO Color
        ObjectSet("FIBO",OBJPROP_FIBOLEVELS,7);
        ObjectSet("FIBO",OBJPROP_FIRSTLEVEL+0,0.0);
        ObjectSet("FIBO",OBJPROP_FIRSTLEVEL+1,0.236);
        ObjectSet("FIBO",OBJPROP_FIRSTLEVEL+2,0.382);
        ObjectSet("FIBO",OBJPROP_FIRSTLEVEL+3,0.50);
        ObjectSet("FIBO",OBJPROP_FIRSTLEVEL+4,0.618);
        ObjectSet("FIBO",OBJPROP_FIRSTLEVEL+5,1.0);
        ObjectSet("FIBO",OBJPROP_FIRSTLEVEL+6,1.618);
        ObjectSet("FIBO",OBJPROP_LEVELCOLOR,LC);
        ObjectSet("FIBO",OBJPROP_LEVELWIDTH,LW);
        ObjectSet("FIBO",OBJPROP_LEVELSTYLE,LS);
   
        ObjectSetFiboDescription( "FIBO",0, "0,0%"); 
        ObjectSetFiboDescription( "FIBO",1, "23.6%"); 
        ObjectSetFiboDescription( "FIBO",2, "38.2%"); 
        ObjectSetFiboDescription( "FIBO",3, "50.0%");
        ObjectSetFiboDescription( "FIBO",4, "61.8%");
        ObjectSetFiboDescription( "FIBO",5, "100%");
        ObjectSetFiboDescription( "FIBO",6, "168%");
   //--- enable (true) or disable (false) the mode of continuation of the FIBO's display to the right
        //ObjectSet("FIBO",OBJPROP_RAY,true);         // Ray
        //ObjectSet("FIBO",OBJPROP_BACK,true);
        RefreshRates();
        ChartRedraw();                             // Image redrawing
     }
     return(0);
}

//+------------------------------------------------------------------+
//| Trading Function                                                 |
//+------------------------------------------------------------------+

void BuyOrderModify_TP(double tp)
  {
     for(int i=0;i<OrdersTotal();i++)
      {
        if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
          {
            if(OrderSymbol()==Symbol() && OrderType()==OP_BUY && OrderMagicNumber()==MAGIC)
              {
                if(NormalizeDouble(OrderTakeProfit(),Digits)!=NormalizeDouble(tp,Digits))
                 {
                     bool res=OrderModify(OrderTicket(),OrderOpenPrice(),OrderStopLoss(),tp,0,Green);                               
                     if(!res) 
                        Print("Error in BuyOrderModify_TP.. Error: ",ErrorDescription(GetLastError())); 
                     else 
                        printf("BuyOrder Modified_TP Successfully."); 
                 }
              }
          }
      }
  }
void SellOrderModify_TP(double tp)
  {
     for(int i=0;i<OrdersTotal();i++)
      {
        if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
          {
            if(OrderSymbol()==Symbol() && OrderType()==OP_SELL && OrderMagicNumber()==MAGIC)
              {
                if(NormalizeDouble(OrderTakeProfit(),Digits)!=NormalizeDouble(tp,Digits))
                 {
                     bool res=OrderModify(OrderTicket(),OrderOpenPrice(),OrderStopLoss(),tp,0,Green);
                     if(!res) 
                        Print("Error in SellOrderModify_TP.. Error: ",ErrorDescription(GetLastError())); 
                     else 
                        printf("SellOrder Modified_TP Successfully."); 
                 }
              }
          }
      }
  }

void ModifySpecificOrder(string com,double openprice,double sl,double tp)
  {
     bool res=false;
     //double modprice=FormatPrice(openprice);
     double BaseTemp=NormalizeDouble(openprice,Digits);
     for(int i=0;i<OrdersTotal();i++)
      {
        if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
          {
            if(OrderSymbol()==Symbol() && OrderComment()==com)
              {                        
              //check 如果当前的止损价没有被修改时，那么就进行修改。否则如果当前的止损价已经被修改了，那么就不往下执行了
                  if (NormalizeDouble(OrderOpenPrice(),Digits)!=NormalizeDouble(BaseTemp,Digits))    
                       {
                        if(sl==0 && tp!=0)res=OrderModify(OrderTicket(),openprice,OrderStopLoss(),tp,0,Green);   
                        if(sl!=0 && tp==0)res=OrderModify(OrderTicket(),openprice,sl,OrderTakeProfit(),0,Green);  
                        if(sl==0 && tp==0)res=OrderModify(OrderTicket(),openprice,sl,tp,0,Green);                               
                        if(!res) 
                           //printf("Error in OrderModify. %s  Error code= %s ",com,GetLastError()); 
                           Print("Error in TrackingPriceModify. Error: ",ErrorDescription(GetLastError())); 
                      // else 
                           printf("Order TrackingPriceModify %s modified successfully.",com); 
                       }     
                 
              }
          }
      }
  }


double AverageBuyPrice()
  {
    double a=0;
    int shuliang=0;
    double pricehe=0;
    for(int i=0;i<OrdersTotal();i++)
      {
        if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
          {
            if(OrderSymbol()==Symbol() && OrderType()==OP_BUY && OrderMagicNumber()==MAGIC)
              {
               pricehe=pricehe+OrderOpenPrice();
               shuliang++;
              }
          }
      }
    if(shuliang>0)
     {
      a=pricehe/shuliang;
     }
    return(a);
  }
double AverageSellPrice()
  {
    double b=0;
    int shuliangb=0;
    double priceheb=0;
    for(int i=0;i<OrdersTotal();i++)
      {
        if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
          {
            if(OrderSymbol()==Symbol() && OrderType()==OP_SELL && OrderMagicNumber()==MAGIC)
              {
               priceheb=priceheb+OrderOpenPrice();
               shuliangb++;
              }
          }
      }
    if(shuliangb>0)
     {
      b=priceheb/shuliangb;
     }
    return(b);
  }
  

double FormatLots(double llots)  //transform Format Lots
  {

    
   double lots=llots;
//--- minimal allowed volume for trade operations
   double minlot=SymbolInfoDouble(Symbol(),SYMBOL_VOLUME_MIN);
   if(lots<minlot)
     {
      lots=minlot;
      Print("Volume is less than the minimal allowed ,we use",minlot);
     }
//--- maximal allowed volume of trade operations
   double maxlot=SymbolInfoDouble(Symbol(),SYMBOL_VOLUME_MAX);
   if(lots>maxlot)
     {
      lots=maxlot;
      Print("Volume is greater than the maximal allowed,we use",maxlot);
     }
//--- get minimal step of volume changing
   double volume_step=SymbolInfoDouble(Symbol(),SYMBOL_VOLUME_STEP);
   int ratio=(int)MathRound(lots/volume_step);
   if(MathAbs(ratio*volume_step-lots)>0.0000001)
     {
      lots=ratio*volume_step;

      Print("Volume is not a multiple of the minimal step ,we use the closest correct volume ",ratio*volume_step);
     }

   return(lots); 
  }  
    
double FormatTPSL(double val)
  {
   RefreshRates();
   double SPREAD=MarketInfo(Symbol(),MODE_SPREAD);
   double StopLevel=MarketInfo(Symbol(),MODE_STOPLEVEL);
   if(val<StopLevel*pips+SPREAD*pips)
      val=StopLevel*pips+SPREAD*pips;
   return(NormalizeDouble(val, Digits));
// return(val);
  } 
  
double FormatPrice(double val)
  {
   return(NormalizeDouble(val, Digits));
  } 
/*  
int BuyOrderCount(double &openprice,double &lots)  //最近一次开多单的开仓价格【传引用值！The Last order openprice and lots】 Also return buy total order counts
  {
     int a=0;
     openprice=0;
     lots=0;
     for(int i=0;i<OrdersTotal();i++)
      {
        if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
          {
            if(OrderSymbol()==Symbol() && OrderType()==OP_BUY && OrderMagicNumber()==MAGIC)
              {
                a++;
                openprice=OrderOpenPrice();
                lots=OrderLots();
              }
          }
      }
    return(a);
  }
 int SellOrderCount(double &openprice,double &lots)     //最近一次开多单的开仓价格【传引用值！】
  {
     int a=0;
     openprice=0;
     lots=0;
     for(int i=0;i<OrdersTotal();i++)
      {
        if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
          {
            if(OrderSymbol()==Symbol() && OrderType()==OP_SELL && OrderMagicNumber()==MAGIC)
              {
                a++;
                openprice=OrderOpenPrice();
                lots=OrderLots();
              }
          }
      }
    return(a);
  }
  */
int BuyOrderCount()  // return buy total order counts
  {
     int a=0;
     for(int i=0;i<OrdersTotal();i++)
      {
        if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
          {
            if(OrderSymbol()==Symbol() && OrderType()==OP_BUY && OrderMagicNumber()==MAGIC)
              {
                a++;
              }
          }
      }
    return(a);
  }
 int SellOrderCount()     
  {
     int b=0;
     for(int i=0;i<OrdersTotal();i++)
      {
        if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
          {
            if(OrderSymbol()==Symbol() && OrderType()==OP_SELL && OrderMagicNumber()==MAGIC)
              {
                b++;
              }
          }
      }
    return(b);
  }  
int PendingBuyOrderCount()  // return buy total order counts
  {
     int a=0;
     for(int i=0;i<OrdersTotal();i++)
      {
        if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
          {
            if(OrderSymbol()==Symbol())
            {
              if(OrderType()==OP_BUYLIMIT)
              {
                a++;
              }
            }  
          }
      }
    return(a);
  }  
int PendingSellOrderCount()  // return buy total order counts
  {
     int a=0;
     for(int i=0;i<OrdersTotal();i++)
      {
        if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
          {
            if(OrderSymbol()==Symbol())
            {
              if(OrderType()==OP_SELLLIMIT)
              {
                a++;
              }
            }  
          }
      }
    return(a);
  }    
int BuyOrder(double lots,double sl,double tp,string com,int buymagic)  //check whether same order firstly and if not send buy order later 
  {
     RefreshRates();  
     int a=0;
     bool zhaodan=false;
     //double minstoplevel=MarketInfo(Symbol(),MODE_STOPLEVEL); 
     //Print("Minimum Stop Level=",minstoplevel," points"); 
     double price=MarketInfo(pairs,MODE_ASK); 
   //--- calculated SL and TP prices must be normalized 
     double stoploss=FormatTPSL(sl); 
     double takeprofit=FormatTPSL(tp); 
   //printf("minstoplevel= %f   takeprofit= %f",minstoplevel,takeprofit);
      for(int i=0;i<OrdersTotal();i++)
      {
        if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
          {
            string zhushi=OrderComment();
            int ma=OrderMagicNumber();
            if(OrderSymbol()==Symbol() && OrderType()==OP_BUY && zhushi==com && ma==buymagic)
              {
                zhaodan=true;
                break;
              }
          }
      }
    if(zhaodan==false)
      {
      //  if(sl!=0 && tp==0)
      //   {
      //    a=OrderSend(Symbol(),OP_BUY,lots,Ask,50,Ask-sl*Point,0,com,buymagic,0,White);
      //   }
        if(sl==0 && tp!=0)
         {
             a=OrderSend(Symbol(),OP_BUY,lots,price,500,NULL,takeprofit,com,buymagic,0,White);
             if(!a)
             {printf("Error BuyOrder! %s  %s  Lots= %s  TP_Level= %s ",Symbol(),com,DoubleToString(lots,Digits()),DoubleToString(tp,Digits())); Print("Error: ",ErrorDescription(GetLastError())); }
             else {printf("BuyOrder successfully! Ticket=%d  %s  %s  Lots= %s  TP_Level= %s",a,Symbol(),com,DoubleToString(lots,Digits()),DoubleToString(tp,Digits()));} 
         }
        if(sl==0 && tp==0)
         {
             a=OrderSend(Symbol(),OP_BUY,lots,price,500,NULL,NULL,com,buymagic,0,White);
             if(!a)
             {printf("Error BuyOrder! %s  %s  Lots= %s  TP_Level= %s ",Symbol(),com,DoubleToString(lots,Digits()),DoubleToString(tp,Digits())); Print("Error: ",ErrorDescription(GetLastError())); }
             else {printf("BuyOrder successfully! Ticket=%d  %s  %s  Lots= %s  TP_Level= %s",a,Symbol(),com,DoubleToString(lots,Digits()),DoubleToString(tp,Digits()));} 
         }
      //  if(sl!=0 && tp!=0)
      //   {
      //    a=OrderSend(Symbol(),OP_BUY,lots,Ask,50,Ask-sl*Point,Ask+tp*Point,com,buymagic,0,White);
      //  } 
      }
    return(a);
  }

int SellOrder(double lots,double sl,double tp,string com,int sellmagic)
  {
      RefreshRates();
      int a=0;
      bool zhaodan=false;
     // double minstoplevel=MarketInfo(Symbol(),MODE_STOPLEVEL); 
     //Print("Minimum Stop Level=",minstoplevel," points"); 
      double price=MarketInfo(pairs,MODE_ASK); 
   //--- calculated SL and TP prices must be normalized 
      double stoploss=FormatTPSL(sl); 
      double takeprofit=FormatTPSL(tp); 
      for(int i=0;i<OrdersTotal();i++)
      {
        if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
          {
            string zhushi=OrderComment();
            int ma=OrderMagicNumber();
            if(OrderSymbol()==Symbol() && OrderType()==OP_SELL && zhushi==com && ma==sellmagic)
              {
                zhaodan=true;
                break;
              }
          }
      }
    if(zhaodan==false)
      {
        if(sl==0 && tp!=0)
         {
             a=OrderSend(Symbol(),OP_SELL,lots,price,500,NULL,takeprofit,com,sellmagic,0,Red);
             if(!a)
             {printf("Error SellOrder! %s  %s  Lots= %s  TP_Level= %s ",Symbol(),com,DoubleToString(lots,Digits()),DoubleToString(tp,Digits()));Print("Error: ",ErrorDescription(GetLastError())); }
             else   {printf("SellOrder successfully! Ticket=%d  %s  %s  Lots= %s  TP_Level= %s",a,Symbol(),com,DoubleToString(lots,Digits()),DoubleToString(tp,Digits()));} 
         }
     //   if(sl!=0 && tp==0)
     //    {
     //      a=OrderSend(Symbol(),OP_SELL,lots,Bid,50,Bid+sl*Point,0,com,sellmagic,0,Red);
     //    }
        if(sl==0 && tp==0)
         {
             a=OrderSend(Symbol(),OP_SELL,lots,MarketInfo(pairs,MODE_BID),500,NULL,NULL,com,sellmagic,0,Red);
             if(!a)
             {printf("Error SellOrder! %s  %s  Lots= %s  TP_Level= %s  ",Symbol(),com,DoubleToString(lots,Digits()),DoubleToString(tp,Digits()));Print("Error: ",ErrorDescription(GetLastError())); }
             else   {printf("SellOrder successfully! Ticket=%d  %s  %s  Lots= %s  TP_Level= %s",a,Symbol(),com,DoubleToString(lots,Digits()),DoubleToString(tp,Digits()));} 
         }
     //   if(sl!=0 && tp!=0)
     //    {
     //      a=OrderSend(Symbol(),OP_SELL,lots,Bid,50,Bid+sl*Point,Bid-tp*Point,com,sellmagic,0,Red);
     //    }
      }
    return(a);
  }  

int BuyLimit(double price,double lots,double sl,double tp,string com,int buymagic)  //check whether same order firstly and if not send buy order later 
  {
      RefreshRates(); 
      int a=0;
      bool zhaodan=false;
      for(int i=0;i<OrdersTotal();i++)
      {
        if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)     //MODE_TRADES can be selected trading and pending orders
          {
            string zhushi=OrderComment();
            int ma=OrderMagicNumber();
            if(OrderSymbol()==Symbol() && OrderType()==OP_BUYLIMIT && zhushi==com && ma==buymagic)
              {
                zhaodan=true;
                break;
              }
          }
      }
    if(zhaodan==false)
      {
      //  if(sl!=0 && tp==0)
      //   {
      //    a=OrderSend(Symbol(),OP_BUY,lots,Ask,50,Ask-sl*Point,0,com,buymagic,0,White);
      //   }
        if(sl==0 && tp!=0)
         {
             a=OrderSend(Symbol(),OP_BUYLIMIT,lots,price,500,NULL,tp,com,buymagic,0,White);
             if(!a)
             {printf("Error BuyLimitOrder! %s  %s  Lots= %s  TP_Level= %s ",Symbol(),com,DoubleToString(lots,Digits()),DoubleToString(tp,Digits()));Print("Error: ",ErrorDescription(GetLastError())); }
             else  {printf("BuyLimitOrder successfully! Ticket=%d  %s  %s  Lots= %s  TP_Level= %s",a,Symbol(),com,DoubleToString(lots,Digits()),DoubleToString(tp,Digits()));} 
         }
        if(sl==0 && tp==0)
         {
             a=OrderSend(Symbol(),OP_BUYLIMIT,lots,price,500,NULL,NULL,com,buymagic,0,White);
             if(!a)
             {printf("Error BuyLimitOrder! %s  %s  Lots= %s  TP_Level= %s ",Symbol(),com,DoubleToString(lots,Digits()),DoubleToString(tp,Digits()) ); Print("Error: ",ErrorDescription(GetLastError()));}
             else {printf("BuyLimitOrder successfully! Ticket=%d  %s  %s  Lots= %s  TP_Level= %s",a,Symbol(),com,DoubleToString(lots,Digits()),DoubleToString(tp,Digits()));} 
         }
      //  if(sl!=0 && tp!=0)
      //   {
      //    a=OrderSend(Symbol(),OP_BUY,lots,Ask,50,Ask-sl*Point,Ask+tp*Point,com,buymagic,0,White);
      //  } 
      }
    return(a);
  }
  
int SellLimit(double price,double lots,double sl,double tp,string com,int sellmagic)
  {
      RefreshRates();
      int a=0;
      bool zhaodan=false;
      for(int i=0;i<OrdersTotal();i++)
      {
        if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
          {
            string zhushi=OrderComment();
            int ma=OrderMagicNumber();
            if(OrderSymbol()==Symbol() && OrderType()==OP_SELLLIMIT && zhushi==com && ma==sellmagic)
              {
                zhaodan=true;
                break;
              }
          }
      }
    if(zhaodan==false)
      {
        if(sl==0 && tp!=0)
         {
             a=OrderSend(Symbol(),OP_SELLLIMIT,lots,price,500,NULL,tp,com,sellmagic,0,Red);
             if(!a)
             {printf("Error SellLimitOrder! %s  %s  Lots= %s  TP_Level= %s ",Symbol(),com,DoubleToString(lots,Digits()),DoubleToString(tp,Digits()) );Print("Error: ",ErrorDescription(GetLastError())); }
             else {printf("SellLimitOrder successfully! Ticket=%d  %s  %s  Lots= %s  TP_Level= %s",a,Symbol(),com,DoubleToString(lots,Digits()),DoubleToString(tp,Digits()));} 
         }
     //   if(sl!=0 && tp==0)
     //    {
     //      a=OrderSend(Symbol(),OP_SELL,lots,Bid,50,Bid+sl*Point,0,com,sellmagic,0,Red);
     //    }
        if(sl==0 && tp==0)
         {
             a=OrderSend(Symbol(),OP_SELLLIMIT,lots,price,500,NULL,NULL,com,sellmagic,0,Red);
             if(!a)
             {printf("Error SellLimitOrder! %s  %s  Lots= %s  TP_Level= %s ",Symbol(),com,DoubleToString(lots,Digits()),DoubleToString(tp,Digits()) ); Print("Error: ",ErrorDescription(GetLastError()));}
             else {printf("SellLimitOrder successfully! Ticket=%d  %s  %s  Lots= %s  TP_Level= %s",a,Symbol(),com,DoubleToString(lots,Digits()),DoubleToString(tp,Digits()));} 
         }
     //   if(sl!=0 && tp!=0)
     //    {
     //      a=OrderSend(Symbol(),OP_SELL,lots,Bid,50,Bid+sl*Point,Bid-tp*Point,com,sellmagic,0,Red);
     //    }
      }
    return(a);
  }  
  void CloseBuyOrderPosition()
  {
     double myBid,myLot;
     int myType,i;
     bool result = false;
     int myTicket=0;
     string com;

     for(i=OrdersTotal()-1;i>=0;i--)
         {
                if(OrderSelect(i,SELECT_BY_POS))
                {
                       if(OrdersTotal()>0)                        // &&OrderSymbol()==SetYourSymbol
                              {                            
                              myTicket=OrderTicket();
                              myLot=OrderLots();
                              myType=OrderType();
                              com=OrderComment();
                          if(OrderSymbol()==Symbol() && (OrderMagicNumber() == MAGIC))
                          {
                              if(OrderType()==OP_BUYLIMIT  || OrderType()==OP_BUYSTOP )
                                {
                                    
                                    result=OrderDelete(myTicket);
                                }
                              if(OrderType()==OP_BUY)
                                {
                                    myBid=MarketInfo(OrderSymbol(),MODE_BID);
                                    result=OrderClose(myTicket,myLot,myBid,500,Yellow);
                                }
                                                         
                              if (result != 1) 
                              {
                               printf("OrderClose Error! %s  %s  Lots= %s  Ticket= %s ",Symbol(),com,myLot,myTicket);
                               Print("Error: ",ErrorDescription(GetLastError()));
                              } printf("OrderClose Successful! %s  %s  Lots= %s  Ticket= %s ",Symbol(),com,myLot,myTicket);
                           }
                        }
                }
         }         
  } 
void CloseSellOrderPosition()
  {
     double myBid,myLot;
     int myType,i;
     bool result = false;
     int myTicket=0;
     string com;

     for(i=OrdersTotal()-1;i>=0;i--)
         {
                if(OrderSelect(i,SELECT_BY_POS))
                {
                       if(OrdersTotal()>0)                        // &&OrderSymbol()==SetYourSymbol
                              {                            
                              myTicket=OrderTicket();
                              myLot=OrderLots();
                              myType=OrderType();
                              com=OrderComment();
                          if(OrderSymbol()==Symbol() && (OrderMagicNumber() == MAGIC))
                          {
                              if(OrderType()==OP_SELLLIMIT || OrderType()==OP_SELLSTOP)
                                {
                                    result=OrderDelete(myTicket);
                                }
                              if(OrderType()==OP_SELL)
                                {
                                    myBid=MarketInfo(OrderSymbol(),MODE_ASK);
                                    result=OrderClose(myTicket,myLot,myBid,500,Yellow);
                                }
                                                        
                              if (result != 1) {
                               printf("OrderClose Error! %s  %s  Lots= %s  Ticket= %s ",Symbol(),com,myLot,myTicket);
                               Print("Error: ",ErrorDescription(GetLastError()));
                              } else printf("OrderClose Successful! %s  %s  Lots= %s  Ticket= %s ",Symbol(),com,myLot,myTicket);
                            }
                        }
                }
         }         
  } 
 
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
  
  
bool TradeTime(int starthour,int endhour)
  {
    bool a=false;
    if(starthour<=endhour)
     {
       if(TimeHour(TimeLocal())>=starthour && TimeHour(TimeLocal())<endhour)
         {
           a=true;
         }
     }
    else
     {
        if(TimeHour(TimeLocal())>=starthour || TimeHour(TimeLocal())<endhour)
         {
           a=true;
         }
     }
    return(a);
  }

void CheckTradeTime()
{
     Todaytime=TimeGMT();
     //printff(TimeToString(Todaytime,TIME_DATE));
     //checktime=true;
     MqlDateTime tm;
     if(SetTradingTime)
         {  
            if(TimeToStruct(Todaytime,tm))
                  {
                        if((tm.day_of_week!=BanTradingDay1)||(tm.day_of_week!=BanTradingDay2))   //周末不交易 (0-Sunday, 1-Monday, ... ,6-Saturday) 
                            {
                              checktime=false;
                            }//else{checktime=true;}
                        
                        if(tm.hour>=StartTradingTime){checktime=true;}else{checktime=false;}
                        
                        if(tm.hour==20)
                              {
                                if(SetTimeClose && (OrdersTotal()!=0))
                                       {
                                                 printf("It's time(23H tradingtime) to close all position!");
                                                 CloseBuyOrderPosition();CloseSellOrderPosition();   
                                       }
                              }
                  }
                      
          }
           else{checktime=true;}          
}
//+------------------------------------------------------------------+
//| History Check Function          FiboTPCount                      |check history close orders and counts then start new trading section
//+------------------------------------------------------------------+
int HistoryCheckOrder_Buy(datetime startopen)
{
   buyordercounts=0;
   if(startopen != 0)
   for(int r=0;r<OrdersHistoryTotal();r++)
      {
         if(OrderSelect(r,SELECT_BY_POS,MODE_HISTORY))
            {
               if(OrderSymbol()==Symbol() && OrderType()==OP_BUY)
                  {
                     if(OrderOpenTime()>=startopen && (OrderCloseTime()<TimeCurrent()))buyordercounts++;
                  } 
            }
      }
     return(buyordercounts);
}

int HistoryCheckOrder_Sell(datetime startopen)
{
   sellordercounts=0;
   if(startopen != 0)
   for(int r=0;r<OrdersHistoryTotal();r++)
      {
         if(OrderSelect(r,SELECT_BY_POS,MODE_HISTORY))
            {
     
               if(OrderSymbol()==Symbol() && OrderType()==OP_SELL)
                  {
                     if(OrderOpenTime()>=startopen && (OrderCloseTime()<TimeCurrent()))sellordercounts++;
                  }   
            }
      }
     return(sellordercounts);
}

int HistoryCheckOrder_Specific(datetime startopen,int ordertype,string com)
{
   buyordercounts=0;
   for(int r=0;r<OrdersHistoryTotal();r++)
      {
         if(OrderSelect(r,SELECT_BY_POS,MODE_HISTORY))
            {
               if(OrderSymbol()==Symbol() && OrderType()==ordertype && OrderComment()== com)
                  {
                     if(OrderOpenTime()>=startopen && (OrderCloseTime()<TimeCurrent()))buyordercounts=1;
                  } 
            }
      }
     return(buyordercounts);
}

int CheckTradingOrderBuy_Specific(string com)
{
   buyordercounts=0;
   RefreshRates();
      int a=0;
      bool zhaodan=false;
      for(int i=0;i<OrdersTotal();i++)
      {
        if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
          {
            string zhushi=OrderComment();
            int ma=OrderMagicNumber();
            if(OrderSymbol()==Symbol() && OrderType()==OP_BUYLIMIT && zhushi==com && ma==MAGIC)
              {
                zhaodan=true;
                buyordercounts=1;
                break;
              }
              }
      }
     return(buyordercounts);
}
int CheckTradingOrderSell_Specific(string com)
{
   buyordercounts=0;
   RefreshRates();
      int a=0;
      bool zhaodan=false;
      for(int i=0;i<OrdersTotal();i++)
      {
        if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
          {
            string zhushi=OrderComment();
            int ma=OrderMagicNumber();
            if(OrderSymbol()==Symbol() && OrderType()==OP_SELLLIMIT && zhushi==com && ma==MAGIC)
              {
                zhaodan=true;
                buyordercounts=1;
                break;
              }
              }
      }
     return(buyordercounts);
}
int HistoryCheckOrder_Pending(datetime startopen)
{
   pending=0;
   for(int r=0;r<OrdersHistoryTotal();r++)
      {
         if(OrderSelect(r,SELECT_BY_POS,MODE_HISTORY))
            {
                if(OrderSymbol()==Symbol())
               if(OrderType()==OP_SELLLIMIT || OrderType()==OP_BUYLIMIT)
                  {
                     if(OrderOpenTime()>startopen && (OrderCloseTime()<TimeCurrent()))pending++;
                  }   
            }
      }
     return(pending);
}

int CheckDurationFromStart(datetime startopen,datetime closetime)
{
     int CalDay=0;
     datetime TodayTime=closetime;
     datetime CalTime=startopen;
     //printff(TimeToString(Todaytime,TIME_DATE));
     MqlDateTime tm,tm2;
     TimeToStruct(TodayTime,tm);
     TimeToStruct(CalTime,tm2);
       
     CalDay=tm.day_of_year - tm2.day_of_year;
     
      return(CalDay);              
}