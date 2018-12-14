public with sharing class ApexMetadataLayoutSampleController {
    public LayoutWrapper layout {get; private set;}

    public ApexMetadataLayoutSampleController(ApexPages.StandardController stdController){
        String layoutName = EncodingUtil.urlDecode(ApexPages.currentPage().getParameters().get('lyt'), 'UTF-8');

        List<String> layoutNames = new List<String> {layoutName};
        List<Metadata.Metadata> layouts
          = Metadata.Operations.retrieve(Metadata.MetadataType.Layout, layoutNames );

        if(!layouts.isEmpty()) {
            this.layout = new LayoutWrapper((Metadata.Layout)layouts[0]);

            //stdController.addFields(this.layout.fields);
            stdController.addFields(this.layout.fieldNames);
        }

    }
}