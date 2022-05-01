#include "ShellHelpers.h"
#include <string>
#include <iostream>
#include <filesystem>
#include "VerbHelpers.h"
#include "RegisterExtension.h"
#include <strsafe.h>
#include <new>  // std::nothrow
#include <sstream>
#include <vector>
#include <iostream>
#include <wchar.h>
#include <utility>

WCHAR const c_szVerbDisplayName[] = L"ExecuteCommand Verb Sample";

class __declspec(uuid("ffa07888-75bd-471a-b325-59274e73227f")) //change
    CExecuteCommandVerb : public IExecuteCommand,
                          public IObjectWithSelection,
                          public IInitializeCommand,
                          public IObjectWithSite,
                          CAppMessageLoop
{
public:
    LPCWSTR concatted;
    HRESULT Run();

    // IUnknown
    IFACEMETHODIMP QueryInterface(REFIID riid, void **ppv)
    {
        static const QITAB qit[] =
        {
            QITABENT(CExecuteCommandVerb, IExecuteCommand),        // required
            QITABENT(CExecuteCommandVerb, IObjectWithSelection),   // required
            QITABENT(CExecuteCommandVerb, IInitializeCommand),     // optional
            QITABENT(CExecuteCommandVerb, IObjectWithSite),        // optional
            { 0 },
        };
        return QISearch(this, qit, riid, ppv);
    }

    IFACEMETHODIMP_(ULONG) AddRef()
    {
        return InterlockedIncrement(&_cRef);
    }
   IFACEMETHODIMP_(ULONG) Release()
    {
        long cRef = InterlockedDecrement(&_cRef);
        if (!cRef)
        {
            delete this;
        }
        return cRef;
    }

    // IExecuteCommand
    IFACEMETHODIMP SetKeyState(DWORD grfKeyState)
    {
        _grfKeyState = grfKeyState;
        return S_OK;
    }

    IFACEMETHODIMP SetParameters(PCWSTR /* pszParameters */)
    { return S_OK; }

    IFACEMETHODIMP SetPosition(POINT pt)
    {
        _pt = pt;
        return S_OK;
    }

    IFACEMETHODIMP SetShowWindow(int nShow)
    {
        _nShow = nShow;
        return S_OK;
    }

    IFACEMETHODIMP SetNoShowUI(BOOL /* fNoShowUI */)
    { return S_OK; }

    IFACEMETHODIMP SetDirectory(PCWSTR /* pszDirectory */)
    { return S_OK; }

    IFACEMETHODIMP Execute();

    // IObjectWithSelection
    IFACEMETHODIMP SetSelection(IShellItemArray *psia)
    {
        SetInterface(&_psia, psia);
        return S_OK;
    }

    IFACEMETHODIMP GetSelection(REFIID riid, void **ppv)
    {
        *ppv = NULL;
        return _psia ? _psia->QueryInterface(riid, ppv) : E_FAIL;
    }

    // IInitializeCommand
    IFACEMETHODIMP Initialize(PCWSTR /* pszCommandName */, IPropertyBag * /* ppb */)
    {
        return S_OK;
    }

    // IObjectWithSite
    IFACEMETHODIMP SetSite(IUnknown *punkSite)
    {
        SetInterface(&_punkSite, punkSite);
        return S_OK;
    }

    IFACEMETHODIMP GetSite(REFIID riid, void **ppv)
    {
        *ppv = NULL;
        return _punkSite ? _punkSite->QueryInterface(riid, ppv) : E_FAIL;
    }

    void OnAppCallback()
    {
        using namespace std;
        DWORD count;
        _psia->GetCount(&count);
        IShellItem2* psi;
        GetItemAt(  _psia, count - 1, IID_PPV_ARGS(&psi));
            for (UINT i = 0; i < (count); i++) { 
                LPWSTR pszN;
                IShellItem2* psis;
                GetItemAt(  _psia, i, IID_PPV_ARGS(&psis));
                psis->GetDisplayName(SIGDN_FILESYSPATH, &pszN);
                if (pszN) {
                    if (i == 0) {
                        std::wstring mywstring(pszN);
                        if (count == 1) {
                            std::wstring concatted_stdstr = L"\"" + mywstring + L"\""; 
                            concatted =  concatted_stdstr.c_str();
                        } else {
                            std::wstring concatted_stdstr = L"\"" + mywstring ;
                            concatted =  concatted_stdstr.c_str();
                        }
                    } else {
                        std::wstring   mywstring(concatted);
                        std::wstring mywwwstring(pszN);
                        if (i == count) {
                            std::wstring concatted_stdstr = mywstring + L"\"" + L" \"" + mywwwstring + L"\""; 
                            concatted =  concatted_stdstr.c_str();
                        } else {
                            std::wstring concatted_stdstr = mywstring + L"\"" + L" \"" + mywwwstring; 
                            concatted =  concatted_stdstr.c_str();
                        }
                    }
                }
                psis->Release();
                CoTaskMemFree(pszN);
            }  
        psi->Release();
    }

private:
    ~CExecuteCommandVerb()
    {
        LPCWSTR Sclipt = (LPCWSTR)L"C:\\Script\\AHK\\z_ConTxt\\manyargumentswithbill.ahk";
        WCHAR szMsg[256];
        StringCchPrintf(szMsg, ARRAYSIZE(szMsg), concatted);
        //MessageBox(NULL, (LPCWSTR)szMsg, c_szVerbDisplayName, MB_OK | MB_SETFOREGROUND);
        ShellExecuteW(NULL, NULL, (LPCWSTR)Sclipt, (LPCWSTR)szMsg, NULL, NULL); //
        CoTaskMemFree(&Sclipt);
        SafeRelease(&_psia);
        SafeRelease(&_punkSite);
    }

    long _cRef;
    IShellItemArray *_psia;
    IUnknown *_punkSite;
    HWND _hwnd;
    POINT _pt;
    int _nShow;
    DWORD _grfKeyState;
};

