#include <iostream>
#include <mutex>
#include <condition_variable>
#include "UFX/tool.h"
#include "UFX/t2sdk_interface.h"

#define  MSGCENTER_FUNC_HEART		 620000                                           //��Ϣ�����������ܺ�
#define  MSGCENTER_FUNC_REG			 620001                                           //��Ϣ���Ķ��Ĺ��ܺ�
#define  MSGCENTER_FUNC_REG_CANCLE   620002                                           //��Ϣ����ȡ�����Ĺ��ܺ�
#define  MSGCENTER_FUNC_SENDED		 620003                                           //��Ϣ�������ƹ��ܺ�
#define ISSUE_TYPE_REALTIME_SECU     12                                               //����֤ȯ�ɽ��ر�
#define ISSUE_TYPE_ENTR_BACK         23                                               //����ί�лر�


class semaphore
{
public:
    semaphore(int value = 1) :count(value) {}

    void wait()
    {
        unique_lock<mutex> lck(mt);
        if (--count < 0)//��Դ��������߳�
            cv.wait(lck);
    }

    void signal()
    {
        unique_lock<mutex> lck(mt);
        if (++count <= 0)//���̹߳��𣬻���һ��
            cv.notify_one();
    }

private:
    int count;
    mutex mt;
    condition_variable cv;
};

semaphore _semaphore(0);

// �Զ�����CCallback��ͨ���̳У�ʵ�֣�CCallbackInterface�����Զ�������¼����������ӳɹ���
// ���ӶϿ���������ɡ��յ����ݵȣ�����ʱ�Ļص�����
class CCallback : public CCallbackInterface
{
public:
    CCallback()
    {
        lpConfig = NULL;
        lpConnection = NULL;
//        callback.SetRequestMode(this);
        lpConfig = NewConfig();
        lpConfig->AddRef();
        memset(m_opUserToken,0,sizeof(m_opUserToken));
        m_BranchNo=0;
        memset(m_client_id,0,sizeof(m_client_id));
        iSystemNo=0;
        m_op_branch_no=0;
        memset(m_AccountName,0,sizeof(m_AccountName));
        memset(m_Password,0,sizeof(m_Password));
        memset(pout,0,sizeof(pout));
        m_EntrustWay='\0';
        m_FuturesAccount="0";
        m_opStation="0";
    }

    ~CCallback()
    {
        lpConnection->Release();
        lpConfig->Release();
    }

    // ��ΪCCallbackInterface�����մ��������IKnown��������Ҫʵ��һ����3������
    unsigned long  FUNCTION_CALL_MODE QueryInterface(const char *iid, IKnown **ppv)
    {
        return 0;
    }
    unsigned long  FUNCTION_CALL_MODE AddRef()
    {
        return 0;
    }

    unsigned long  FUNCTION_CALL_MODE Release()
    {
        return 0;
    }

    // �����¼�����ʱ�Ļص�������ʵ��ʹ��ʱ���Ը�����Ҫ��ѡ��ʵ�֣����ڲ���Ҫ���¼��ص���������ֱ��return
    // Reserved?Ϊ����������Ϊ�Ժ���չ��׼����ʵ��ʱ��ֱ��return��return 0��
    void FUNCTION_CALL_MODE OnConnect(CConnectionInterface *lpConnection)
    {
        puts("CCallback::OnConnect");
    }

    void FUNCTION_CALL_MODE OnSafeConnect(CConnectionInterface *lpConnection)
    {
        puts("CCallback::OnSafeConnect");
    }

    void FUNCTION_CALL_MODE OnRegister(CConnectionInterface *lpConnection)
    {
        puts("CCallback::OnRegister");
    }

    // �Ͽ����Ӻ�����Onclose��������ʾ���ӶϿ�
    void FUNCTION_CALL_MODE OnClose(CConnectionInterface *lpConnection)
    {
        puts("CCallback::OnClose");
    }

    void FUNCTION_CALL_MODE OnSent(CConnectionInterface *lpConnection, int hSend, void *reserved1, void *reserved2, int nQueuingData)
    {
        puts("CCallback::OnSent");
    }

    void FUNCTION_CALL_MODE Reserved1(void *a, void *b, void *c, void *d)
    {
        puts("CCallback::Reserved1");
    }
    void FUNCTION_CALL_MODE Reserved2(void *a, void *b, void *c, void *d)
    {
        puts("CCallback::Reserved2");
    }
    int  FUNCTION_CALL_MODE Reserved3()
    {
        return 0;
    }
    void FUNCTION_CALL_MODE Reserved4() {}
    void FUNCTION_CALL_MODE Reserved5() {}
    void FUNCTION_CALL_MODE Reserved6() {}
    void FUNCTION_CALL_MODE Reserved7() {}

    void FUNCTION_CALL_MODE OnReceivedBiz(CConnectionInterface *lpConnection, int hSend, const void *lpUnPackerOrStr, int nResult) {}
    void FUNCTION_CALL_MODE OnReceivedBizEx(CConnectionInterface *lpConnection, int hSend, LPRET_DATA lpRetData, const void *lpUnpackerOrStr, int nResult)
    {
        puts("CCallback::OnReceivedBizEx");
    }

