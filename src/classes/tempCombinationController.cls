/**
 * Created by 한성진 on 2022-12-01.
 */

public with sharing class tempCombinationController {


    private List<String> listTarget = new List<String>();
    private String out = '';
    private final Set<String> setCombination = new Set<String>();
    private Integer depth = 1;

    public tempCombinationController(List<String> listTarget) {
        this.listTarget = listTarget;
        // 생성자에 매개변수로 List<String> 받음
    }

    private void printSubstrings(Integer start) {

        for (Integer i = start; i < listTarget.size(); ++i) {
            // 당연히 List의 size만큼 돌아야함.
            // nCn 에서 nC1까지 모든 조합을 합치면 2의 n승개.
            // 즉, APEX단에서 List로 조합하는게 좀 더 이뻐보이긴 한데... List가 2의 n승개만큼 나옴.
            // 따라서 문자열을 2의 n승개만큼 만들고 set에다가 넣는것이 퍼포먼쓰상 좋아보임.

            System.debug('깊이 : ' + depth + '층 진입');
            // depth ≒ 패키지를 구성하는 상품의 수

            if(depth == 1){
                out += listTarget[i];
                // depth가 1층일경우 패키지 구성요소가 1개이므로 set에 추가 안하고 다음 상품만 붙여줌.
                System.debug('조합 : ' + out);
            }else{
                out += '&' + listTarget[i];
                System.debug('조합 : ' + out);
                setCombination.add(out);
            }
            depth++;
            // 재귀 하기 전에 depth 한 층 올려줌
            printSubstrings(i + 1);
            // 진입한 재귀에서 i값이 List Size와 동일해지면 해당 depth 탈출, depth 한층 내려줌.
            depth--;

            if(depth == 1){
                out = '';
                // 1층이면 다음 상품으로 조합 시작해야하니(A로 시작하는 조합에서 B로 시작하는 조합으로) 기존 조합 날려줌.
            }else{
                out = out.substring(0, out.length() - (listTarget[i].length()+1));
                // 직전 조합에서 추가된 상품과 구분자(&) 제거
            }
        }

    }

    public Set<String> print() {
        printSubstrings(0);
        // 당근 처음부터 시작해야 하기에 맨 처음 재귀의 i값은 0
        return setCombination;
        // 모든 재귀가 끝나고 리턴
    }
}