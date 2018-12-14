public class paramDummy {

    public String ids {
        get {
            if (ids == null) {
                ids = ApexPages.currentPage().getParameters().get('ids');
                //if (s != null) {
                    //ids = s.split(',');
                //} else {
                    //ids = new String[] {};
                //}
            }
            return ids;
        }
        private set;
    }
    
    public paramDummy() {
    }
}