    // �첽���ܵ��ú����������첽���Ͱ�������߳̽��ܷ��ذ�
    void FUNCTION_CALL_MODE OnReceivedBizMsg(CConnectionInterface *lpConnection, int hSend, IBizMessage* lpMsg)
    {
        puts("CCallback::OnReceivedBizMsg");
        if (lpMsg!=NULL)
        {
            // �ɹ�,Ӧ�ó������ͷ�lpBizMessageRecv��Ϣ
            if (lpMsg->GetReturnCode() ==0)
            {
                // ���Ҫ����Ϣ�ŵ������̴߳����������п������������£�
                // int iMsgLen = 0;
                // void * lpMsgBuffer = lpBizMessageRecv->GetBuff(iMsgLen);
                // ��lpMsgBuffer�����ߣ�Ȼ���������߳��лָ�����Ϣ�ɽ������²�����
                // lpBizMessageRecv->SetBuff(lpMsgBuffer,iMsgLen);
                // û�д�����Ϣ
                int iLen = 0;
                const void * lpBuffer = lpMsg->GetContent(iLen);
                IF2UnPacker * lpUnPacker = NewUnPacker((void *)lpBuffer,iLen);
                switch(lpMsg->GetFunction())
                {
                    case 331100:
                        if (lpUnPacker){
                            lpUnPacker->AddRef();
                            ShowPacket(lpUnPacker);
                            OnResponse_331100(lpUnPacker);
                            lpUnPacker->Release();
                            _semaphore.signal();
                        }
                        break;
                    case 333104:
                        if (lpUnPacker){
                            lpUnPacker->AddRef();
                            OnResponse_333104(lpUnPacker);
                            lpUnPacker->Release();
                        }
                        break;
                    case MSGCENTER_FUNC_HEART:
                    {
                        if (lpMsg->GetPacketType() == REQUEST_PACKET)
                            cout << "heartBeat.." << endl;
                        OnHeartbeat(lpMsg);
                        break;
                    }
                    case MSGCENTER_FUNC_REG:
                    {
                        int iLen_ley = 0;
                        const void * lpBuffer_key = lpMsg->GetKeyInfo(iLen_ley);
                        IF2UnPacker * lpUnPacker_key = NewUnPacker((void *)lpBuffer_key, iLen_ley);
                        if (lpUnPacker_key){
                            lpUnPacker_key->AddRef();
                            if (lpUnPacker_key->GetInt("error_no") != 0){
                                puts(lpUnPacker_key->GetStr("error_info"));
                                lpUnPacker_key->Release();
                            } else {
                                if (lpMsg->GetIssueType() == ISSUE_TYPE_REALTIME_SECU) {
                                    puts("���ĳɽ����Ƴɹ�...");
                                } else if (lpMsg->GetIssueType() == ISSUE_TYPE_ENTR_BACK) {
                                    puts("����֤ȯί�����Ƴɹ�...");
                                } else {
                                    puts("���ĳɹ�...");
                                }
                                ShowPacket(lpUnPacker_key);
                                lpUnPacker_key->Release();
                            }
                        }
                        _semaphore.signal();
                        break;
                    }
                    case MSGCENTER_FUNC_REG_CANCLE:
                    {
                        int iLen_ley = 0;
                        const void * lpBuffer_key = lpMsg->GetKeyInfo(iLen_ley);
                        IF2UnPacker * lpUnPacker_key = NewUnPacker((void *)lpBuffer_key, iLen_ley);
                        if (lpUnPacker_key){
                            lpUnPacker_key->AddRef();
                            if (lpUnPacker_key->GetInt("error_no") != 0){
                                puts(lpUnPacker_key->GetStr("error_info"));
                                lpUnPacker_key->Release();
                            } else {
                                if (lpMsg->GetIssueType() == ISSUE_TYPE_REALTIME_SECU) {
                                    puts("ȡ�����ĳɽ����Ƴɹ�...");
                                } else if (lpMsg->GetIssueType() == ISSUE_TYPE_ENTR_BACK) {
                                    puts("ȡ������֤ȯί�����Ƴɹ�...");
                                } else {
                                    puts("ȡ�����ĳɹ�...");
                                }
                                ShowPacket(lpUnPacker_key);
                                lpUnPacker_key->Release();
                            }
                        }
                        _semaphore.signal();
                        break;
                    }
                    case MSGCENTER_FUNC_SENDED:
                    {
                        int iLen_ley = 0;
                        const void * lpBuffer_key = lpMsg->GetKeyInfo(iLen_ley);
                        IF2UnPacker * lpUnPacker_key = NewUnPacker((void *)lpBuffer_key, iLen_ley);
                        if (lpUnPacker_key) {
                            lpUnPacker_key->AddRef();
                            if (lpMsg->GetIssueType() == ISSUE_TYPE_REALTIME_SECU) {
                                printf("����ϢΪ֤ȯ�ɽ�������Ϣ��\n");
                                ShowPacket(lpUnPacker_key);
                                lpUnPacker_key->Release();
                            }
                            if (lpMsg->GetIssueType() == ISSUE_TYPE_ENTR_BACK) {
                                printf("����ϢΪ֤ȯί��������Ϣ��\n");
                                ShowPacket(lpUnPacker_key);
                                lpUnPacker_key->Release();
                            }
                        }
                        break;
                    }
                    default:
                        if (lpUnPacker){
                            lpUnPacker->AddRef();
                            ShowPacket(lpUnPacker);
                            lpUnPacker->Release();
                            _semaphore.signal();
                        }
                        break;
                }
            }
            else
            {
                int iLen = 0;
                const void * lpBuffer = lpMsg->GetContent(iLen);
                IF2UnPacker * lpUnPacker = NewUnPacker((void *)lpBuffer, iLen);
                if (lpUnPacker != NULL)
                {
                    lpUnPacker->AddRef();//����ͷ��ڴ�����
                    ShowPacket(lpUnPacker);
                    lpUnPacker->Release();
                }
                else
                {
                    printf("ҵ����ǿհ���������룺%d��������Ϣ:%s\n", lpMsg->GetErrorNo(), lpMsg->GetErrorInfo());
                }
                _semaphore.signal();
            }
        }
    }
    //int FUNCTION_CALL_MODE EncodeEx(const char *pIn, char *pOut);
public:
    char m_opUserToken[512];
    int m_BranchNo;
    char m_client_id[18];
    int iSystemNo;
    int m_op_branch_no;

    //ά������
    void OnHeartbeat(IBizMessage* lpMsg)
    {
        lpMsg->ChangeReq2AnsMessage();
        lpConnection->SendBizMsg(lpMsg, 1);
    return;
    }

    // 331100 ������Ӧ
    void OnResponse_331100(IF2UnPacker *lpUnPacker)
    {
        int iSystemNo=-1;
        puts("CCallback::331100 �����첽Ӧ��");
        const char *pClientId = lpUnPacker->GetStr("client_id");
        if(pClientId)
        {
            strcpy(m_client_id, pClientId);
        }
        cout << "clientId:" << m_client_id << endl;
        if(lpUnPacker->GetStr("user_token") != NULL)
        {
            strcpy(m_opUserToken , lpUnPacker->GetStr("user_token"));
        }
        cout<<"UserToken:" << m_opUserToken <<endl;
        if(lpUnPacker->GetStr("branch_no") != NULL)
        {
            m_BranchNo = lpUnPacker->GetInt("branch_no");
        }
        iSystemNo = lpUnPacker->GetInt("sysnode_id");
        cout<<"iSystemNo:" << iSystemNo <<endl;
        if (lpUnPacker->GetInt("op_branch_no")!=NULL)
        {
            m_op_branch_no=lpUnPacker->GetInt("op_branch_no");
        }
        cout<<"op_branch_no:" << m_op_branch_no <<endl;
        return;
    }

