using System.Linq;
using ClearSlideLibrary.Dom;
using DocumentFormat.OpenXml.Packaging;
using System.Collections.Generic;
using DocumentFormat.OpenXml.Presentation;

namespace ClearSlideLibrary.PPTBuilder
{
    internal class PPTTextBuilder
    {
        internal List<PPTText> GetShapes(SlidePart slidePart, int slideNumber)
        {
            return slidePart.Slide.Descendants<Shape>().Select(shape => new PPTText(slidePart, shape, slideNumber)).ToList();
        }
    }

    
}
