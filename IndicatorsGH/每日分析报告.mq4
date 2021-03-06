//+------------------------------------------------------------------+
//|                                             Horse Technology.mq4 |
//|                  Copyright 2020, Horse Technology Software Corp. |
//|                                       https://www.horseforex.net |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, Horse Technology Software Corp."

#property link      "https://www.horsegroup.net/en/"
#property version   "1.00"
#property strict
#property indicator_chart_window
#property description "交易货币对每日分析策略报告" 
#property description "注意：请仅做交易辅助使用！" 
#property description "指标所有权和归属权归于马汇科技@Horseforex" 
#property description "如需修改及自定义指标请联系VX:306599003" 
#property description "开户链接: https://secure.horsegroup.net/register/" 
#property description "Daily Trendcheck Info Indicators. Copyright@Horseforex" 
#property description "Open Account: https://secure.horsegroup.net/register/" 
#include <stderror.mqh> 
#include <stdlib.mqh> 

extern int  X_Distance=15;
extern int  Y_Distance=50;
extern color          TextColor = clrGold; 
extern bool           ShowPanel=true;
extern color          PanelColor  = clrDarkSlateGray; // Panel Background Color
int countcandle=20;


int calaryi;
int flag;
double balance;
double fiboValue0,fiboValue23,fiboValue38,fiboValue50,fiboValue61,fiboValue78,fiboValue100,fiboValue138,fiboValue168,fiboValue200;
double fiboPriceDiff,fiboPrice0,fiboPrice1,fiboPrecentage;
bool   FiboUptrend,FiboDowntrend;
double FiboLevel_1=0.236;
double FiboLevel_2=0.382;
double FiboLevel_3=0.5;
double FiboLevel_4=0.618;
double FiboLevel_5=1.0;
double FiboLevel_6=1.382;
double FiboLevel_7=1.5;
double FiboLevel_8=1.618;
double FiboLevel_9=2.0;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   //Print("The name of the broker = ",AccountInfoString(ACCOUNT_COMPANY)); 
   //Print("Deposit currency = ",AccountInfoString(ACCOUNT_CURRENCY)); 
   
   

   if(AccountInfoString(ACCOUNT_COMPANY)=="Horse Forex Ltd")
         {           
                TextCreate("PASS","Horse Technology @copyright",15,15,10,Red);
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
   if(ShowPanel)if(flag==1)RectLabelCreate(0,"BACKG",0,X_Distance-5,Y_Distance-10,350,330,PanelColor,BORDER_RAISED,CORNER_LEFT_UPPER,clrBlack,STYLE_SOLID,2);      
   Comment("Horse Technology @copyright\nhttps://www.horsegroup.net/");      
   return(INIT_SUCCEEDED);
  }
  void OnDeinit(const int reason)
  {
   DeleteAll();
   ObjectDelete(0,"PASS");
   ObjectDelete(0,"PASS1");
   ObjectDelete(0,"BACKG");
   
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
{
   //---
      CreateFibo();
   
      string pairs=Symbol();
      datetime Todaytime=TimeCurrent();
      double AskPrice=MarketInfo(pairs,MODE_ASK);
      double BidPrice=MarketInfo(pairs,MODE_BID);
      int    vdigits = (int)MarketInfo(pairs,MODE_DIGITS); 
      string trend,trendmacd,trendma,position,trendfibo;
      
      //double CalHigh,CalLow,CalSup,CalRes;
         
         
      double MACD_m_60=iMACD(pairs,PERIOD_H1,12,26,9,PRICE_CLOSE,MODE_MAIN,0);
      double MA_5D=iMA(pairs,PERIOD_D1,5,0,MODE_EMA,PRICE_CLOSE,0);   
      double SAR_4H=iSAR(pairs,PERIOD_CURRENT,0.02,0.2,0);
      
      if (AskPrice>= MA_5D) {trend="看涨"; trendma="之上";}
      else {trend="看跌"; trendma="之下";}  
      
      if (AskPrice>=SAR_4H) position="逢低做多";
      else position="逢高做空";         
      if(MACD_m_60>=0) trendmacd="上涨趋势";
      else trendmacd="下行趋势";    
      if(FiboUptrend)  trendfibo="支撑";
      if(FiboDowntrend) trendfibo="阻力";
      
      static string Text[];
      ArrayResize(Text,60);
      int Aryi=0;//倒转Aryi--;
      Text[Aryi]="欧洲："+TimeToString(TimeGMT()+3600)+"  美国："+TimeToString(TimeGMT()+3600-18000,TIME_SECONDS);Aryi++;
      Text[Aryi]="---------";Aryi++;   
      Text[Aryi]="市场观察：";Aryi++;
      Text[Aryi]="---------";Aryi++; 
      Text[Aryi]=pairs+" -- "+TimeToString(TimeLocal(),TIME_DATE)+" 日分析："+trend;Aryi++;
      Text[Aryi]="---------";Aryi++;
      Text[Aryi]="短线交易策略：";Aryi++;
      Text[Aryi]="---------";Aryi++; 
      Text[Aryi]=DoubleToString(fiboValue50,Digits)+"和"+DoubleToString(fiboValue100,Digits)+"点位存在"+trendfibo;Aryi++;
      Text[Aryi]="可尝试在"+DoubleToString(SAR_4H,Digits)+"附近"+position;Aryi++;  
      Text[Aryi]="---------";Aryi++;      
      Text[Aryi]="中长线技术点评：";Aryi++;
      Text[Aryi]="---------";Aryi++; 
      Text[Aryi]="MACD呈现"+trendmacd;Aryi++;
      Text[Aryi]="此外价格处于5日移动平均线"+trendma;Aryi++;
      Text[Aryi]="---------";Aryi++;      
      Text[Aryi]="【策略仅供参考】";Aryi++;
      calaryi=Aryi;

      for(int j=0; j<Aryi; j++) //if(j!=7&&j!=9){tempj++;}
        {
         if(Text[j]=="")
           {
            break;
           }
         if(flag==1)CreateLabel("CheckTrend"+IntegerToString(j),X_Distance,Y_Distance+(j)*18,""+Text[j],10,0,ANCHOR_LEFT_UPPER,TextColor);//(j+1)*A_信息间隔N,""+Text[j],A_信息大小,1,ANCHOR_RIGHT_UPPER,A_信息颜色);
        }
        
      ChartRedraw();
      return(0);
}


//+------------------------------------------------------------------+
void CreateLabel(string Name,int XDistance,int YDistance,string StringText,int FontSize,int Corner,int Anchor,color TextColor1)
  {
   if(ObjectFind(0,Name)==-1) //判断是否存在
     {
      ObjectCreate(0,Name,OBJ_LABEL,0,0,0); //第4个：ChartWindowFind()自适应第几个窗口、WindowFind("YCADX"+IntegerToString(ADX周期))查找在哪个窗口  WindowOnDropped()自适应窗口
      ObjectSetString(0,Name,OBJPROP_FONT,"宋体"); //字体 宋体比微软雅黑更清晰,但大字体时更模糊。 "微软雅黑"
      ObjectSetInteger(0,Name,OBJPROP_CORNER,0);//放哪个角落 0123为左右上下
      ObjectSetInteger(0,Name,OBJPROP_SELECTABLE,0); //0不可选取,1可被选取
     }
   ObjectSetInteger(0,Name,OBJPROP_FONTSIZE,FontSize);//文字大小
   ObjectSetInteger(0,Name,OBJPROP_COLOR,TextColor1); //文字颜色
   ObjectSetInteger(0,Name,OBJPROP_XDISTANCE,XDistance);//X轴位置
   ObjectSetInteger(0,Name,OBJPROP_YDISTANCE,YDistance);//Y轴位置
   ObjectSetString(0,Name,OBJPROP_TEXT,StringText); //插入string文字  //在大括号内部为不变更，外部为设置变更
   ObjectSetInteger(0,Name,OBJPROP_ANCHOR,Anchor); //向左对齐、向右对齐 //ANCHOR_LEFT_UPPER (向左上角对齐) ANCHOR_RIGHT_LOWER（向右下角对齐）
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
  
  void DeleteAll()
  {

//--- for all deals 
   for(int j=0; j<calaryi; j++) //if(j!=7&&j!=9){tempj++;}
        {
         //
         ObjectDelete(0,"CheckTrend"+IntegerToString(j));
        }
        }
        
        
        
          
bool RectLabelCreate(const long             chart_ID=0,               // chart's ID
                     const string           name="RectLabel",         // label name
                     const int              sub_window=0,             // subwindow index
                     const int              x=0,                      // X coordinate
                     const int              y=0,                      // Y coordinate
                     const int              width=50,                 // width
                     const int              height=18,                // height
                     const color            back_clr=C'236,233,216',  // background color
                     const ENUM_BORDER_TYPE border=BORDER_SUNKEN,     // border type
                     const ENUM_BASE_CORNER corner=CORNER_LEFT_UPPER, // chart corner for anchoring
                     const color            clr=clrRed,               // flat border color (Flat)
                     const ENUM_LINE_STYLE  style=STYLE_SOLID,        // flat border style
                     const int              line_width=1,             // flat border width
                     const bool             back=false,               // in the background
                     const bool             selection=false,          // highlight to move
                     const bool             hidden=true,              // hidden in the object list
                     const long             z_order=0)                // priority for mouse click
  {
//--- reset the error value
   ResetLastError();
//--- create a rectangle label
   if(!ObjectCreate(chart_ID,name,OBJ_RECTANGLE_LABEL,sub_window,0,0))
     {
      Print(__FUNCTION__,
            ": failed to create a rectangle label! Error code = ",GetLastError());
      return(false);
     }
//--- set label coordinates
   ObjectSetInteger(chart_ID,name,OBJPROP_XDISTANCE,x);
   ObjectSetInteger(chart_ID,name,OBJPROP_YDISTANCE,y);
//--- set label size
   ObjectSetInteger(chart_ID,name,OBJPROP_XSIZE,width);
   ObjectSetInteger(chart_ID,name,OBJPROP_YSIZE,height);
//--- set background color
   ObjectSetInteger(chart_ID,name,OBJPROP_BGCOLOR,back_clr);
//--- set border type
   ObjectSetInteger(chart_ID,name,OBJPROP_BORDER_TYPE,border);
//--- set the chart's corner, relative to which point coordinates are defined
   ObjectSetInteger(chart_ID,name,OBJPROP_CORNER,corner);
//--- set flat border color (in Flat mode)
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr);
//--- set flat border line style
   ObjectSetInteger(chart_ID,name,OBJPROP_STYLE,style);
//--- set flat border width
   ObjectSetInteger(chart_ID,name,OBJPROP_WIDTH,line_width);
//--- display in the foreground (false) or background (true)
   ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back);
//--- enable (true) or disable (false) the mode of moving the label by mouse
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection);
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection);
//--- hide (true) or display (false) graphical object name in the object list
   ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden);
//--- set the priority for receiving the event of a mouse click in the chart
   ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order);
//--- successful execution
   return(true);
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

        fiboPrice1=fiboPriceHigh;
        fiboPrice0=fiboPriceLow;
        FiboDowntrend=true;
        //--- Cal Fibo Down Precentage 
        fiboPrecentage=(fiboPrice1-fiboPrice0)/fiboPrice1;
        //printff("Down Trend!   Fibo_Precentage = %.3f    ",fiboPrecentage);
     }
      else
     {
 
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

     return(0);
}