    // 333104 ֤ȯ�ֲַ�ҳ��ѯ
    void OnResponse_333104(IF2UnPacker *lpUnPacker)
    {
        puts("CCallback::333104 ֤ȯ�ֲַ�ҳ");
        if (lpUnPacker->GetInt("error_no") != 0)
        {
            cout<< lpUnPacker->GetStr("error_info") <<endl;
            return;
        }
        else
        {
            // ȡ������ݼ�¼����
            int ct = lpUnPacker->GetRowCount();
            string pos = "";
            // �ж��Ƿ�Ϊ��β
            while (!lpUnPacker->IsEOF())
            {
                // ��ȡ���һ�����ݵ�position_str����Ϊ��һ���������position_str�������������˷���
                const char* lpStrPos = lpUnPacker->GetStr("position_str");
                if (lpStrPos == 0)
                    pos = "";
                else
                    pos = lpStrPos;
                // ȡ��һ����¼
                lpUnPacker->Next();
            }

            if (pos.length() != 0)
            {
                ShowPacket(lpUnPacker);
                ReqFunction333104(pos.c_str());
            }
            else
            {
                puts("CCallback::333104 ֤ȯ�ֲַ�ҳ��ѯ����");
                _semaphore.signal();
            }
        }
        return;
    }

    int InitConn()
    {
        if (lpConfig->Load("t2sdk.ini") != 0) {
            cerr << "lpConfig load t2sdk.ini fail" << endl;
            return -1;
        }
        const char *p_fund_account = lpConfig->GetString("ufx", "fund_account", "");
        const char *p_password = lpConfig->GetString("ufx", "password", "");
        strcpy(m_AccountName,p_fund_account);
        strcpy(m_Password,p_password);
//        m_EntrustWay='7';
        lpConfig->SetString("ufx", "fund_account", p_fund_account);
        lpConfig->SetString("ufx", "password", p_password);


        const char *p_serverAddr = lpConfig->GetString("t2sdk", "servers", "");
        const char *p_license_file = lpConfig->GetString("t2sdk", "license_file", "");
        const char *p_license_pwd = lpConfig->GetString("t2sdk", "license_pwd", "");
        const char *p_login_name = lpConfig->GetString("t2sdk", "login_name", "");

        // �������Ӷ���
        lpConfig->SetString("t2sdk", "servers", p_serverAddr);
        cout<<"start checking license"<<endl;
        lpConfig->SetString("t2sdk", "license_file", p_license_file);
        lpConfig->SetString("t2sdk", "license_pwd", p_license_pwd);
        cout<<"start loading clientname"<<endl;
        lpConfig->SetString("t2sdk", "login_name", p_login_name);
        cout<<"Connect Successful"<<endl;

        //�������ar������safe_level������Ҫ�����´���
        // none�����ģ�:ֻ��Ҫ�޸�safe_ssl=none����������Ĭ��
        lpConfig->SetString("safe", "safe_level", "none");
        //lpConfig->SetString("safe", "cert_file", "c20121011.pfx");
        //lpConfig->SetString("safe", "cert_pwd", "111111");

        m_EntrustWay='7';
        int iRet = 0;
        if(lpConnection != NULL)
        {
            lpConnection->Release();
            lpConnection = NULL;
        }

        lpConnection = NewConnection(lpConfig);
        cout<< "Connected successfully" <<endl;
        lpConnection->AddRef();
        if (0 != (iRet = lpConnection->Create2BizMsg(this)))
        {
            cerr<<"��ʼ��ʧ��.iRet="<<iRet<<" msg:"<<lpConnection->GetErrorMsg(iRet)<<endl;
            return -1;
        }
        if (0 != (iRet = lpConnection->Connect(3000)))
        {
            cerr<<"����.iRet="<<iRet<<" msg:"<<lpConnection->GetErrorMsg(iRet)<<endl;
            return -1;
        }

        // 331100 ����
        ReqFunction331100();

        return 0;
    }

    // 331100 ֤ȯ�ͻ���½
    int ReqFunction331100()
    {
        int iRet=0,hSend=0, iLen=0;
        // �������
        // cout<<"password"<<m_Password<<endl;
        //EncodeEx(m_Password,pout);
        //cout<<"pout: "<<pout<<endl;
        cout<<"331100�ͻ���½������£�"<<endl;
        IBizMessage* lpBizMessage=NewBizMessage();
        lpBizMessage->AddRef();
        lpBizMessage->SetFunction(331100);
        lpBizMessage->SetSubSystemNo(1000);
        lpBizMessage->SetCompanyID(91000);
        lpBizMessage->SetPacketType(REQUEST_PACKET);

        IF2Packer *pPacker=NewPacker(2);
        if (!pPacker)
        {
            printf("ȡ�����ʧ�ܣ�\r\n");
            return -1;
        }
        pPacker->AddRef();
        pPacker->BeginPack();
        ///�����ֶ���
        pPacker->AddField("op_branch_no", 'I', 5);//������֧����
        pPacker->AddField("op_entrust_way", 'C', 1);//ί�з�ʽ
        pPacker->AddField("op_station", 'S', 255);//վ���ַ
        pPacker->AddField("branch_no", 'I', 5);
        pPacker->AddField("input_content", 'C');
        pPacker->AddField("account_content", 'S', 30);
        pPacker->AddField("content_type",'S', 6);
        pPacker->AddField("password",'S', 10);
        pPacker->AddField("password_type", 'C');
        //pPacker->AddField("asset_prop",'C');
        ///�����Ӧ���ֶ�ֵ
        pPacker->AddInt(0);
        pPacker->AddChar(m_EntrustWay);
        pPacker->AddStr(m_opStation.c_str());
        pPacker->AddInt(22);
        pPacker->AddChar('1');
        pPacker->AddStr(m_AccountName);
        pPacker->AddStr("0");
        pPacker->AddStr(m_Password);
        //pPacker->AddStr(pout);
        pPacker->AddChar('1');
        //pPacker->AddChar('0');
        ///�������
        pPacker->EndPack();

        lpBizMessage->SetContent(pPacker->GetPackBuf(),pPacker->GetPackLen());

        //��ӡ�����Ϣ
        IF2UnPacker * in_lpUnPacker = NewUnPacker(pPacker->GetPackBuf(),pPacker->GetPackLen());
        in_lpUnPacker->AddRef();
        ShowPacket(in_lpUnPacker);
        in_lpUnPacker->Release();

        //�첽ģʽ��½
//        lpConnection->SendBizMsg(lpBizMessage, 1);
//        pPacker->FreeMem(pPacker->GetPackBuf());

        /// ͬ��ģʽ��½
        hSend=lpConnection->SendBizMsg(lpBizMessage, 0);
        IBizMessage* lpBizMessageRecv = NULL;
        iRet = lpConnection->RecvBizMsg(hSend, &lpBizMessageRecv, 5000);
        const void * lpBuffer = lpBizMessageRecv->GetContent(iLen);
        IF2UnPacker * lpUnPacker = NewUnPacker((void *)lpBuffer,iLen);
        ShowPacket(lpUnPacker);

        // ��ȡ����
        const char *pClientId = lpUnPacker->GetStr("client_id");
        if(pClientId)
            strcpy(m_client_id, pClientId);
        cout << "clientId:" << m_client_id << endl;
        if(lpUnPacker->GetStr("user_token") != NULL)
        {
            strcpy(m_opUserToken , lpUnPacker->GetStr("user_token"));
        }
        cout << "UserToken:" << m_opUserToken << endl;
        if(lpUnPacker->GetStr("branch_no") != NULL)
        {
            m_BranchNo = lpUnPacker->GetInt("branch_no");
        }
        cout << "BranchNo:" << lpUnPacker->GetStr("branch_no") << endl;
        iSystemNo = lpUnPacker->GetInt("sysnode_id");
        cout << "iSystemNo:" << iSystemNo << endl;
        if (lpUnPacker->GetInt("op_branch_no")!=NULL)
        {
            m_op_branch_no=lpUnPacker->GetInt("op_branch_no");
        }
        cout <<"op_branch_no:" << m_op_branch_no << endl;
        lpUnPacker->Release();
        pPacker->FreeMem(pPacker->GetPackBuf());
        /// ͬ��ģʽ��½

        pPacker->Release();
        lpBizMessage->Release();
        return 0;
    }

