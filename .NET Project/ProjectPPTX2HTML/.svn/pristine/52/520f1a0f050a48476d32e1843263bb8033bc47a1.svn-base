using System;
using System.Text;

namespace ClearSlideLibrary.HtmlController
{
    internal class HtmlImageGIF : HtmlPresentationElement
    {
        private readonly string _src;
        private readonly string _nameOfImage;

        public int Width
        {
            set { base.width = value; }
        }

        public int Height
        {
            set { base.height = value; }
        }


        public HtmlImageGIF(string slideId, string src,
                            string nameOfImage, int top, int left)
        {
            base.id = slideId;
            base.top = top;
            base.left = left;
            this._src = src;
            this._nameOfImage = nameOfImage;
        }

        public override string DrawElement()
        {
            StringBuilder imageBuilder = new StringBuilder();

            string imageId = id + "s" + _nameOfImage;
            string source = _src + "/" + imageId + ".gif";
  
            imageBuilder.Append("<div id=\"" + imageId + "\" style=\"top:" + top.ToString() + "px;left:" +
                                left.ToString() + "px;height:" + height.ToString() + "px;width:" + width.ToString() +
                                "px;\">");
            imageBuilder.Append("<img src=\"" + source + "\" />");
            imageBuilder.Append("</div>");
            return imageBuilder.ToString();
        }

        public override string ToString()
        {
            Console.WriteLine("The top is:" + this.top);
            Console.WriteLine("The left is:" + this.left);
            Console.WriteLine("The width is:" + this.width);
            Console.WriteLine("The height is:" + this.height);
            Console.WriteLine("The src is:" + _src);
            return string.Format("[{0}, {1}, {2}, {3},{4}]", top, left, width, height, _src);
        }
    }
}