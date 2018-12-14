public class LayoutItemWrapper {
    private Metadata.LayoutItem mLayoutItem  {get; set;}

    public String field {
        get {
            return mLayoutItem.field;
        }
    }
    public String customLink {
        get {
            return mLayoutItem.customLink;
        }
    }
    public Boolean isEditable {
        get {
            return mLayoutItem.behavior != Metadata.UiBehavior.Readonly ;
        }
    }
    public Boolean isRequirable {
        get {
            return mLayoutItem.behavior == Metadata.UiBehavior.Required;
        }
    }

    public Boolean isEmptySpace {
        get {
            return mLayoutItem.emptySpace;
        }
    }

    public Boolean isCustomLink {
        get {
            return mLayoutItem.customLink != null;
        }
    }

    public Boolean isAddress {
        get {
            return mLayoutItem.field.endsWith('Address');
        }
    }

    private LayoutItemWrapper(Metadata.LayoutItem mLayoutItem) {
        system.debug(mLayoutItem);
        this.mLayoutItem = mLayoutItem;
    }

    public static LayoutItemWrapper getLayoutItemWrapper(Metadata.LayoutItem mLayoutItem) {
        return new LayoutItemWrapper(mLayoutItem);
    }

    public static List<LayoutItemWrapper> getLayoutItemWrapper(List<Metadata.LayoutItem> mLayoutItems) {
        List<LayoutItemWrapper> retVal = new List<LayoutItemWrapper>();
        for(Metadata.LayoutItem li : mLayoutItems) {
            retVal.add(new LayoutItemWrapper(li));
        }

        return retVal;
    }
}