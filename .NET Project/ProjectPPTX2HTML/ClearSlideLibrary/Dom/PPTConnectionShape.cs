using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using DocumentFormat.OpenXml.Packaging;
using DocumentFormat.OpenXml.Presentation;


namespace ClearSlideLibrary.Dom
{
    public class PPTConnectionShape : PPTShapeBase
    {
        public PPTConnectionShape(SlidePart slidePart, ConnectionShape connectionShape)
        {
            SetConnectionShapeVisualProperties(slidePart, connectionShape);
            SetConnectionShapeNonVisualProperties(slidePart, connectionShape);
        }


        private void SetConnectionShapeNonVisualProperties(SlidePart slidePart, 
                                                           ConnectionShape connectionShape)
        {
            if (connectionShape.NonVisualConnectionShapeProperties.NonVisualDrawingProperties.HyperlinkOnClick != null)
                foreach (HyperlinkRelationship link in slidePart.HyperlinkRelationships)
                    if (link.Id.Equals(connectionShape.NonVisualConnectionShapeProperties.NonVisualDrawingProperties.HyperlinkOnClick.Id))
                        ClickLinkUrl = link.Uri.IsAbsoluteUri ? link.Uri.AbsoluteUri : link.Uri.OriginalString;

            if (connectionShape.NonVisualConnectionShapeProperties.NonVisualDrawingProperties.HyperlinkOnHover != null)
                foreach (HyperlinkRelationship link in slidePart.HyperlinkRelationships)
                    if (link.Id.Equals(connectionShape.NonVisualConnectionShapeProperties.NonVisualDrawingProperties.HyperlinkOnHover.Id))
                        HoverLinkUrl = link.Uri.IsAbsoluteUri ? link.Uri.AbsoluteUri : link.Uri.OriginalString;
            var nonVisualShapeProp = new PPTNonVisualShapeProp
            {
                Id = "s1s" +  //HARD CODED: we split it into separate HTML files!
                connectionShape.NonVisualConnectionShapeProperties.NonVisualDrawingProperties.Id,
                Name = connectionShape.LocalName,
                Type = "PPTConnectionShape"
            };
            base.NonVisualShapeProp = nonVisualShapeProp;
        }

        private void SetConnectionShapeVisualProperties(SlidePart slidePart,
                                                        ConnectionShape connectionShape)
        {
            base.VisualShapeProp = new PPTVisualPPTShapeProp();
            if (connectionShape.ShapeProperties.Transform2D != null)
            {
                base.VisualShapeProp.Extents = connectionShape.ShapeProperties.Transform2D.Extents;
                base.VisualShapeProp.Offset = connectionShape.ShapeProperties.Transform2D.Offset;
            }
            else
            {
                ShapeTree shapeTree = slidePart.SlideLayoutPart.SlideLayout.CommonSlideData.ShapeTree;
                ConnectionShape layoutShape;
                if (shapeTree != null)
                {
                    layoutShape = shapeTree.GetFirstChild<ConnectionShape>();
                    if (layoutShape.ShapeProperties.Transform2D != null)
                    {
                        base.VisualShapeProp.Extents = layoutShape.ShapeProperties.Transform2D.Extents;
                        base.VisualShapeProp.Offset = layoutShape.ShapeProperties.Transform2D.Offset;
                    }
                }
            }
        }
    }
}
