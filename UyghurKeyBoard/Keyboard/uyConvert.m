//
//  uyConvert.m
//  UyghurKeyBoard
//
//  Created by Mac on 14/11/1.
//  Copyright (c) 2014年 Sabirjan. All rights reserved.
//
#import "uyConvert.h"

@implementation uyConvert

#define AG_LENGTH_OF_FONT_SHAPE 44
#define DEFINED_STARTING_OF_UYGHUR_UNICODE 0x0600
#define DEFINED_END_OF_UYGHUR_UNICODE 0x06FF

//typedef bool UBool
//typedef uint16_t UChar;

/******************************************************************************
 * types
 *******************************************************************************/
typedef struct fontShapeTag{
    uint mid;
    uint head;
    uint back;
    uint single;
}fontShapeInfo;


const fontShapeInfo fontShape[AG_LENGTH_OF_FONT_SHAPE]=
{
    {0xfe8e,0xfe8d,0xfe8e,0xfe8d},
    {0xfeea,0xfee9,0xfeea,0xfee9},
    {0xfe92,0xfe91,0xfe90,0xfe8f},
    {0xfb59,0xfb58,0xfb57,0xfb56},
    {0xfe98,0xfe97,0xfe96,0xfe95},
    {0xfea0,0xfe9f,0xfe9e,0xfe9d},
    {0xfb7d,0xfb7c,0xfb7b,0xfb7a},
    {0xfea8,0xfea7,0xfea6,0xfea5},
    {0xfeaa,0xfea9,0xfeaa,0xfea9},
    {0xfeae,0xfead,0xfeae,0xfead},
    {0xfeb0,0xfeaf,0xfeb0,0xfeaf},
    {0xfb8b,0xfb8a,0xfb8b,0xfb8a},
    {0xfeb4,0xfeb3,0xfeb2,0xfeb1},
    {0xfeb8,0xfeb7,0xfeb6,0xfeb5},
    {0xfed0,0xfecf,0xfece,0xfecd},
    {0xfed4,0xfed3,0xfed2,0xfed1},
    {0xfed8,0xfed7,0xfed6,0xfed5},
    {0xfedc,0xfedb,0xfeda,0xfed9},
    {0xfb95,0xfb94,0xfb93,0xfb92},
    {0xfbd6,0xfbd5,0xfbd4,0xfbd3},
    {0xfee0,0xfedf,0xfede,0xfedd},
    {0xfefc,0xfefb,0xfefc,0xfefb},
    {0xfee4,0xfee3,0xfee2,0xfee1},
    {0xfee8,0xfee7,0xfee6,0xfee5},
    {0xfeee,0xfeed,0xfeee,0xfeed},
    {0xFEEE,0xFEED,0xFEEE,0xFEED},//sabirjan edit
    {0xfbd8,0xfbd7,0xfbd8,0xfbd7},
    {0xFBD8,0xFBD7,0xFBD8,0xFBD7},//sabirjan edit
    {0xfbda,0xfbd9,0xfbda,0xfbd9},
    {0xFBDA,0xFBD9,0xFBDA,0xFBD9},//sabirjan edit
    {0xfbdc,0xfbdb,0xfbdc,0xfbdb},
    {0xFBDC,0xFBDB,0xFBDC,0xFBDB},//sabirjan edit
    {0xfbdf,0xfbde,0xfbdf,0xfbde},
    {0xfbe7,0xfbe6,0xfbe5,0xfbe4},
    {0xfbd1,0xfbf8,0xFBE5,0xFBE4},//sabirjan edit
    {0xfbe9,0xfbe8,0xfef0,0xfeef},
    {0xfbd2,0xfbfb,0xFEF0,0xFEEF},//sabirjan edit
    {0xfef4,0xfef3,0xfef2,0xfef1},
    {0xFE8E,0xFE8D,0xFE8E,0xFE8D},//Sabirjan edit
    {0xFEEA,0xFEE9,0xFEEA,0xFEE9},//Sabirjan edit
    {0xFBAd,0xFBAc,0xFBAb,0xFBAa},
    {0xfe8c,0xfe8b,0xfe8c,0xfe8b},
    {0xfe8c,0xfe8b,0xfe8c,0xfe8b},
    // {0xab,0xab,0xab,0xab},
};




/*************************************************************************
 *  function prototypes
 **************************************************************************/
