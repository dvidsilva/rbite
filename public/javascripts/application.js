// Put your application scripts here
// #angular code to control the world

function answersCtrl($scope,$http ){
    $scope.answers = answers;
    $scope.person = person;
    $scope.send = function(){
        $.ajaxSetup({ 'beforeSend': function(xhr) {xhr.setRequestHeader("Accept", "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8")} });
        $.post('http://'+BASE_URL+'/complete/', 'a='+JSON.stringify($scope.answers)+'&p='+JSON.stringify($scope.person)+'&complete=complete', function(data){
                  if(data.status == 200){
                      
                  }
                  $('.tabbable').html("<div class='span8 offset2'><h3>Gracias</h3><p>"+message+"</p></div>");

                });
    }

    
    for (var i in $scope.answers.answers ) {
        if($scope.answers.answers[i].option_id == ''){
            $scope.answers.answers[i].option_id = $("[name='"+i+"'] option:last-child").attr('value');
            console.log( $("[name='"+i+"'] option:last-child").attr('value') ); 
        }
    }
}


function store(){
  $scp = angular.element('input').scope();
  $.post('http://'+BASE_URL+'/complete/', 'a='+JSON.stringify($scp.answers)+'&p='+JSON.stringify($scp.person)+'', function(data){});
};