// this is called to invoke verb but must not block the caller. to accomidate that
// this function captures the state it needs to invoke the verb and queues a callback via
// the message queue. if your application has a message queue of its own this can be accomilished
// using PostMessage() or setting a timer of zero seconds

IFACEMETHODIMP CExecuteCommandVerb::Execute()
{
    // capture state from the site needed to invoke the verb here
    // note the HWND can be retrieved here but it should not be used for modal UI as
    // all shell verbs should be modeless as well as not block the caller
    IUnknown_GetWindow(_punkSite, &_hwnd);

    // queue the execution of the verb via the message pump
    QueueAppCallback();

    return S_OK;
}

HRESULT CExecuteCommandVerb::Run()
{
    CStaticClassFactory<CExecuteCommandVerb> classFactory(static_cast<IObjectWithSite*>(this));

    HRESULT hr = classFactory.Register(CLSCTX_LOCAL_SERVER, REGCLS_SINGLEUSE);
    if (SUCCEEDED(hr)) {
        MessageLoop();
    }
    return S_OK;
}

int APIENTRY wWinMain(HINSTANCE, HINSTANCE, PWSTR pszCmdLine, int)
{
    HRESULT hr = CoInitializeEx(NULL, COINIT_APARTMENTTHREADED | COINIT_DISABLE_OLE1DDE);
    if (SUCCEEDED(hr))
    {
        DisableComExceptionHandling();
        if (StrStrI(pszCmdLine, L"-Embedding")) {
            CExecuteCommandVerb *pAppDrop = new (std::nothrow) CExecuteCommandVerb();
            if (pAppDrop) {
                pAppDrop->Run();
                pAppDrop->Release();
            }
        }
        else
        {
            CRegisterExtension re(__uuidof(CExecuteCommandVerb));
            hr = re.RegisterAppAsLocalServer(c_szVerbDisplayName);
            if (SUCCEEDED(hr))
            {
                WCHAR const c_szProgID[] = L"txtfile";
                WCHAR const c_szVerbName[] = L"ExecuteCommandVerb";
                // register verb on .txt files ProgID
                hr = re.RegisterExecuteCommandVerb(c_szProgID, c_szVerbName, c_szVerbDisplayName);
                if (SUCCEEDED(hr))
                {
                    hr = re.RegisterVerbAttribute(c_szProgID, c_szVerbName, L"NeverDefault");
                    if (SUCCEEDED(hr))
                    {
                        MessageBox(NULL,
                            L"Installed ShellExecuteSendFileNames2Ahk for .txt files\n\n"
                            L"change under root classes in regedit to taste",
                            c_szVerbDisplayName, MB_OK);
                    }
                }
            }
        }
        CoUninitialize();
    }
    return 0;
}
