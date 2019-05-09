using System.Linq;
using ClearSlideLibrary.Dom;
using DocumentFormat.OpenXml.Packaging;
using System.Collections.Generic;
using DocumentFormat.OpenXml.Presentation;

namespace ClearSlideLibrary.PPTBuilder
{
    internal class PPTShapeBuilder
    {
        internal List<PPTShape> GetShapes(SlidePart slidePart, PPTSlide slide)
        {
            return slidePart.Slide.Descendants<Shape>().Select(shape => new PPTShape(slidePart, shape, slide)).ToList();
        }
    }
}