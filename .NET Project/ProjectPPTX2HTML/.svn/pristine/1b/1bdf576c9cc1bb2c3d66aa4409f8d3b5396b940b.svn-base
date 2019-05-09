using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using DocumentFormat.OpenXml.Packaging;

namespace ClearSlideLibrary.Dom
{
    public class PPTGroupShape : PPTShapeBase
    {
        public PPTGroupShape(SlidePart slidePart, DocumentFormat.OpenXml.Presentation.GroupShape groupShape)
        {
            SetGroupShapeVisualProperties(slidePart, groupShape);
            SetGroupShapeNonVisualProperties(slidePart,groupShape);
        }


        private void SetGroupShapeNonVisualProperties(SlidePart slidePart,DocumentFormat.OpenXml.Presentation.GroupShape groupShape)
        {
            if (groupShape.NonVisualGroupShapeProperties.NonVisualDrawingProperties.HyperlinkOnClick != null)
                foreach (HyperlinkRelationship link in slidePart.HyperlinkRelationships)
                    if (link.Id.Equals(groupShape.NonVisualGroupShapeProperties.NonVisualDrawingProperties.HyperlinkOnClick.Id))
                        ClickLinkUrl = link.Uri.IsAbsoluteUri ? link.Uri.AbsoluteUri : link.Uri.OriginalString;

            if (groupShape.NonVisualGroupShapeProperties.NonVisualDrawingProperties.HyperlinkOnHover != null)
                foreach (HyperlinkRelationship link in slidePart.HyperlinkRelationships)
                    if (link.Id.Equals(groupShape.NonVisualGroupShapeProperties.NonVisualDrawingProperties.HyperlinkOnHover.Id))
                        HoverLinkUrl = link.Uri.IsAbsoluteUri ? link.Uri.AbsoluteUri : link.Uri.OriginalString;

            var nonVisualShapeProp = new PPTNonVisualShapeProp
            {
                Id = "s1s" +  //HARD CODED: we split it into separate HTML files!
                groupShape.NonVisualGroupShapeProperties.NonVisualDrawingProperties.Id,
                Name = groupShape.LocalName,
                Type = "PPTGroupShape"
            };
            base.NonVisualShapeProp = nonVisualShapeProp;
        }

        private void SetGroupShapeVisualProperties(SlidePart slidePart, DocumentFormat.OpenXml.Presentation.GroupShape groupShape)
        {
            base.VisualShapeProp = new PPTVisualPPTShapeProp();
            if (groupShape.GroupShapeProperties.TransformGroup != null)
            {
                base.VisualShapeProp.Extents = groupShape.GroupShapeProperties.TransformGroup.Extents;
                base.VisualShapeProp.Offset = groupShape.GroupShapeProperties.TransformGroup.Offset;
            }
            else
            {
                DocumentFormat.OpenXml.Presentation.ShapeTree shapeTree =
                    slidePart.SlideLayoutPart.SlideLayout.CommonSlideData.ShapeTree;
                DocumentFormat.OpenXml.Presentation.GroupShape layoutShape;
                if (shapeTree != null)
                {
                    layoutShape = shapeTree.GetFirstChild<DocumentFormat.OpenXml.Presentation.GroupShape>();
                    if (layoutShape.GroupShapeProperties.TransformGroup != null)
                    {
                        base.VisualShapeProp.Extents = layoutShape.GroupShapeProperties.TransformGroup.Extents;
                        base.VisualShapeProp.Offset = layoutShape.GroupShapeProperties.TransformGroup.Offset;
                    }
                }
            }
        }
    }

}

