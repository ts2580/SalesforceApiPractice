/**
 * Created by 한성진 on 2022-12-01.
 */

public with sharing class tempCombinationController {
    private final String passedString;
    private String out = '';
    private final Set<String> setCombination = new Set<String>();
    private Integer depth = 1;

    public tempCombinationController(String passedString) {
        this.passedString = passedString;
    }

    private void printSubstrings(Integer start) {

        for (Integer i = start; i < passedString.length(); ++i) {
            System.debug('깊이 : ' +depth+ '층 진입');
            out += passedString.substring(i, i+1);
            System.debug('조합 : ' +out);

            if(out.length() != 1){
                setCombination.add(out);
            }

            depth++;
            printSubstrings(i + 1);
            out = out.substring(0,out.length()-1);
            depth--;
        }

    }

    public Set<String> print() {
        printSubstrings(0);
        return setCombination;
    }
}