//UChar u_shapeUyghur(const UChar * inPut,UChar n1,UChar * outPut);
//bool hasUyghurLetters (const UChar *str, int len);


int hasUyghurLetters(const uint *str, int len)
{
    int i=0;
    for (; i < len; i++)
    {
        if (str[i] >= DEFINED_STARTING_OF_UYGHUR_UNICODE && str[i] <= DEFINED_END_OF_UYGHUR_UNICODE)
        {
            return 1;
        }
    }
    return 0;
}
/***************************************************************************
 * 维吾尔文自动选型函数
 ***************************************************************************/

void invertBuffer(uint *buffer,int size) {
    uint temp;
    int i=0;
    int j=size-1;
    for(;i<j;i++,j--) {
        temp = buffer[i];
        buffer[i] = buffer[j];
        buffer[j] = temp;
    }
}
/*******************************************************************
 * 维吾尔文自动选型函数
 *******************************************************************/
+(NSString *) u_shapeUyghur:(NSString *)inPut //自动选形用于UNICODE转换为北大方正文件
{
    
    int len=[inPut length];
    uint leftPosition[3]={0,0,0};
    uint thisPosition = 0;
    uint thisArrayLen = 0;
    uint thisChar = 0;
    uint la = 0;
    uint pos1,pos2,pos3;
    uint temp1;
    uint tag1;
    unichar* outPut=(unichar *)malloc(len*sizeof(unichar));
    
    if (len == 0) return(0);
    for(int i = 0 ;i < len ;i++)
    {
        tag1 = 0;
        thisArrayLen++;
        if(([inPut characterAtIndex:i]>1573)&&([inPut characterAtIndex:i]<1750))
        {
            if(i == 0)
                pos1=32;
            else
                pos1 = [inPut characterAtIndex:i-1];
            pos2 = [inPut characterAtIndex:i];
            if(i == len-1)
                pos3=32;
            else
                pos3 = [inPut characterAtIndex:i+1];
            thisChar = pos2;
            switch(thisChar)
            {
                case 1575:
                    switch(pos1)
                {
                    case 0x628:case 0x67e:case 0x62a:case 0x62c:case 0x686:case 0x62e:case 0x62f:case 0x631:case 0x632:case 0x698:case 0x633:case 0x634:
                    case 0x63a:case 0x641:case 0x642:case 0x643:case 0x6af:case 0x6ad:case 0x645:case 0x646:case 0x6be:case 0x6cb:case 0x64a:case 0x626:
                        thisPosition=0;
                        break;
                    case 1604:
                        la=1;
                        thisArrayLen--;
                        thisPosition=21;
                        break;
                    default:
                        thisPosition=38;
                }
                    break;
                case 1749:
                    switch(pos1)
                {
                    case 0x628:case 0x67e:case 0x62a:case 0x62c:case 0x686:case 0x62e:case 0x62f:case 0x631:case 0x632:case 0x698:case 0x633:case 0x634:
                    case 0x63a:case 0x641:case 0x642:case 0x643:case 0x6af:case 0x6ad:case 0x644:case 0x645:case 0x646:case 0x6be:case 0x6cb:case 0x64a:case 0x626:
                        thisPosition=1;
                        break;
                    default:
                        thisPosition=39;
                }
                    break;
                case 1608:
                    switch(pos1)
                {
                    case 0x628:case 0x67e:case 0x62a:case 0x62c:case 0x686:case 0x62e:case 0x62f:case 0x631:case 0x632:case 0x698:case 0x633:case 0x634:
                    case 0x63a:case 0x641:case 0x642:case 0x643:case 0x6af:case 0x6ad:case 0x644:case 0x645:case 0x646:case 0x6be:case 0x6cb:case 0x64a:case 0x626:
                        thisPosition=24;
                        break;
                    default:
                        thisPosition=25;
                }
                    break;
                case 1734:
                    switch(pos1)
                {
                    case 0x628:case 0x67e:case 0x62a:case 0x62c:case 0x686:case 0x62e:case 0x62f:case 0x631:case 0x632:case 0x698:case 0x633:case 0x634:
                    case 0x63a:case 0x641:case 0x642:case 0x643:case 0x6af:case 0x6ad:case 0x644:case 0x645:case 0x646:case 0x6be:case 0x6cb:case 0x64a:case 0x626:
                        thisPosition=28;
                        break;
                    default:
                        thisPosition=29;
                }
                    break;
                case 1736:
                    switch(pos1)
                {
                    case 0x628:case 0x67e:case 0x62a:case 0x62c:case 0x686:case 0x62e:case 0x62f:case 0x631:case 0x632:case 0x698:case 0x633:case 0x634:
                    case 0x63a:case 0x641:case 0x642:case 0x643:case 0x6af:case 0x6ad:case 0x644:case 0x645:case 0x646:case 0x6be:case 0x6cb:case 0x64a:case 0x626:
                        thisPosition=30;
                        break;
                    default:
                        thisPosition=31;
                }
                    break;
                case 1735:
                    switch(pos1)
                {
                    case 0x628:case 0x67e:case 0x62a:case 0x62c:case 0x686:case 0x62e:case 0x62f:case 0x631:case 0x632:case 0x698:case 0x633:case 0x634:
                    case 0x63a:case 0x641:case 0x642:case 0x643:case 0x6af:case 0x6ad:case 0x644:case 0x645:case 0x646:case 0x6be:case 0x6cb:case 0x64a:case 0x626:
                        thisPosition=26;
                        break;
                    default:
                        thisPosition=27;
                }
                    break;
                case 1744:
                    switch(pos1)
                {
                    case 0x628:case 0x67e:case 0x62a:case 0x62c:case 0x686:case 0x62e:case 0x62f:case 0x631:case 0x632:case 0x698:case 0x633:case 0x634:
                    case 0x63a:case 0x641:case 0x642:case 0x643:case 0x6af:case 0x6ad:case 0x644:case 0x645:case 0x646:case 0x6be:case 0x6cb:case 0x64a:case 0x626:
                        thisPosition=33;
                        break;
                    default:
                        thisPosition=34;
                }
                    break;
                case 1609:
                    switch(pos1)
                {
                    case 0x628:case 0x67e:case 0x62a:case 0x62c:case 0x686:case 0x62e:case 0x62f:case 0x631:case 0x632:case 0x698:case 0x633:case 0x634:
                    case 0x63a:case 0x641:case 0x642:case 0x643:case 0x6af:case 0x6ad:case 0x644:case 0x645:case 0x646:case 0x6be:case 0x6cb:case 0x64a:case 0x626:
                        thisPosition=35;
                        break;
                    default:
                        thisPosition=36;
                }
                    break;
                case 1610:
                    thisPosition = 37;break;
                case 1576:
                    thisPosition = 2;break;
                case 1662:
                    thisPosition = 3;break;
                case 1578:
                    thisPosition = 4;break;
                case 1580:
                    thisPosition = 5;break;
                case 1670:
                    thisPosition = 6;break;
                case 1582:
                    thisPosition = 7;break;
                case 1583:
                    thisPosition = 8;break;
                case 1585:
                    thisPosition = 9;break;
                case 1586:
                    thisPosition = 10;break;
                case 1688:
                    thisPosition = 11;break;
                case 1587:
                    thisPosition = 12;break;
                case 1588:
                    thisPosition = 13;break;
                case 1594:
                    thisPosition = 14;break;
                case 1601:
                    thisPosition = 15;break;
                case 1602:
                    thisPosition = 16;break;
                case 1603:
                    thisPosition = 17;break;
                case 1711:
                    thisPosition = 18;break;
                case 1604:
                    thisPosition = 20;break;
                case 1605:
                    thisPosition = 22;break;
                case 1606:
                    thisPosition = 23;break;
                case 1726:
                    thisPosition = 40;break;
                case 1739:
                    thisPosition = 32;break;
                case 1709:
                    thisPosition = 19;break;
                case 1574:
                    thisPosition = 41;break;
                default:
                {
                    outPut[thisArrayLen-1]=[inPut characterAtIndex:i];
                    tag1 = 1;
                }
                    
            }
            if (tag1 == 1)
            {
                continue;
            }
            if (2+i-1-la < 2)
                temp1 = 32;
            else
                temp1 = [inPut characterAtIndex:i-1-la];
            switch(temp1)
            {
                case 1610:case 1744:case 1609:case 1576:case 1662:case 1578:case 1580:case 1670:case 1582:case 1587:case 1588:case 1594:
                case 1601:case 1602:case 1603:case 1604:case 1605:case 1606:case 1711:case 1726:case 1709:case 1574:
                    leftPosition[0]=1;break;
                default:
                    leftPosition[0]=0;
            }
            switch(pos2)
            {
                case 1610:case 1744:case 1609:case 1576:case 1662:case 1578:case 1580:case 1670:case 1582:case 1587:case 1588:case 1594:
                case 1601:case 1602:case 1603:case 1604:case 1605:case 1606:case 1711:case 1726:case 1709:case 1574:
                    leftPosition[1]=1;break;
                default:
                    leftPosition[1]=0;
            }
            switch(pos3)
            {
                case 1610:case 1744:case 1609:case 1576:case 1662:case 1578:case 1580:case 1670:case 1582:case 1587:case 1588:case 1594:
                case 1601:case 1602:case 1603:case 1604:case 1605:case 1606:case 1711:case 1726:case 1709:case 1574:
                    leftPosition[2]=1;break;
                default:
                    leftPosition[2]=0;
            }
            if(leftPosition[0]==0 && leftPosition[1]==0 &&(leftPosition[2]==0 || leftPosition[2]==1))
                outPut[thisArrayLen-1]=fontShape[thisPosition].single;
            if(leftPosition[0]==0 && leftPosition[1]==1 && leftPosition[2]==0)
            {
                if((pos3 > 1573) && (pos3 < 1750))
                    outPut[thisArrayLen-1]=fontShape[thisPosition].head;
                else
                    outPut[thisArrayLen-1]=fontShape[thisPosition].single;
                
            }
            if(leftPosition[0]==0 && leftPosition[1]==1 && leftPosition[2]==1)
                outPut[thisArrayLen-1]=fontShape[thisPosition].head;
            if(leftPosition[0]==1 && leftPosition[1]==0 &&(leftPosition[2]==0 || leftPosition[2]==1))
                outPut[thisArrayLen-1]=fontShape[thisPosition].back;
            if(leftPosition[0]==1 && leftPosition[1]==1 && leftPosition[2]==0)
            {
                if((pos3>1573)&&(pos3<1750))
                    outPut[thisArrayLen-1] = fontShape[thisPosition].mid;
                else
                    outPut[thisArrayLen-1]=fontShape[thisPosition].back;
            }
            if(leftPosition[0] == 1 && leftPosition[1] == 1 && leftPosition[2] == 1)
                outPut[thisArrayLen-1] = fontShape[thisPosition].mid;
        }
        else
        {
            outPut[thisArrayLen-1] = [inPut characterAtIndex:i];
        }
        la = 0;
    }
    NSString* toReturn=[NSString stringWithCharacters:outPut length:thisArrayLen];
    toReturn=[toReturn stringByReplacingOccurrencesOfString:@"\u200f" withString:@""];
    return [NSString stringWithFormat:@"\u200f%@",toReturn];
}

