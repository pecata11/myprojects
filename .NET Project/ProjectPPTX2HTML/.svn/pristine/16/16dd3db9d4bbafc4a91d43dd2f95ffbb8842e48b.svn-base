using System;
using System.Text;

namespace ClearSlideLibrary.HtmlController
{
    internal class HtmlSmartArt : HtmlPresentationElement
    {
        public HtmlSmartArt(string id, int width, int height,
                            int top, int left, bool invisible,
                            bool animatable)
           // frameId, width, height, top, left, visible, animatable
        {
            base.id = id;
            base.top = top;
            base.left = left;
            base.width = width;
            base.height = height;
            base.invisible = invisible;
            base.animatable = animatable;
        }

        public override string DrawElement()
        {
            StringBuilder smartArtBuilder = new StringBuilder();

            string style = invisible ? "DC0" : "DC1";
            //the object has animation.
            if (animatable)
            {
                smartArtBuilder.Append("<div id=\"" + id + "\" style=\"top:"
                                  + top.ToString() + "px;left:" + left.ToString() + "px;height:"
                                  + height.ToString() + "px;width:" + width.ToString() + "px;\">");
                smartArtBuilder.Append("<div class=\"" + style + "\" id=\"" + id + "c" + "\">");
                smartArtBuilder.Append("<img />");
                smartArtBuilder.Append("</div>");
                smartArtBuilder.Append("</div>");
            }
            else
            {
                smartArtBuilder.Append("<div id=\"" + id + "\" style=\"top:"
                                    + top.ToString() + "px;left:" + left.ToString() + "px;height:"
                                    + height.ToString() + "px;width:" + width.ToString() + "px;\">");
                smartArtBuilder.Append("<img/>");
                smartArtBuilder.Append("</div>");
            }
            return smartArtBuilder.ToString();
        }

        public override string ToString()
        {
            Console.WriteLine("The top is:" + top);
            Console.WriteLine("The left is:" + left);
            Console.WriteLine("The width is:" + width);
            Console.WriteLine("The height is:" + height);
            return string.Format("[{0}, {1}, {2}, {3}]", top, left, width, height);
        }
    }
}