    //400 ֤ȯ�����ѯ
    int ReqFunction400(char* exchange_type, char* stock_code)
    {
        cout<<"400֤ȯ�����ѯ���:"<<endl;
        IBizMessage* lpBizMessage=NewBizMessage();
        lpBizMessage->AddRef();
        lpBizMessage->SetFunction(400);
        lpBizMessage->SetPacketType(REQUEST_PACKET);
        lpBizMessage->SetSystemNo(iSystemNo);

        IF2Packer *pPacker=NewPacker(2);
        if (!pPacker)
        {
            printf("ȡ�����ʧ�ܣ�\r\n");
            return -1;
        }
        pPacker->AddRef();
        pPacker->BeginPack();
        //�����ֶ���
        pPacker->AddField("exchange_type",'S');
        pPacker->AddField("stock_code",'S');
        //�����ֶ�ֵ
        pPacker->AddStr(exchange_type);
        pPacker->AddStr(stock_code);
        pPacker->EndPack();

        lpBizMessage->SetContent(pPacker->GetPackBuf(),pPacker->GetPackLen());
        //��ӡ�����Ϣ
        IF2UnPacker * lpUnPacker = NewUnPacker(pPacker->GetPackBuf(),pPacker->GetPackLen());
        lpUnPacker->AddRef();
        ShowPacket(lpUnPacker);
        lpUnPacker->Release();

        lpConnection->SendBizMsg(lpBizMessage, 1);

        pPacker->FreeMem(pPacker->GetPackBuf());
        pPacker->Release();
        lpBizMessage->Release();
        return 0;
    }

    //333002 ��ͨί��
    int ReqFunction333002(char* exchange_type,char* stock_code, double entrust_amount,double entrust_price,char entrust_bs,char* entrust_prop)
    {
        cout<<"333002ί���������"<<endl;
        int iRet = 0, hSend = 0;
        ///��ȡ�汾Ϊ2���͵�pack�����
        IF2Packer *pPacker = NewPacker(2);
        if(!pPacker)
        {
            printf("ȡ�����ʧ��!\r\n");
            return -1;
        }
        pPacker->AddRef();

        ///��������
        //IF2UnPacker *pUnPacker = NULL;

        IBizMessage* lpBizMessage = NewBizMessage();
        lpBizMessage->AddRef();
        ///Ӧ��ҵ����Ϣ
        IBizMessage* lpBizMessageRecv = NULL;
        //���ܺ�
        lpBizMessage->SetFunction(333002);
        lpBizMessage->SetSubSystemNo(1000);
        lpBizMessage->SetCompanyID(91000);
        //��������
        lpBizMessage->SetPacketType(REQUEST_PACKET);
        //lpBizMessage->SetSystemNo(iSystemNo);
        ///������Ӧ����Ϣ
        LPRET_DATA pRetData = NULL;
        ///��ʼ���
        pPacker->BeginPack();
        ///�����ֶ���
        pPacker->AddField("op_branch_no", 'I', 5);//���� ���� ����
        pPacker->AddField("op_entrust_way", 'C', 1);
        pPacker->AddField("op_station", 'S', 255);
        pPacker->AddField("branch_no", 'I', 5);
        pPacker->AddField("client_id", 'S', 18);//�ͻ�ID
        pPacker->AddField("fund_account", 'S', 18);//�ʽ��˺�
        pPacker->AddField("password", 'S', 10);
        pPacker->AddField("password_type", 'C', 1);
        pPacker->AddField("user_token", 'S', 64);
        pPacker->AddField("exchange_type", 'S', 4);
        pPacker->AddField("stock_account", 'S', 15);
        pPacker->AddField("stock_code", 'S', 6);
        pPacker->AddField("entrust_amount", 'F', 19, 2);
        pPacker->AddField("entrust_price", 'F', 18, 3);
        pPacker->AddField("entrust_bs", 'C', 1);
        pPacker->AddField("entrust_prop", 'S', 3);
        pPacker->AddField("batch_no", 'I', 8);
        ///�����Ӧ���ֶ�ֵ
        pPacker->AddInt(m_op_branch_no);
        pPacker->AddChar(m_EntrustWay);
        pPacker->AddStr(m_opStation.c_str());
        pPacker->AddInt(m_BranchNo);
        pPacker->AddStr(m_client_id);
        pPacker->AddStr(m_AccountName);
        pPacker->AddStr(m_Password);
        pPacker->AddChar('2');
        pPacker->AddStr(m_opUserToken);
        pPacker->AddStr(exchange_type);
        pPacker->AddStr("");
        pPacker->AddStr(stock_code);
        pPacker->AddDouble(entrust_amount);
        pPacker->AddDouble(entrust_price);
        pPacker->AddChar(entrust_bs);
        pPacker->AddStr(entrust_prop);
        pPacker->AddInt(13);
        pPacker->EndPack();

        lpBizMessage->SetContent(pPacker->GetPackBuf(),pPacker->GetPackLen());
        //��ӡ�����Ϣ
        IF2UnPacker * lpUnPacker = NewUnPacker(pPacker->GetPackBuf(),pPacker->GetPackLen());
        lpUnPacker->AddRef();
        ShowPacket(lpUnPacker);
        lpUnPacker->Release();

        lpConnection->SendBizMsg(lpBizMessage, 1);
        pPacker->FreeMem(pPacker->GetPackBuf());
        pPacker->Release();
        lpBizMessage->Release();
        return 0;
    }

