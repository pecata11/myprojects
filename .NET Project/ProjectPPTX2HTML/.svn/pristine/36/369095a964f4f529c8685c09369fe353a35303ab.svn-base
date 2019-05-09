using System;
using System.IO;
using System.Collections.Generic;
using ClearSlideLibrary.Dom;
using DocumentFormat.OpenXml.Packaging;
using DocumentFormat.OpenXml.Presentation;
using Path = System.IO.Path;
using Shape = DocumentFormat.OpenXml.Presentation.Shape;
using System.Linq;
using System.Text;
using System.Xml;
using System.Xml.Linq;
using DocumentFormat.OpenXml.Drawing;
using DocumentFormat.OpenXml;


namespace ClearSlideLibrary.PPTBuilder
{
    
    public class PPTPresenationBuilder
    {
        public SlideSize SlideSizes { get; set; }

        public int getSlideWidth()
        {
            if (SlideSizes == null || SlideSizes.Cx == 0)
            {
                return 1;
            }
            else if (SlideSizes.Cx < Globals.LEAST_COMMON_MULTIPLE_100_254)
            {
                return Convert.ToInt32((double)(Globals.LEAST_COMMON_MULTIPLE_100_254) / SlideSizes.Cx);
            }
            else
            {
                return Convert.ToInt32(SlideSizes.Cx / (double)(Globals.LEAST_COMMON_MULTIPLE_100_254));
            }
        }

        public int getSlideHeight()
        {
            if (SlideSizes == null || SlideSizes.Cy == 0)
            {
                return 1;
            }
            else if (SlideSizes.Cy < Globals.LEAST_COMMON_MULTIPLE_100_254)
            {
                return Convert.ToInt32((double)(Globals.LEAST_COMMON_MULTIPLE_100_254) / SlideSizes.Cy);
            }
            else
            {
                return Convert.ToInt32(SlideSizes.Cy / (double)(Globals.LEAST_COMMON_MULTIPLE_100_254));
            }
        }


        public List<PPTSlide> GetPPTSlides(string pathToPresentation)
        {
            string fileFromPath = Path.GetFileName(pathToPresentation);
            var inf = new FileInfo(fileFromPath);
            string fileName = Path.GetFileNameWithoutExtension(inf.Name);

            string dir = Path.GetDirectoryName(Path.GetDirectoryName(Environment.CurrentDirectory));
            string destDir = Path.Combine(dir, Globals.STORAGE_DIR);

            PresentationDocument presentationDocument = null;
            try
            {
                presentationDocument = PresentationDocument.Open(pathToPresentation, false);
                //get the slide sizes.
                Presentation presentation = presentationDocument.PresentationPart.Presentation;
                SlideSizes = presentation.SlideSize;

            }
            catch (Exception ex)
            {
                throw new FileNotFoundException(
                    "PPTPresenationController.Ctor Unable to open Power Point Presentation.Path - "
                    + pathToPresentation, ex.InnerException);
            }
            if (presentationDocument == null)
            {
                throw new ArgumentNullException("Presentation Document missing");
            }
            IEnumerable<SlidePart> slideParts = GetPresentationSlideParts(presentationDocument);
            preserveWhitespaces(slideParts);//bug fix; whitespaces in separate runs are not preserved

            List<PPTSlide> pptSlides = GetPPTSlidesFromParts(slideParts, presentationDocument.PresentationPart.Presentation.DefaultTextStyle, fileName);
            presentationDocument.Close();
            List<PPTImage> pictures=new List<PPTImage>();
            foreach (PPTSlide slide in pptSlides)
                foreach (PPTShapeBase baseShape in slide.ContainerShape.Elements)
                    if (typeof(PPTImage).Equals(baseShape.GetType()))
                        pictures.Add((PPTImage)baseShape);

            


            var pptInteropt = new PPTBackgroundBuilderInterop(pathToPresentation, pictures);
            pptInteropt.ExportPresentationImages(destDir);
            pptInteropt = null;
            GC.Collect();

         

            return pptSlides;
        }

        private IEnumerable<SlidePart> GetPresentationSlideParts(PresentationDocument presentationDocument)
        {
            var slideParts = new List<SlidePart>();

            PresentationPart presentationPart = presentationDocument.PresentationPart;
            if (presentationPart != null && presentationPart.Presentation != null)
            {
                Presentation presentation = presentationPart.Presentation;

                if (presentation.SlideIdList != null)
                {
                    foreach (var slideId in presentation.SlideIdList.Elements<SlideId>())
                    {
                        try
                        {
                            slideParts.Add((SlidePart)presentationPart.GetPartById(slideId.RelationshipId));
                        }
                        catch (Exception ex)
                        {
                            throw new ArgumentNullException("Unable to add slide part." + ex.InnerException);
                        }
                    }
                }
            }

            return slideParts;
        }

