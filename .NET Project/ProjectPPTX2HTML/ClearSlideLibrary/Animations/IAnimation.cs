using DocumentFormat.OpenXml.Presentation;
using System.Collections.Generic;

namespace ClearSlideLibrary.Animations
{
    public interface IAnimation
    {
        string GetJsonString();
        int Start { get; set; }
        int Length { get; set; }
        string ObjectId { get; set; }
        int Repetitions { get; set; }
        int InitialState { get; set; }
        string Type { get; set; }
        string AdditionalData { get; set; }
        List<IAnimation> InnerAnimations { get; set; }
        bool IsItEntranceAnimation();
    }
}