    //333104 ֤ȯ�ֲֲ�ѯ
    int ReqFunction333104(const char* position_str)
    {
        cout<<"333104 ֤ȯ�ֲֲ�ѯ���:"<<endl;
        IBizMessage* lpBizMessage = NewBizMessage();
        lpBizMessage->AddRef();
        IBizMessage* lpBizMessageRecv = NULL;
        // ���ܺ�
        lpBizMessage->SetFunction(333104);
        lpBizMessage->SetSubSystemNo(1000);
        lpBizMessage->SetCompanyID(91000);
        //��������
        lpBizMessage->SetPacketType(REQUEST_PACKET);
        //����ϵͳ��
        lpBizMessage->SetSystemNo(iSystemNo);

        ///��ȡ�汾Ϊ2���͵�pack�����
        IF2Packer *pPacker = NewPacker(2);
        if(!pPacker)
        {
            printf("ȡ�����ʧ��!\r\n");
            return -1;
        }
        pPacker->AddRef();
        ///��ʼ���
        pPacker->BeginPack();
        ///�����ֶ���
        pPacker->AddField("op_branch_no", 'I', 5);
        pPacker->AddField("op_entrust_way", 'C', 1);
        pPacker->AddField("op_station", 'S', 255);
        pPacker->AddField("branch_no", 'I', 5);
        pPacker->AddField("client_id", 'S', 18);
        pPacker->AddField("fund_account", 'S', 18);
        pPacker->AddField("password", 'S', 10);
        pPacker->AddField("password_type", 'C', 1);
        pPacker->AddField("user_token", 'S', 512);
        pPacker->AddField("position_str",'S',100);
        pPacker->AddField("request_num",'I',10);
        ///�����Ӧ���ֶ�ֵ
        pPacker->AddInt(0); // op_branch_no
        pPacker->AddChar('7'); //	op_entrust_way
        pPacker->AddStr("hs"); // op_station
        pPacker->AddInt(m_BranchNo); // branch_no
        pPacker->AddStr(m_client_id); // client_id
        pPacker->AddStr(m_AccountName);	// fund_account
        pPacker->AddStr(m_Password); // password
        pPacker->AddChar('1'); // password_type
        pPacker->AddStr(m_opUserToken);	// user_token
        pPacker->AddStr( position_str); // position_str ���ݵĶ�λ��
        pPacker->AddInt(3); // request_num ������;Ĭ��50�����100
        ///�������
        pPacker->EndPack();

        lpBizMessage->SetContent(pPacker->GetPackBuf(),pPacker->GetPackLen());
        lpConnection->SendBizMsg(lpBizMessage, 1);
        pPacker->FreeMem(pPacker->GetPackBuf());
        pPacker->Release();
        lpBizMessage->Release();
    }

    // 331300 ֤ȯ�ɶ���Ϣ��ѯ
    int ReqFunction331300()
    {
        cout<<"331300 ֤ȯ�ɶ���Ϣ��ѯ:"<<endl;
        cout<<"isysnum:"<<iSystemNo<<endl;
        cout<<"password:"<<m_Password<<endl;
        cout<<"fund_account:"<<m_AccountName<<endl;
        cout<<"m_opUserToken:"<<m_opUserToken<<endl;
        int hSend = 0;

        IBizMessage* lpBizMessage = NewBizMessage();
        lpBizMessage->AddRef();
        IBizMessage* lpBizMessageRecv = NULL;

        //���ܺ�
        lpBizMessage->SetFunction(331300);
        lpBizMessage->SetSubSystemNo(1000);
        lpBizMessage->SetCompanyID(91000);
        //��������
        lpBizMessage->SetPacketType(REQUEST_PACKET);
        //����Ӫҵ����
        //����ϵͳ��
        lpBizMessage->SetSystemNo(iSystemNo);

        ///��ȡ�汾Ϊ2���͵�pack�����
        IF2Packer *pPacker = NewPacker(2);
        if(!pPacker)
        {
            printf("ȡ�����ʧ��!\r\n");
            return -1;
        }
        pPacker->AddRef();
        ///��ʼ���
        pPacker->BeginPack();
        ///�����ֶ���
        pPacker->AddField("op_branch_no", 'I', 5);//���� ���� ����
        pPacker->AddField("op_entrust_way", 'C', 1);
        pPacker->AddField("op_station", 'S', 255);
        pPacker->AddField("branch_no", 'I', 5);
        pPacker->AddField("client_id", 'S', 18);
        pPacker->AddField("fund_account", 'S', 18);
        pPacker->AddField("password", 'S', 10);
        pPacker->AddField("password_type", 'C', 1);
        pPacker->AddField("user_token", 'S', 512);
        pPacker->AddField("exchange_type", 'S', 4);
        ///�����Ӧ���ֶ�ֵ
        pPacker->AddInt(0);			//op_branch_no
        pPacker->AddChar('7');			//	op_entrust_way
        pPacker->AddStr("hs");	//op_station
        pPacker->AddInt(m_BranchNo);		//	branch_no
        pPacker->AddStr(m_client_id);	//		client_id
        pPacker->AddStr(m_AccountName);	//	fund_account
        pPacker->AddStr(m_Password);		//password
        pPacker->AddChar('1');			//	password_type
        pPacker->AddStr(m_opUserToken);	//	user_token
        pPacker->AddStr("1");			//exchange_type
        ///�������
        pPacker->EndPack();

        lpBizMessage->SetContent(pPacker->GetPackBuf(),pPacker->GetPackLen());
        lpConnection->SendBizMsg(lpBizMessage, 1);

        pPacker->FreeMem(pPacker->GetPackBuf());
        pPacker->Release();
        lpBizMessage->Release();
    }

