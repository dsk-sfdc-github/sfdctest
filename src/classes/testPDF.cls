public class testPDF {
    
    public String renderStr {get; set;}
    
    public testPDF() {
        renderStr = '';    
    }
    
    public pageReference initPage() {
        renderStr = 'pdf';
        
        return null;
    }
}