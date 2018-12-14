public class LayoutSectionWrapper {
    private Metadata.LayoutSection mLayoutSection {get; set;}
    public List<LayoutItemWrapper> items{get; private set;}

    public String label {
        get {
            return mLayoutSection.label;
        }
    }

    public Integer columns {
        get {
            //return mLayoutSection.layoutColumns.size();
            if (mLayoutSection.style == Metadata.LayoutSectionStyle.OneColumn) {
                return 1;
            } else {
                return 2;
            }
        }
    }

    public Boolean detailHeading {
        get {
            return mLayoutSection.detailHeading;
        }
    }

    public Boolean editHeading{
        get {
            return mLayoutSection.editHeading;
        }
    }

    public Boolean isCustomLink {
        get {
            return mLayoutSection.style == Metadata.LayoutSectionStyle.CustomLinks;
        }
    }

    private List<Metadata.LayoutItem> createSingleLayoutItemList(List<Metadata.LayoutColumn> layoutColumns) {
        List<Metadata.LayoutItem> retVal = new List<Metadata.LayoutItem>();

        Integer maxSize = 0;
        for(Metadata.LayoutColumn col : layoutColumns) {
            if(col.layoutItems != null) {
                maxSize = col.layoutItems.size() > maxSize ? col.layoutItems.size() : maxSize;
            }
        }
        for(Integer i = 0; i < maxSize; i++) {
            for(Integer j = 0; j < layoutColumns.size(); j++) {
                if(layoutColumns[j].layoutItems != null && i < layoutColumns[j].layoutItems.size()) {
                    retval.add(layoutColumns[j].layoutItems.get(i));
                }
            }
        }

        return retVal;
    }

    private LayoutSectionWrapper(Metadata.LayoutSection mLayoutSection) {
        this.mLayoutSection = mLayoutSection;
        items= new  List<LayoutItemWrapper>();
        if(columns  == 1){
            system.debug('hamano_cokums_1');
            this.items= LayoutItemWrapper.getLayoutItemWrapper(mLayoutSection.layoutColumns[0].layoutItems);
        }
        else {
            system.debug('hamano_cokums_2');
            this.items= LayoutItemWrapper.getLayoutItemWrapper(createSingleLayoutItemList(mLayoutSection.layoutColumns));
        }
    }

    public static LayoutSectionWrapper getLayoutSectionWrapper(Metadata.LayoutSection mLayoutSection) {
        return new LayoutSectionWrapper(mLayoutSection);
    }

    public static List<LayoutSectionWrapper> getLayoutSectionWrapper(List<Metadata.LayoutSection> mLayoutSections) {
        List<LayoutSectionWrapper> retVal = new List<LayoutSectionWrapper>();
        for(Metadata.LayoutSection s : mLayoutSections) {
            retVal.add(new LayoutSectionWrapper(s));
        }
        return retVal;
    }


}