    // 333017 ֤ȯί�г���
    int ReqFunction333017(char* entrust_no)
    {
        cout<<"333017 ֤ȯί�г���:"<<endl;
        int iRet = 0, hSend = 0;
        ///��ȡ�汾Ϊ2���͵�pack�����
        IF2Packer *pPacker = NewPacker(2);
        if(!pPacker)
        {
            printf("ȡ�����ʧ��!\r\n");
            return -1;
        }
        pPacker->AddRef();
        ///��������
        //IF2UnPacker *pUnPacker = NULL;

        IBizMessage* lpBizMessage = NewBizMessage();
        lpBizMessage->AddRef();

        ///Ӧ��ҵ����Ϣ
        IBizMessage* lpBizMessageRecv = NULL;
        //���ܺ�
        lpBizMessage->SetFunction(333017);
        lpBizMessage->SetSubSystemNo(1000);
        lpBizMessage->SetCompanyID(91000);
        //��������
        lpBizMessage->SetPacketType(REQUEST_PACKET);
        lpBizMessage->SetSystemNo(iSystemNo);
        ///������Ӧ����Ϣ
        LPRET_DATA pRetData = NULL;

        ///��ʼ���
        pPacker->BeginPack();
        ///�����ֶ���
        pPacker->AddField("op_branch_no", 'I', 5);//���� ���� ����
        pPacker->AddField("op_entrust_way", 'C', 1);
        pPacker->AddField("op_station", 'S', 255);
        pPacker->AddField("branch_no", 'I', 5);
        pPacker->AddField("client_id", 'S', 18);//�ͻ�ID
        pPacker->AddField("fund_account", 'S', 18);//�ʽ��˺�
        pPacker->AddField("password", 'S', 10);
        pPacker->AddField("password_type", 'C', 1);
        pPacker->AddField("user_token", 'S', 64);
        pPacker->AddField("batch_flag", 'S', 15);
        pPacker->AddField("exchange_type", 'S', 4);
        pPacker->AddField("entrust_no", 'S', 6);//ί�б��
        ///�����Ӧ���ֶ�ֵ
        pPacker->AddInt(m_op_branch_no);
        pPacker->AddChar(m_EntrustWay);
        pPacker->AddStr(m_opStation.c_str());
        pPacker->AddInt(m_BranchNo);
        pPacker->AddStr(m_client_id);
        pPacker->AddStr(m_AccountName);
        pPacker->AddStr(m_Password);
        pPacker->AddChar('2');
        pPacker->AddStr(m_opUserToken);
        pPacker->AddStr("");
        pPacker->AddStr("");
        pPacker->AddStr(entrust_no);
        ///�������
        pPacker->EndPack();

        lpBizMessage->SetContent(pPacker->GetPackBuf(),pPacker->GetPackLen());
        lpConnection->SendBizMsg(lpBizMessage, 1);

        pPacker->FreeMem(pPacker->GetPackBuf());
        pPacker->Release();
        lpBizMessage->Release();
        return 0;
    }

    //333101֤ȯί�в�ѯ
    int ReqFunction333101()
    {
        cout<<"333101ί�в�ѯ���:"<<endl;
        int iRet = 0, hSend = 0;
        ///��ȡ�汾Ϊ2���͵�pack�����
        IF2Packer *pPacker = NewPacker(2);
        if(!pPacker)
        {
            printf("ȡ�����ʧ��!\r\n");
            return -1;
        }
        pPacker->AddRef();

        ///��������
        //IF2UnPacker *pUnPacker = NULL;

        ///����ҵ����Ϣ�ӿ�
        IBizMessage* lpBizMessage = NewBizMessage();
        lpBizMessage->AddRef();
        ///Ӧ��ҵ����Ϣ
        IBizMessage* lpBizMessageRecv = NULL;
        //���ܺ�
        lpBizMessage->SetFunction(333101);
        lpBizMessage->SetSubSystemNo(1000);
        lpBizMessage->SetCompanyID(91000);
        //��������
        lpBizMessage->SetPacketType(REQUEST_PACKET);
        lpBizMessage->SetSystemNo(iSystemNo);
        ///������Ӧ����Ϣ
        LPRET_DATA pRetData = NULL;

        ///��ʼ���
        pPacker->BeginPack();
        ///�����ֶ���
        pPacker->AddField("op_branch_no", 'I', 5);//���� ���� ����
        pPacker->AddField("op_entrust_way", 'C', 1);
        pPacker->AddField("op_station", 'S', 255);
        pPacker->AddField("branch_no", 'I', 5);
        pPacker->AddField("client_id", 'S', 18);//�ͻ�ID
        pPacker->AddField("fund_account", 'S', 18);//�ʽ��˺�
        pPacker->AddField("password", 'S', 10);
        //pPacker->AddField("password_type", 'C', 1);
        pPacker->AddField("user_token", 'S', 64);
        //pPacker->AddField("exchange_type", 'S', 4);
        //pPacker->AddField("stcok_account",'S',11);
        //pPacker->AddField("stock_code",'S',16);
        //pPacker->AddField("sort_direction",'C',1);
        //pPacker->AddField("report_no",'I',8);
        //pPacker->AddField("action_in",'I',5);
        //pPacker->AddField("locate_entrust_no",'I',8);
        //pPacker->AddField("query_type",'C',1);
        //pPacker->AddField("query_mode",'C',1);
        //pPacker->AddField("position_str",'S',100);
        pPacker->AddField("request_num",'I',10);
        //pPacker->AddField("etf_flag",'C',1);
        ///�����Ӧ���ֶ�ֵ
        pPacker->AddInt(m_op_branch_no);
        pPacker->AddChar(m_EntrustWay);
        pPacker->AddStr(m_opStation.c_str());
        pPacker->AddInt(m_BranchNo);
        pPacker->AddStr(m_client_id);
        pPacker->AddStr(m_AccountName);
        pPacker->AddStr(m_Password);
        //	pPacker->AddChar('2');
        pPacker->AddStr(m_opUserToken);
        //pPacker->AddStr("");
        //pPacker->AddStr("");
        //pPacker->AddStr("");
        //pPacker->AddChar(' ');
        //pPacker->AddInt( );
        //pPacker->AddInt( );
        //pPacker->AddInt( );
        //pPacker->AddChar(' ');
        //pPacker->AddChar(' ');
        //pPacker->AddStr("");
        pPacker->AddInt(100);
        //pPacker->AddChar(' ');
        ///�������
        pPacker->EndPack();

        ///����ҵ������
        lpBizMessage->SetContent(pPacker->GetPackBuf(),pPacker->GetPackLen());

        // ��ӡ�����Ϣ
        IF2UnPacker * lpUnPacker = NewUnPacker(pPacker->GetPackBuf(),pPacker->GetPackLen());
        lpUnPacker->AddRef();
        ShowPacket(lpUnPacker);
        lpUnPacker->Release();

        ///����ҵ������
        lpConnection->SendBizMsg(lpBizMessage, 1);
        pPacker->FreeMem(pPacker->GetPackBuf()); // �ͷŴ���ڴ�
        pPacker->Release();
        lpBizMessage->Release();
        return 0;
    }

