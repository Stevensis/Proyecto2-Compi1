function start(){

    var texto = document.getElementById("txtA1").value;
    console.log(texto);

    var url='http://localhost:8080/Analizar/';

    $.post(url,{text:texto},function(data,status){
        if(status.toString()=="success"){
            alert("El resultado es: "+data.toString());
        }else{
            alert("Error estado de conexion:"+status);
        }
    });
}