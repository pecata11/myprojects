using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ClearSlideLibrary.HtmlController
{
    class HtmlGroupShape : HtmlPresentationElement
    {

        public HtmlGroupShape(string id, int width, int height,
                      int top, int left, bool invisible,
                      bool animatable)
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
            StringBuilder shapeBuilder = new StringBuilder();
            string style = invisible ? "DC0" : "DC1";

            //the object has animation.
            if (animatable)
            {
                shapeBuilder.Append("<div id=\"" + id + "\" style=\"top:" + top.ToString() + "px;left:" + left.ToString() +
                               "px;height:" + height.ToString() + "px;width:" + width.ToString() + "px;\">");
                shapeBuilder.Append("<div class=\"" + style + "\" id=\"" + id + "c" + "\">");
                shapeBuilder.Append("<img />");
                shapeBuilder.Append("</div>");
                shapeBuilder.Append("</div>");
            }
            else
            {
                shapeBuilder.Append("<div id=\"" + id + "\" style=\"top:" + top.ToString() + "px;left:" + left.ToString() +
                                 "px;height:" + height.ToString() + "px;width:" + width.ToString() + "px;\">");
                shapeBuilder.Append("<img/>");
                shapeBuilder.Append("</div>");
            }
            return shapeBuilder.ToString();
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

