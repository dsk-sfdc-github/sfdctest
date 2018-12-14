public with sharing class Target {
    public String[] ids {
        get {
            if (ids == null) {
                String s = ApexPages.currentPage().getParameters().get('ids');
                if (s != null) {
                    ids = s.split(',');
                } else {
                    ids = new String[] {};
                }
            }
            return ids;
        }
        private set;
    }
}