//自动选形结束



/*******************************************************************
 * 扩展区转换基本区的代码
 *******************************************************************/
+(NSString*)GetUy0600Char:(uint)aChar
{
    switch (aChar)
    {
        case 0xFE8F:
        case 0xFE91:
        case 0xFE92:
        case 0xFE90:
            return @"ب";
        case 0xFB56:
        case 0xFB57:
        case 0xFB58:
        case 0xFB59:
            return @"پ";
        case 0xFE95:
        case 0xFE96:
        case 0xFE97:
        case 0xFE98:
            return @"ت";
        case 0xFE9D:
        case 0xFE9E:
        case 0xFE9F:
        case 0xFEA0:
            return @"ج";
        case 0xFB7A:
        case 0xFB7B:
        case 0xFB7C:
        case 0xFB7D:
            return @"چ";
        case 0xFEA9:
        case 0xFEAA:
            return @"د";
        case 0xFEAD:
        case 0xFEAE:
            return @"ر";
        case 0xFEAF:
        case 0xFEB0:
            return @"ز";
        case 0xFEB1:
        case 0xFEB2:
        case 0xFEB3:
        case 0xFEB4:
            return @"س";
        case 0xFEB5:
        case 0xFEB6:
        case 0xFEB7:
        case 0xFEB8:
            return @"ش";
        case 0xFED1:
        case 0xFED2:
        case 0xFED3:
        case 0xFED4:
            return @"ف";
        case 0xFED5:
        case 0xFED6:
        case 0xFED7:
        case 0xFED8:
            return @"ق";
        case 0xFED9:
        case 0xFEDA:
        case 0xFEDB:
        case 0xFEDC:
            return @"ك";
        case 0xFB92:
        case 0xFB93:
        case 0xFB94:
        case 0xFB95:
            return @"گ";
        case 0xFBD3:
        case 0xFBD4:
        case 0xFBD5:
        case 0xFBD6:
            return @"ڭ";
        case 0xFEDD:
        case 0xFEDE:
        case 0xFEDF:
        case 0xFEE0:
            return @"ل";
        case 0xFEE1:
        case 0xFEE2:
        case 0xFEE3:
        case 0xFEE4:
            return @"م";
        case 0xFEE5:
        case 0xFEE6:
        case 0xFEE7:
        case 0xFEE8:
            return @"ن";
        case 0xFBDE:
        case 0xFBDF:
            return @"ۋ";
        case 0xFEF1:
        case 0xFEF2:
        case 0xFEF3:
        case 0xFEF4:
            return @"ي";
        case 0xFB8A:
        case 0xFB8B:
            return @"ژ";
        case 0xFEA5:
        case 0xFEA6:
        case 0xFEA7:
        case 0xFEA8:
            return @"خ";
        case 0xFECD:
        case 0xFECE:
        case 0xFECF:
        case 0xFED0:
            return @"غ";
        case 0xFBEA:
        case 0xFBEB:
            return @"ئا";
        case 0xFE8D:
        case 0xFE8E:
            return @"ا";
        case 0xFBEC:
        case 0xFBED:
            return @"ئە";
        case 0xFEE9:
        case 0xFEEA:
            return @"ە";
        case 0xFBEE:
        case 0xFBEF:
            return @"ئو";
        case 0xFEED:
        case 0xFEEE:
            return @"و";
        case 0xFBF0:
        case 0xFBF1:
            return @"ئۇ";
        case 0xFBD7:
        case 0xFBD8:
            return @"ۇ";
        case 0xFBF2:
        case 0xFBF3:
            return @"ئۆ";
            
        case 0xFBD9:
        case 0xFBDA:
            
            return @"ۆ";
            
        case 0xFBF4:
        case 0xFBF5:
            return @"ئۈ";
        case 0xFBDB:
        case 0xFBDC:
            return @"ۈ";
        case 0xFBF6:
        case 0xFBF7:
        case 0xFBF8:
        case 0xFBD1:
            return @"ې";//@"ئې";
        case 0xFBE4:
        case 0xFBE5:
        case 0xFBE6:
        case 0xFBE7:
            return @"ې";
        case 0xFBF9:
        case 0xFBFA:
        case 0xFBFB:
        case 0xfbd2:
            return @"ى";//@"ئى";
        case 0xFEEF:
        case 0xFBE8:
        case 0xFBE9:
        case 0xFEF0:
            return @"ى";
        case 0xFBAA:
        case 0xFBAB:
        case 0xFBAC:
        case 0xFBAD:
            return @"ھ";
        case 0xFE8B:
        case 0xFE8C:
            return @"ئ";
        case 0xFEFB:
        case 0xFEFC:
            return @"لا";
        case 0x2212:
            return @"-";
        case 0x60c:
            return @"،";
        case 0x61b:
            return @"؛";
        case 0x61F:
            return @"؟";
        case 0xAB:
            return @"»";
        case 0xBB:
            return @"«";
    }
    return [NSString stringWithFormat:@"%c",aChar];
}

+(NSString*)kuozhan2jiben:(NSString *)text
{
    @try
    {
        int txtLength=text.length;
        NSMutableString* strResult=[[NSMutableString alloc]initWithCapacity:txtLength];
        unichar ch;
        for(int i=0;i<txtLength;i++)
        {
            ch=[text characterAtIndex:i];
            if(ch>=0xfb56 && ch<=0xfefF)
            {
                [strResult appendString:[self GetUy0600Char:ch]];
            }
            else
            {
                [strResult appendString:[NSString stringWithFormat:@"%C",ch]];
            }
        }
        return [strResult stringByReplacingOccurrencesOfString:@"\u200f" withString:@""];
        
    }
    @catch (NSException *exception) {
        NSLog(@"~~~>>:%@",exception.reason);
        return @"Err";
    }
}

@end