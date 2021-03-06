//забор данных о сущности из адреса страницы
var hereIsEntity = function () {
  var urlParsed = window.location.pathname.split('/');
  var entity;
  var x;
  for (x=0; x < urlParsed.length; x++ ){
      if (urlParsed[x] === 'books'){
          entity = urlParsed[x];
      } else if (urlParsed[x] === 'movies'){
          entity = urlParsed[x];
      } else if (urlParsed[x] === 'edit'){
          entity = urlParsed[x];
      } else {
        entity = 'user'
      }
  }
//  if (entity) alert(entity + ' from function');
  return entity;
};
//меняем фавикон в зависимости от адреса странички
//и прячем ввод лишней сущности
window.onload = function(){
  if (hereIsEntity() == 'movies'){
    $('#favicon').attr("href","/img/2-clapper.png");
    $('#showMovies').slideDown(1000);
    $('#booksButton').addClass('inactive');
  } else if (hereIsEntity() == 'books'){
    $('#favicon').attr("href","/img/2-book.png");
    $('#showBooks').slideDown(1000);
    $('#moviesButton').addClass('inactive');
  } else if (hereIsEntity() == 'edit'){
    $('#favicon').attr("href","/img/edit.png");
  } else {
    $('#favicon').attr("href","/img/user.png");
  }
};
//конец (забор данных о сущности из адреса страницы)

//видимость блока ввода при регистрации
$(document).ready(function(){
  $("#signUp").click(function(){
    $("#Registering").show();
  });
});
//конец (видимость блока ввода при регистрации)

//форма при смене имени+пароля
$(document).ready(function(){
  $('#userInfoChangeTrigger').click(function(){
    $('#userInfoChange').slideToggle();
  })
});
//конец(форма при смене имени+пароля)

//alert("test message");

//прячем читанные+смотренные
function hideSpented(){
  $('.hideSpentedIs-true').hide('fast');
  $('#hideSpented').addClass('selected');
  $('#showSpented').removeClass('selected');
};
function showSpented(){
  $('.hideSpentedIs-true').show('fast');
  $('#showSpented').addClass('selected');
  $('#hideSpented').removeClass('selected');
};
//end of прячем читанные+смотренные

//angular definitions
angular.module('listOrderApplication',[])
.controller('listOrderController',['$scope', function($scope){
  let items = [];

  $scope.propertyName='created_at';
  $scope.reverse=true;
  $scope.items=items;

  $scope.sortBy = function(propertyName){
    $scope.reverse = ($scope.propertyName === propertyName) ? !$scope.reverse : false;
    $scope.propertyName = propertyName;
  };
}]);
//end of angular definitions
