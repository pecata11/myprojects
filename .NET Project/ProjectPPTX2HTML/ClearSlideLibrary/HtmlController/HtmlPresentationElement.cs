namespace ClearSlideLibrary.HtmlController
{
    internal abstract class HtmlPresentationElement
    {
        protected int top;
        protected int left;
        protected int width;
        protected int height;
        protected double fontSize;
        protected string fontFamily;
        protected string fontColor;
        protected string id;
        protected string cssClass;
        protected bool invisible;
        protected bool animatable;  

        public abstract string DrawElement();
    }
}