        private List<PPTSlide> GetPPTSlidesFromParts(IEnumerable<SlidePart> slideParts, DefaultTextStyle defaultTextStyle, string fileName)
        {
            var pptSlides = new List<PPTSlide>();
            int slideIndex = 1;

            foreach (SlidePart slidePart in slideParts)
            {
                if (slideIndex > 1 && slidePart.Slide.Transition!=null && slidePart.Slide.Transition.AdvanceAfterTime!=null)
                {
                    pptSlides[pptSlides.Count - 1].advanceAfterTime = int.Parse(slidePart.Slide.Transition.AdvanceAfterTime.Value);
                }
                var pptSlide = new PPTSlide(slidePart, slideIndex++, defaultTextStyle, fileName, SlideSizes);
                
                pptSlides.Add(pptSlide);
            }

            return pptSlides;
        }
        private void preserveWhitespaces(IEnumerable<SlidePart> slideParts)
        {
            Dictionary<String, String> xTraverseMap = xTraverse(slideParts);
            openXmlTraverse(slideParts, xTraverseMap);
        }

        private Dictionary<String, String> xTraverse(IEnumerable<SlidePart> slideParts)
        {
            Dictionary<String, String> result = new Dictionary<string, string>();

            XNamespace p = "http://schemas.openxmlformats.org/presentationml/2006/main";
            XNamespace a = "http://schemas.openxmlformats.org/drawingml/2006/main";
            int slideNumber = 0;
            foreach (SlidePart slidePart in slideParts)
            {
                XDocument slideXDoc = slidePart.GetXDocument();
                IEnumerable<XElement> shapes = slideXDoc.Root.Element(p + "cSld").Element(p + "spTree").Elements(p + "sp");
                int shapeNumber = 0;
                foreach (XElement shape in shapes)
                {
                    IEnumerable<XElement> paragraphs = shape.Element(p + "txBody").Elements(a + "p");
                    int paragraphNumber = 0;
                    foreach (XElement paragraph in paragraphs)
                    {
                        IEnumerable<XElement> runs = paragraph.Elements(a + "r");

                        int runNumber = 0;
                        foreach (XElement run in runs)
                        {
                            string value = run.Element(a + "t").Value;
                            if (value.Trim() == "" || value.Trim() == "/t")
                            {
                                result.Add(
                                    slideNumber + "_" + shapeNumber + "_" + paragraphNumber + "_" + runNumber, value);
                            }

                            runNumber++;
                        }
                        paragraphNumber++;
                    }
                    shapeNumber++;
                }
                slideNumber++;
            }
            return result;
        }

        private void openXmlTraverse(IEnumerable<SlidePart> slideParts, Dictionary<String, String> xTraverseMap)
        {
            int slideNumber = 0;
            foreach (SlidePart slidePart in slideParts)
            {
                int shapeNumber = 0;
                foreach (Shape shape in slidePart.Slide.Descendants<Shape>())
                {
                    int paragraphNumber = 0;
                    foreach (Paragraph paragraph in shape.Descendants<Paragraph>())
                    {
                        int runNumber = 0;
                        foreach (Run run in paragraph.Descendants<Run>())
                        {
                            string txt = run.Text.Text;
                            string key = slideNumber + "_" + shapeNumber + "_" + paragraphNumber + "_" + runNumber;
                            string val;
                            if (txt == "" && xTraverseMap.TryGetValue(key, out val))
                            {
                                run.Text.Text = val;
                            }
                            runNumber++;
                        }
                        paragraphNumber++;
                    }
                    shapeNumber++;
                }
                slideNumber++;
            }
        }
    }

    public static class PtOpenXmlExtensions
    {
        public static XDocument GetXDocument(this OpenXmlPart part)
        {

            XDocument partXDocument = part.Annotation<XDocument>();
            if (partXDocument != null)
                return partXDocument;
            using (Stream partStream = part.GetStream())
            using (XmlReader partXmlReader = XmlReader.Create(partStream))
                partXDocument = XDocument.Load(partXmlReader);
            part.AddAnnotation(partXDocument);
            return partXDocument;
        }

        public static void PutXDocument(this OpenXmlPart part)
        {
            XDocument partXDocument = part.GetXDocument();
            if (partXDocument != null)
            {
                using (Stream partStream = part.GetStream(FileMode.Create, FileAccess.Write))
                using (XmlWriter partXmlWriter = XmlWriter.Create(partStream))
                    partXDocument.Save(partXmlWriter);
            }
        }
    }

}