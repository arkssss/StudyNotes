# Java Runtime 类

这个类 可以直接在 java 程序里面进行 系统命令调用 e.g.

~~~java
try {

/*
	Java 调用 py 文件
*/
InputStream ip =  Runtime.getRuntime().exec ("python3test.py").getInputStream();

    byte[] buffer = new byte[1024];
    int len = 0;


    while ( (len = ip.read(buffer)) != -1) {

        System.out.println(new String(buffer, 0, len));

    }



}catch (IOException e){

}

~~~

