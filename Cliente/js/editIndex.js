function start(){

    var texto = document.getElementById("txtA1").value;
    var texto2 = document.getElementById("txtA2").value;
    console.log(texto);

    var url='http://localhost:8080/Analizar/';

   

    $.post(url,{text:texto, text2:texto2},function(data,status){
        if(status.toString()=="success"){
            alert("El resultado es: "+data.toString());
            $('#jstree-tree').jstree("destroy");
            arbol(data);
        }else{
            alert("Error estado de conexion:"+status);
        }
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
