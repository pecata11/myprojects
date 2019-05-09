using DocumentFormat.OpenXml.Presentation;
using System;
using System.Collections.Generic;
using System.Linq;
using DocumentFormat.OpenXml.Drawing;
using DocumentFormat.OpenXml;
using ClearSlideLibrary.Dom;



namespace ClearSlideLibrary.Animations
{
    public class EmphasisAnimation : SimpleAnimation
    {
        public EmphasisAnimation()
        {
            
        }
        
        public EmphasisAnimation(SimpleAnimation fromBase)
        {
            this.AdditionalData = fromBase.AdditionalData;          
            this.InitialState = fromBase.InitialState;
            this.InnerAnimations = fromBase.InnerAnimations;
            this.Start = fromBase.Start;
            this.Length = fromBase.Length;
            this.ObjectId = fromBase.ObjectId;
            this.Repetitions = fromBase.Repetitions;
            this.timingType = fromBase.timingType;
            this.Type = fromBase.Type;
            
            this.RGBColor = "[0,0,0]";
            this.Transparency = 0;
            this.RotationDegrees = 0;
            this.ScaleX = 0;
            this.ScaleY = 0;
            e1 = 1;
            e2 = 0;
        }

        public String RGBColor { get; set; }
        public double Transparency { get; set; }
        public int ScaleX { get; set; }
        public int ScaleY { get; set; }
        public int RotationDegrees { get; set; }
        public int e1 { get; set; }
        public int e2 { get; set; }

        public override string GetJsonString()
        {
            return "{objectId:" + GetObjectIdForJSON() + ",start:" + Start + ",length:" + Length + ",repeat:" + Repetitions + ",state:" + InitialState +
                   ",name:'" + Type + "',c7:0,additionalData:" + RotationDegrees + ",additionalData2:" + RotationDegrees + ",scaleX:" + ScaleX + ",scaleY:" + ScaleY +
                   ",color:" + RGBColor + ",transparency:" +

                   Transparency.ToString("0.##", System.Globalization.CultureInfo.GetCultureInfo("en-US").NumberFormat) + ",v:0,e0:" + GetE0Value() + ",e1:" + e1 + ",e2:" + e2 + GetE3Value() + "}";
        }

        public void setRgbColor(CommonTimeNode commonTimeNode, PPTSlide Slide)
        {
            RGBColor = "[0,0,0]";
            foreach (Object xmlEl in commonTimeNode.Descendants())
            {
                if (xmlEl.GetType().Equals(typeof(RgbColorModelHex)))
                {
                    RgbColorModelHex rgb = (RgbColorModelHex)xmlEl;
                    RGBColor = convertHEXtoRGB(((RgbColorModelHex)rgb).Val);
                }
                else if (xmlEl.GetType().Equals(typeof(SchemeColor)))
                {
                    string schemeCol = ((SchemeColor)xmlEl).Val;
                    DocumentFormat.OpenXml.Drawing.ColorScheme allSchemeCols =
                        Slide.SlideLayoutPart.SlideMasterPart.ThemePart.Theme.ThemeElements.ColorScheme;
                    foreach (OpenXmlCompositeElement desc in allSchemeCols.Descendants())
                    {
                        string currSchemeCol = desc.LocalName;
                        if (schemeCol == currSchemeCol ||
                            (schemeCol == "bg1" && currSchemeCol == "lt1") ||
                            (schemeCol == "bg2" && currSchemeCol == "lt2") ||
                            (schemeCol == "tx1" && currSchemeCol == "dk1") ||
                            (schemeCol == "tx2" && currSchemeCol == "dk2"))
                        {
                            if (typeof(RgbColorModelHex) == desc.FirstChild.GetType())
                            {
                                RGBColor = convertHEXtoRGB(((RgbColorModelHex)desc.FirstChild).Val);
                            }
                            else if (typeof(SystemColor) == desc.FirstChild.GetType())
                            {
                                RGBColor = convertHEXtoRGB(((SystemColor)desc.FirstChild).LastColor);
                            }
                        }
                    }
                    break;
                }
            }
        }

        private string convertHEXtoRGB(string hex)
        {
            var colorHtml = System.Drawing.ColorTranslator.FromHtml("#" + hex);
            string rgb = "[" + colorHtml.R + "," + colorHtml.G + "," + colorHtml.B + "]";
            return rgb;
        }
    }
}