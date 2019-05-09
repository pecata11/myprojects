﻿using System;
using System.Text;
using ClearSlideLibrary.Dom;

namespace ClearSlideLibrary.HtmlController
{
    internal class HtmlText : HtmlPresentationElement
    {
        public string id { get; set; }
        public string Text { get; set; }
        public bool PictureBullet { get; set; }
        public bool isBullet { get; set; }
        public const int DefaultBulletSize = 12;
        public int bulletSize { get; set; }
        private bool bold;
        private bool italic;
        private string underline;
        public int slideIndex;
        public int width { get; set; }
        public double Rotate { get; set; }
        public void setLeft(int newLeft)
        {
            left = newLeft;
        }

      

        public HtmlText(int left, int top, string fontFamily, string fontColor, double fontSize, bool isBullet,
                         bool bold, bool italic, string underline, string id, int slideIndex)
        {
            base.fontSize = fontSize;
            base.left = left;
            base.top = top;
            base.fontFamily = fontFamily;
            this.isBullet = isBullet;
            base.fontColor = fontColor;
            this.bold = bold;
            this.italic = italic;
            this.id = id;
            this.slideIndex = slideIndex;

            if (underline != null)
            {
                if (underline.Equals("Single"))
                {
                    this.underline = "underline";
                }
                else if (underline.Equals("None"))
                {
                    this.underline = "none";
                }
            }
            else this.underline = "none";
        }

        public override string DrawElement()
        {
            if (id != null)
            {
                id = id.Substring(3);
                int tryParse = 0;
                if (int.TryParse(id, out tryParse))
                {
                    if (PPTShape.effectShapes.Contains(slideIndex + "_" + tryParse))
                    {
                        return "";
                    }
                }
            }

            string rot = "";
            if (Rotate != 0.0)
            {
                rot = "-o-transform:rotate(" + Rotate + "deg);-ms-transform:rotate(" + Rotate + "deg);-moz-transform:rotate(" + Rotate + "deg);-webkit-transform:rotate(" + Rotate + "deg);";

            }
            StringBuilder textBuilder = new StringBuilder();
            if (Text != null)
            {
                if (PictureBullet)
                {
                    textBuilder.Append("<pre style=\"top:" + top.ToString() + "px;left:" + left.ToString() + "px;" + rot + "\">");
                    textBuilder.Append("<br/><img width=\"" + bulletSize + "\" height=\"" + bulletSize + "\" src="+Text+">");
                    textBuilder.Append("</pre>");
                }
                else
                {
                    textBuilder.Append("<pre style=\"top:" + top.ToString() + "px;left:" + left.ToString() + "px; font-size:" + fontSize.ToString() + "px; color:" + fontColor + (italic ? ";font-style:italic" : "") + (bold ? ";font-weight:bold" : "") +(this.underline.Equals("none") ? "": ";text-decoration:" + this.underline) + ";font-family:" + fontFamily + ";" + rot + "\">");
                    textBuilder.Append(Text);
                    textBuilder.Append("</pre>");
                }
            }

            return textBuilder.ToString();
        }

        public override string ToString()
        {
            Console.WriteLine("The top is:" + top);
            Console.WriteLine("The left is:" + left);
            Console.WriteLine("The text is:" + Text);
            Console.WriteLine("The text color is:" + fontColor);
            Console.WriteLine("The text size is:" + fontSize);
            Console.WriteLine("The text family is:" + fontFamily);
            Console.WriteLine("The height is:" + height);
            return string.Format("[{0}, {1}, {2}, {3}, {4}, {5}]",
                          top, left, Text, fontColor, fontSize, fontFamily);
        }

        public bool sameProps(HtmlText other)
        {
            if (other == null)
            {
                return false;
            }
            return this.top == other.top
                && this.fontSize == other.fontSize
                && this.fontColor == other.fontColor
                && this.italic == other.italic
                && this.bold == other.bold
                && this.underline == other.underline
                && this.fontFamily == other.fontFamily;
        }
    }
}