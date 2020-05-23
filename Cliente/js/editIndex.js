function start(){

    var texto = document.getElementById("txtA1").value;
    var texto2 = document.getElementById("txtA2").value;
    console.log(texto);

    var url='http://localhost:8080/Analizar/';

   

    $.post(url,{text:texto, text2:texto2},function(data,status){
        if(status.toString()=="success"){
            alert("El resultado es: "+data.uno.toString());
            $('#jstree-tree').jstree("destroy");
            arbol(data.uno);
            clasesT(data.dos);
            FuncionesT(data.tres);
            VariablesT(data.cuatro);
        }else{
            alert("Error estado de conexion:"+status);
        }
    });

}

function clasesT(y){
  console.log("Si entra");
  var table3 = document.getElementById('Table1');
            var L = 1;
            y.forEach(function (element) {
                var newRow3 = table3.insertRow(L);
                var cell12 = newRow3.insertCell(0);
                var cell22 = newRow3.insertCell(1);
                cell12.innerHTML = element[0];
                cell22.innerHTML = element[1];
                L++;
            });
}

function FuncionesT(y){
  console.log("Si entra F");
  var tableF = document.getElementById('Table2');
            var L = 1;
            y.forEach(function (element) {
                var newRowF = tableF.insertRow(L);
                var cell1F = newRowF.insertCell(0);
                var cell2F = newRowF.insertCell(1);
                var cell3F = newRowF.insertCell(2);
                var cell4F = newRowF.insertCell(3);
                cell1F.innerHTML = element[0];
                cell2F.innerHTML = element[1];
                cell3F.innerHTML = element[2];
                cell4F.innerHTML = element[3];
                L++;
            });
}

function VariablesT(y){
  console.log("Si entra V");
  var tableV = document.getElementById('Table3');
            var L = 1;
            y.forEach(function (element) {
                var newRowV = tableV.insertRow(L);
                var cell1v = newRowV.insertCell(0);
                var cell2v = newRowV.insertCell(1);
                var cell3v = newRowV.insertCell(2);
                var cell4v = newRowV.insertCell(3);
                cell1v.innerHTML = element[0];
                cell2v.innerHTML = element[1];
                cell3v.innerHTML = element[2];
                cell4v.innerHTML = element[3];
                L++;
            });
}

function arbol(x){
    var jsonData = 
        JSON.parse(x);
        ;
        
        $('#jstree-tree')
          .on('changed.jstree', function (e, data) {
            var objNode = data.instance.get_node(data.selected);
            $('#jstree-result').html('Selected: <br/><strong>' + objNode.id+'-'+objNode.text+'</strong>');
          })
          .jstree({
          core: {
            data: jsonData
          }
        });
}

