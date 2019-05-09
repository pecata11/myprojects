using System;
using DocumentFormat.OpenXml.Drawing;

namespace ClearSlideLibrary.Dom
{
    public class PPTVisualPPTShapeProp
    {
      
        public Offset Offset
        {
            get;
            set;
            
        }

        public Extents Extents
        {
            get; 
            set ;
        }

        public double Rotate
        {
            get;
            set;
        }

        public int PixelWidth(){
            if (Extents == null || Extents.Cx == 0)
            {
               return 1;
            }
             else if (Extents.Cx < Globals.LEAST_COMMON_MULTIPLE_100_254)
            {
                return
                    Convert.ToInt32((double)(Globals.LEAST_COMMON_MULTIPLE_100_254) / Extents.Cx);
            }
            else
            {
               return
                    Convert.ToInt32(Extents.Cx / (double)(Globals.LEAST_COMMON_MULTIPLE_100_254));
            }
        }
      
        public int PixelHeight(){
            if (Extents == null || Extents.Cy == 0)
            {
                return 1;
            }
            else if (Extents.Cy < Globals.LEAST_COMMON_MULTIPLE_100_254)
            {
               return
                    Convert.ToInt32((double)(Globals.LEAST_COMMON_MULTIPLE_100_254) / Extents.Cy);
            }
            else
            {
               return
                    Convert.ToInt32(Extents.Cy / (double)(Globals.LEAST_COMMON_MULTIPLE_100_254));
            }
        }

        public int Top() {
            if (Offset == null)
                return 0;
            return  Convert.ToInt32(Offset.Y / (double)(Globals.LEAST_COMMON_MULTIPLE_100_254)); 
        }
        public int Left() {
            if (Offset == null)
                return 0;
            return Convert.ToInt32(Offset.X / (double)(Globals.LEAST_COMMON_MULTIPLE_100_254)); 
        }             


        public SolidFill SolidFill { get; set; }

    }
}