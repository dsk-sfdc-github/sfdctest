public class LayoutWrapper {
     private Metadata.Layout mLayout{get; set;}
     public List<LayoutSectionWrapper> sections{get; private set;}
     public List<String> fieldNames {
         get {
             List<String> retVal = new List<String>();
             for(LayoutSectionWrapper s : sections) {
                 for(LayoutItemWrapper i : s.items) {
                     if(i.field != null) {
                         retVal.add(i.field);
                     }
                 }
             }
             return retVal;
         }
     }

     public LayoutWrapper(Metadata.Layout mLayout) {
         this.mLayout = mLayout;
         this.sections = LayoutSectionWrapper.getLayoutSectionWrapper(mLayout.layoutSections);
     }
}