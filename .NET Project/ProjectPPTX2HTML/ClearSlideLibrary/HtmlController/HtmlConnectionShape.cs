using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ClearSlideLibrary.HtmlController
{
    class HtmlConnectionShape:HtmlPresentationElement
    {

        public HtmlConnectionShape(string id, int width, int height,
               int top, int left, bool invisible, bool animatable)
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
            StringBuilder connectionShapeBuilder = new StringBuilder();
            string style = invisible ? "DC0" : "DC1";

             //the object has animation.
            if (animatable)
            {
                connectionShapeBuilder.Append("<div id=\"" + id + "\" style=\"top:" + top.ToString() + "px;left:" + left.ToString() +
                               "px;height:" + height.ToString() + "px;width:" + width.ToString() + "px;\">");
                connectionShapeBuilder.Append("<div class=\"" + style + "\" id=\"" + id + "c" + "\">");
                connectionShapeBuilder.Append("<img />");
                connectionShapeBuilder.Append("</div>");
                connectionShapeBuilder.Append("</div>");
            }
            else
            {
                    connectionShapeBuilder.Append("<div id=\"" + id + "\" style=\"top:" + top.ToString() + "px;left:" + left.ToString() +
                                     "px;height:" + height.ToString() + "px;width:" + width.ToString() + "px;\">");
                    connectionShapeBuilder.Append("<img/>");
                    connectionShapeBuilder.Append("</div>");
            }
            return connectionShapeBuilder.ToString();
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
