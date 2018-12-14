public class Cls_MultipleTest{

    public List<String> selecter {get; set;}
    
    public List<SelectOption> selectOptionList {get; set;}
    
    public Cls_MultipleTest() {
        this.selecter = new List<String>();
        this.selectOptionList = new List<SelectOption>();
        
        this.selectOptionList.add(new SelectOption('A', 'A'));
        this.selectOptionList.add(new SelectOption('B', 'B'));
        this.selectOptionList.add(new SelectOption('C', 'C'));
        this.selectOptionList.add(new SelectOption('D', 'D'));
    }

}