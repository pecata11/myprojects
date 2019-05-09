using System.Linq;
using ClearSlideLibrary.Dom;
using DocumentFormat.OpenXml.Packaging;
using System.Collections.Generic;
using DocumentFormat.OpenXml.Presentation;

namespace ClearSlideLibrary.PPTBuilder
{
    internal class PPTConnectionShapeBuilder
    {
        internal List<PPTConnectionShape> GetConnectionShapes(SlidePart slidePart)
        {
            return slidePart.Slide.Descendants<ConnectionShape>().Select(shape => new PPTConnectionShape(slidePart, shape)).ToList();
        }

    }
}
