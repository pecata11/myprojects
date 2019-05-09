namespace ClearSlideLibrary.Animations
{
    internal class TransitionAnimation : SimpleAnimation
    {
        public bool AdvanceOnClick { get; set; }
        
        public override string GetJsonString()
        {
            return "{objectId:" + GetObjectIdForJSON() + ",start:" + Start + ",length:" + Length + ",repeat:" + Repetitions + ",state:" + InitialState +
                   ",name:'" + Type + "',additionalData:" + AdditionalData + "},v:0,n:" + (AdvanceOnClick ? "0" : "1");
        }
    }
}