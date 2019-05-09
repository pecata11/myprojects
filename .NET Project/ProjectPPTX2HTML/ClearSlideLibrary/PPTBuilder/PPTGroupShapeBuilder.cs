using System.Linq;
using ClearSlideLibrary.Dom;
using DocumentFormat.OpenXml.Packaging;
using System.Collections.Generic;
using DocumentFormat.OpenXml.Presentation;

namespace ClearSlideLibrary.PPTBuilder
{
    internal class PPTGroupShapeBuilder
    {
        internal List<PPTGroupShape> GetGroupShapes(SlidePart slidePart)
        {
            return slidePart.Slide.Descendants<GroupShape>().Select(shape => new PPTGroupShape(slidePart, shape)).ToList();
        }
    }
}