    //333102֤ȯ�ɽ���ѯ
    int ReqFunction333102()
    {
        cout<<"333102֤ȯ�ɽ���ѯ���"<<endl;
        int iRet = 0, hSend = 0;
        ///��ȡ�汾Ϊ2���͵�pack�����
        IF2Packer *pPacker = NewPacker(2);
        if(!pPacker)
        {
            printf("ȡ�����ʧ��!\r\n");
            return -1;
        }
        pPacker->AddRef();
        ///��������
        //IF2UnPacker *pUnPacker = NULL;

        IBizMessage* lpBizMessage = NewBizMessage();
        lpBizMessage->AddRef();
        ///Ӧ��ҵ����Ϣ
        IBizMessage* lpBizMessageRecv = NULL;
        //���ܺ�
        lpBizMessage->SetFunction(333102);
        lpBizMessage->SetSubSystemNo(1000);
        lpBizMessage->SetCompanyID(91000);
        //��������
        lpBizMessage->SetPacketType(REQUEST_PACKET);
        lpBizMessage->SetSystemNo(iSystemNo);
        ///������Ӧ����Ϣ
        LPRET_DATA pRetData = NULL;

        ///��ʼ���
        pPacker->BeginPack();
        ///�����ֶ���
        pPacker->AddField("op_branch_no", 'I', 5);//���� ���� ����
        pPacker->AddField("op_entrust_way", 'C', 1);
        pPacker->AddField("op_station", 'S', 255);
        pPacker->AddField("branch_no", 'I', 5);
        pPacker->AddField("client_id", 'S', 18);//�ͻ�ID
        pPacker->AddField("fund_account", 'S', 18);//�ʽ��˺�
        pPacker->AddField("password", 'S', 10);
        pPacker->AddField("password_type", 'C', 1);
        pPacker->AddField("user_token", 'S', 64);
        //pPacker->AddField("exchange_type", 'S', 4);
        //pPacker->AddField("stcok_account",'S',11);
        //pPacker->AddField("stock_code",'S',16);
        //pPacker->AddField("serial_no",'I',8);
        //pPacker->AddField("query_direction",'C',1);
        //pPacker->AddField("report_no",'I',8);
        //pPacker->AddField("query_type",'C',1);
        //pPacker->AddField("query_mode",'C',1);
        //pPacker->AddField("position_str",'S',100);
        //pPacker->AddField("request_num",'I',10);
        //pPacker->AddField("etf_flag",'C',1);
        ///�����Ӧ���ֶ�ֵ
        pPacker->AddInt(m_op_branch_no);
        pPacker->AddChar(m_EntrustWay);
        pPacker->AddStr(m_opStation.c_str());
        pPacker->AddInt(m_BranchNo);
        pPacker->AddStr(m_client_id);
        pPacker->AddStr(m_AccountName);
        pPacker->AddStr(m_Password);
        pPacker->AddChar('2');
        pPacker->AddStr(m_opUserToken);
        //pPacker->AddStr("");
        //pPacker->AddStr("");
        //pPacker->AddStr("");
        //pPacker->AddInt();
        //pPacker->AddChar(' ');
        //pPacker->AddInt( );
        //pPacker->AddChar(' ');
        //pPacker->AddChar(' ');
        //pPacker->AddStr("");
        //pPacker->AddInt();
        //pPacker->AddChar(' ');
        pPacker->EndPack();
        lpBizMessage->SetContent(pPacker->GetPackBuf(),pPacker->GetPackLen());
        //��ӡ�����Ϣ
        IF2UnPacker * lpUnPacker = NewUnPacker(pPacker->GetPackBuf(),pPacker->GetPackLen());
        lpUnPacker->AddRef();
        ShowPacket(lpUnPacker);
        lpUnPacker->Release();

        lpConnection->SendBizMsg(lpBizMessage, 1);
        pPacker->FreeMem(pPacker->GetPackBuf());
        pPacker->Release();
        lpBizMessage->Release();
        return 0;
    }

    // 620001 ���Ļر�
    int SubFunction620001(int issue_type)
    {
        int iRet = 0, hSend = 0;
        IF2UnPacker *pMCUnPacker = NULL;
        ///��ȡ�汾Ϊ2���͵�pack�����
        IF2Packer *pPacker = NewPacker(2);
        if(!pPacker)
        {
            printf("ȡ�����ʧ��!\r\n");
            return -1;
        }
        pPacker->AddRef();

        ///��������
        //IF2UnPacker *pUnPacker = NULL;

        IBizMessage* lpBizMessage = NewBizMessage();
        lpBizMessage->AddRef();
        ///Ӧ��ҵ����Ϣ
        IBizMessage* lpBizMessageRecv = NULL;
        //���ܺ�
        lpBizMessage->SetFunction(MSGCENTER_FUNC_REG);
        if (issue_type == 12) {
            lpBizMessage->SetSequeceNo(12);
        } else if (issue_type == 23) {
            lpBizMessage->SetSequeceNo(13);
        }
        //��������
        lpBizMessage->SetPacketType(REQUEST_PACKET);

        ///��ʼ���
        pPacker->BeginPack();
        ///�����ֶ���
        pPacker->AddField("branch_no", 'I', 5);
        pPacker->AddField("fund_account", 'S', 18);
        pPacker->AddField("op_branch_no", 'I', 5);
        pPacker->AddField("op_entrust_way",'C',1);
        pPacker->AddField("op_station", 'S', 255);
        pPacker->AddField("client_id",'S',18);
        pPacker->AddField("password",'S',10);
        pPacker->AddField("user_token", 'S', 64);
        pPacker->AddField("issue_type",'I',8);
        ///�����Ӧ���ֶ�ֵ
        pPacker->AddInt(m_BranchNo);
        pPacker->AddStr(m_AccountName);
        pPacker->AddInt(m_op_branch_no);
        pPacker->AddChar(m_EntrustWay);
        pPacker->AddStr(m_opStation.c_str());	//op_station
        pPacker->AddStr(m_client_id);
        pPacker->AddStr(m_Password);
        pPacker->AddStr(m_opUserToken);
        pPacker->AddInt(issue_type);
        ///�������
        pPacker->EndPack();

        lpBizMessage->SetKeyInfo(pPacker->GetPackBuf(),pPacker->GetPackLen());
        lpConnection->SendBizMsg(lpBizMessage,1);

        pPacker->FreeMem(pPacker->GetPackBuf());
        pPacker->Release();
        lpBizMessage->Release();
    }

