using System.Linq;
using ClearSlideLibrary.Dom;
using DocumentFormat.OpenXml.Packaging;
using System.Collections.Generic;
using DocumentFormat.OpenXml.Presentation;

namespace ClearSlideLibrary.PPTBuilder
{
    public class PPTGraphicFrameBuilder
    {
        internal List<PPTGraphicFrame> GetGraphicFrames(SlidePart slidePart)
        {
            return slidePart.Slide.Descendants<GraphicFrame>().Select(graphicFrame => new PPTGraphicFrame(slidePart, graphicFrame)).ToList();
        }
    }
}