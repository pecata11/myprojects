using ClearSlideLibrary.Dom;
using DocumentFormat.OpenXml.Packaging;
using DocumentFormat.OpenXml.Presentation;
using System.Collections.Generic;

namespace ClearSlideLibrary.PPTBuilder
{
    internal class PPTContainerShapeBuilder
    {
        public PPTContainerShape GetPPTContainerShape(SlidePart slidePart, PPTSlide slide)
        {
            var pptContainerShape = new PPTContainerShape();
            pptContainerShape.Elements = new List<PPTShapeBase>();
            foreach (object obj in slidePart.Slide.Descendants())
            {
                if (typeof(Shape).Equals(obj.GetType()))
                {
                    pptContainerShape.Elements.Add(new PPTShape(slidePart,(Shape)obj, slide));
                }
                else if (typeof(Picture).Equals(obj.GetType()))
                {
                    pptContainerShape.Elements.Add(new PPTImage(slidePart, (Picture)obj));
                }
                else if (typeof(GraphicFrame).Equals(obj.GetType()))
                {
                    pptContainerShape.Elements.Add(new PPTGraphicFrame(slidePart, (GraphicFrame)obj));
                }
                else if (typeof(GroupShape).Equals(obj.GetType()))
                {
                    pptContainerShape.Elements.Add(new PPTGroupShape(slidePart, (GroupShape)obj));
                }
                else if (typeof(ConnectionShape).Equals(obj.GetType()))
                {
                    pptContainerShape.Elements.Add(new PPTConnectionShape(slidePart, (ConnectionShape)obj));
                } 
            }   


            return pptContainerShape;
        }
    }
}