﻿using System.Collections.Generic;
using System.Linq;
using ClearSlideLibrary.Dom;
using DocumentFormat.OpenXml.Packaging;
using Picture = DocumentFormat.OpenXml.Presentation.Picture;

namespace ClearSlideLibrary.PPTBuilder
{
    public class PPTImageBuilder
    {
        public PPTImageBuilder()
        {
        }

        public List<PPTImage> GetImages(SlidePart slidePart)
        {
            return slidePart.Slide.Descendants<Picture>().Select(picture => new PPTImage(slidePart, picture)).ToList();
        }
    }
}