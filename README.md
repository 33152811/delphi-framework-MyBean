#delphi-framework-MyBean

��Դ��ַ:
https://git.oschina.net/ymofen/delphi-framework-MyBean

MyBean���������ÿ�ܣ��������Ⱥ: 205486036


˵���ĵ�
http://www.cnblogs.com/DKSoft/category/608549.html
BLOG
http://www.cnblogs.com/DKSoft/category/540328.html


[MyBean����]

1.���������ò����ܣ�һ����Դ��DLL����ɶԲ���Ĺ���

2.����ͨ������ѡ��Ԥ���������ļ�����ֱ�Ӽ���DLL����ļ�

3.����ͨ������ѡ���Ƿ�ʹ��DLL����Ŀ¼����������������ʱ�Ϳ��Ը��Ǹ��²��DLL��

4.����EXE����ͨ��ע����������ʹ�ò�����ܡ�

5.����ĵ�ʵ��ģʽ�������ɿ�ܽӹܲ�����������ڡ�

6.ֻҪʵ����IInterface�����Գ�Ϊ���������ע�ᵽ��ܲ�������ϼ򵥡�

7.���Զ�ȡ�����������ļ������������н����������ü���
;����bean�����ļ�Ŀ¼(���·��(EXEĿ¼�����·��)������·��(c:\config\*.*)
;û������ʱ,ֱ�Ӽ���DLL,��DLL�л�ȡPluginID
;<none>ʱ�������κ�DLL���
beanConfigFiles=*.plug-ins,plug-ins\*.plug-ins,beanConfig\*.plug-ins

8.ʹ��json����bean������,���ü�
{
   "id":"aboutForm",
   "pluginID":"aboutForm", //�����idһ�¿��Խ��к���
   "lib":"plug-ins\\mCore.dll", //�ļ���
   "singleton":true, //�Ƿ񵥼�ģʽ
   /// ���õ�ʵ��ʱ����ע��Ҫô�����нӿ����ù����������ڣ�Ҫôʵ��IFreeObject�ӿ�
   /// ��Ҫ�ֶ��ͷ��ͷŶ���.
}

9.�����ɫ����ȫ����Դ(֧��D7 - XE6)