    // 620002 ȡ�����Ļر�
    int SubFunction620002(int issue_type)
    {
        int iRet = 0, hSend = 0;
        IF2UnPacker *pMCUnPacker = NULL;
        ///��ȡ�汾Ϊ2���͵�pack�����
        IF2Packer *pPacker = NewPacker(2);
        if (!pPacker)
        {
            printf("ȡ�����ʧ��!\r\n");
            return -1;
        }
        pPacker->AddRef();

        IBizMessage* lpBizMessage = NewBizMessage();
        lpBizMessage->AddRef();
        ///Ӧ��ҵ����Ϣ
        IBizMessage* lpBizMessageRecv = NULL;
        //���ܺ�
        lpBizMessage->SetFunction(MSGCENTER_FUNC_REG_CANCLE);
        if (issue_type == 12) {
            lpBizMessage->SetSequeceNo(14);
        } else if (issue_type == 23) {
            lpBizMessage->SetSequeceNo(15);
        }
        //��������
        lpBizMessage->SetPacketType(REQUEST_PACKET);

        ///��ʼ���
        pPacker->BeginPack();
        ///�����ֶ���
        pPacker->AddField("branch_no", 'I', 5);
        pPacker->AddField("fund_account", 'S', 18);
        pPacker->AddField("op_branch_no", 'I', 5);
        pPacker->AddField("op_entrust_way",'C',1);
        pPacker->AddField("op_station", 'S', 255);
        pPacker->AddField("client_id",'S',18);
        pPacker->AddField("password",'S',10);
        pPacker->AddField("user_token", 'S', 64);
        pPacker->AddField("issue_type",'I',8);
        ///�����Ӧ���ֶ�ֵ
        pPacker->AddInt(m_BranchNo);
        pPacker->AddStr(m_AccountName);
        pPacker->AddInt(m_op_branch_no);
        pPacker->AddChar(m_EntrustWay);
        pPacker->AddStr(m_opStation.c_str());	//op_station
        pPacker->AddStr(m_client_id);
        pPacker->AddStr(m_Password);
        pPacker->AddStr(m_opUserToken);
        pPacker->AddInt(issue_type);
        ///�������
        pPacker->EndPack();

        lpBizMessage->SetKeyInfo(pPacker->GetPackBuf(), pPacker->GetPackLen());
        lpConnection->SendBizMsg(lpBizMessage, 1);

        pPacker->FreeMem(pPacker->GetPackBuf());
        pPacker->Release();
        lpBizMessage->Release();
    }

private:
    CConfigInterface* lpConfig;
    CConnectionInterface *lpConnection;
    char pout[255];
    char m_AccountName[12];
    char m_Password[8];
    char m_EntrustWay;
    string m_FuturesAccount;
    string m_opStation;
};

int main(int argc, char* argv[])
{

    CCallback* cCallback = new CCallback();

    if (cCallback->InitConn() < 0) return -1;

    /// �첽��¼����
//    _semaphore.wait();


//     400 ֤ȯ�����ѯ
    cCallback->ReqFunction400("2", "000001");
    _semaphore.wait();

    // 333101֤ȯί�в�ѯ
//    cout << "\r\n��ѯί��" << endl;
//    cCallback->ReqFunction333101();
//    _semaphore.wait();

    // 333102 ֤ȯ�ɽ���ѯ
//    cout << "\r\n��ѯ�ɽ�" << endl;
//    cCallback->ReqFunction333102();
//    _semaphore.wait();

    // 333104 ֤ȯ�ֲֲ�ѯ
    cout << "\r\n��ѯ֤ȯ�ֲ�" << endl;
    cCallback->ReqFunction333104("");
    _semaphore.wait();

    // 331300 ֤ȯ�ɶ���Ϣ��ѯ
    cout << "\r\n��ѯ֤ȯ�ɶ���Ϣ" << endl;
    cCallback->ReqFunction331300();
    _semaphore.wait();

    // ���趩����Ϣ����,�ſ�����Ĵ��뼴��; ���ĳɹ�������Ϣ�������Ͷ��ĸ��ͻ�
    cout << "\r\n620001_12����֤ȯ�ɽ��ر�" << endl;
    cCallback->SubFunction620001(ISSUE_TYPE_REALTIME_SECU);
    _semaphore.wait();
    cout << "\r\n620001_23����֤ȯί�лر�" << endl;
    cCallback->SubFunction620001(ISSUE_TYPE_ENTR_BACK);
    _semaphore.wait();

    // ���趩����Ϣ����,�ſ�����Ĵ��뼴��; ���ĳɹ�������Ϣ�������Ͷ��ĸ��ͻ�
    cout << "\r\n620002_12����֤ȯ�ɽ��ر�" << endl;
    cCallback->SubFunction620002(ISSUE_TYPE_REALTIME_SECU);
    _semaphore.wait();
    cout << "\r\n620002_23����֤ȯί�лر�" << endl;
    cCallback->SubFunction620002(ISSUE_TYPE_ENTR_BACK);
    _semaphore.wait();

    // �����µ����������ſ�����Ĵ��뼴��
    // 333002 ��ͨί��
//    cout << "\r\n��������µ� ...";
//    getchar(); cin.get();
//    // entrust_prop: U:�����嵵��ʱ�ɽ�ʣ�೷��
//    cCallback->ReqFunction333002("2", "000001", 100, NULL, '2', "U");
//    _semaphore.wait();
//
//    cout << "\r\n��������µ� ...";
//    getchar(); cin.get();
//    // entrust_prop: 0:����
//    cCallback->ReqFunction333002("2", "000001", 100, 14, '1', "0");
//    _semaphore.wait();

    // 33017 ֤ȯί�г���
//    this_thread::sleep_for(chrono::milliseconds(1000));
//    cout << "\r\n����������� ...";
//    getchar(); cin.get();
//    cCallback->ReqFunction333017("19");
//    _semaphore.wait();

    cout << "\r\n��������˳� ..." << endl;
    getchar(); cin.get();
    delete cCallback;
    return 0;
}
