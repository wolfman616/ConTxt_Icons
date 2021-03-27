// IconInjector.cpp : Implementation of CIconInjector

#include "stdafx.h"
#include "IconInjector.h"
#include <string>
#include <Windows.h>
#include <Gdiplus.h>
#include <stdio.h>
#include <time.h>
#include <mmsystem.h>
#include <Mmdeviceapi.h>
#include <Endpointvolume.h>
#include <Strsafe.h>
#include <Functiondiscoverykeys_devpkey.h>

#pragma comment (lib, "gdiplus.lib")
using namespace Gdiplus;
using namespace std;
HINSTANCE hInst;								// current instance
const LPCWSTR g_szClassName = L"JamesIsGay";


IStream* CreateStreamOnResource(LPCTSTR lpName, LPCTSTR lpType);
void mute(bool b);
void SetSplashImage(HWND hwndSplash, HBITMAP hbmpSplash);
BOOL InitInstance(HINSTANCE hInstance, int nCmdShow)
{
	hInst = hInstance; // Store instance handle in our global variable
	return TRUE;
}

IStream* CreateStreamOnResource(LPCTSTR lpName, LPCTSTR lpType)

{

	// initialize return value

	IStream* ipStream = NULL;



	// find the resource

	HRSRC hrsrc = FindResource(NULL, lpName, lpType);

	if (hrsrc == NULL)

		goto Return;



	// load the resource

	DWORD dwResourceSize = SizeofResource(NULL, hrsrc);

	HGLOBAL hglbImage = LoadResource(NULL, hrsrc);

	if (hglbImage == NULL)

		goto Return;



	// lock the resource, getting a pointer to its data

	LPVOID pvSourceResourceData = LockResource(hglbImage);

	if (pvSourceResourceData == NULL)

		goto Return;



	// allocate memory to hold the resource data

	HGLOBAL hgblResourceData = GlobalAlloc(GMEM_MOVEABLE, dwResourceSize);

	if (hgblResourceData == NULL)

		goto Return;



	// get a pointer to the allocated memory

	LPVOID pvResourceData = GlobalLock(hgblResourceData);

	if (pvResourceData == NULL)

		goto FreeData;



	// copy the data from the resource to the new memory block

	CopyMemory(pvResourceData, pvSourceResourceData, dwResourceSize);

	GlobalUnlock(hgblResourceData);



	// create a stream on the HGLOBAL containing the data

	if (SUCCEEDED(CreateStreamOnHGlobal(hgblResourceData, TRUE, &ipStream)))

		goto Return;



FreeData:

	// couldn't create stream; free the memory

	GlobalFree(hgblResourceData);



Return:

	// no need to unlock or free the resource

	return ipStream;

}

void SetSplashImage(HWND hwndSplash, HBITMAP hbmpSplash)

{

	// get the size of the bitmap

	BITMAP bm;

	GetObject(hbmpSplash, sizeof(bm), &bm);

	SIZE sizeSplash = { bm.bmWidth, bm.bmHeight };



	// get the primary monitor's info

	POINT ptZero = { 0 };

	HMONITOR hmonPrimary = MonitorFromPoint(ptZero, MONITOR_DEFAULTTOPRIMARY);

	MONITORINFO monitorinfo = { 0 };

	monitorinfo.cbSize = sizeof(monitorinfo);

	GetMonitorInfo(hmonPrimary, &monitorinfo);



	// center the splash screen in the middle of the primary work area

	const RECT& rcWork = monitorinfo.rcWork;

	POINT ptOrigin;

	ptOrigin.x = rcWork.left + (rcWork.right - rcWork.left - sizeSplash.cx) / 2;

	ptOrigin.y = rcWork.top + (rcWork.bottom - rcWork.top - sizeSplash.cy) / 2;



	// create a memory DC holding the splash bitmap

	HDC hdcScreen = GetDC(NULL);

	HDC hdcMem = CreateCompatibleDC(hdcScreen);

	HBITMAP hbmpOld = (HBITMAP)SelectObject(hdcMem, hbmpSplash);



	// use the source image's alpha channel for blending

	BLENDFUNCTION blend = { 0 };

	blend.BlendOp = AC_SRC_OVER;

	blend.SourceConstantAlpha = 255;

	blend.AlphaFormat = AC_SRC_ALPHA;



	// paint the window (in the right location) with the alpha-blended bitmap

	UpdateLayeredWindow(hwndSplash, hdcScreen, &ptOrigin, &sizeSplash,

		hdcMem, &ptZero, RGB(0, 0, 0), &blend, ULW_ALPHA);

	ShowWindow(hwndSplash, SW_SHOW);

	// delete temporary objects

	SelectObject(hdcMem, hbmpOld);

	DeleteDC(hdcMem);

	ReleaseDC(NULL, hdcScreen);

}

	// CIconInjector

	HBITMAP bmpCopy = NULL;
	HBITMAP bmpCut = NULL;
	HBITMAP bmpUndo = NULL;
	HBITMAP bmpRedo = NULL;
	HBITMAP bmpSendto = NULL;
	HBITMAP bmpDelete = NULL;
	HBITMAP bmpPaste = NULL;
	HBITMAP bmplinksource = NULL;
	HBITMAP bmpshortcut = NULL;
	HBITMAP bmpRefresh = NULL;
	HBITMAP bmpOpenWith = NULL;
	HBITMAP bmpTarget = NULL;
	HBITMAP bmpCase = NULL;
	HBITMAP bmpSortBy = NULL;
	HBITMAP bmpRename = NULL;
	HBITMAP bmpProperties = NULL;
	HBITMAP bmpPlay = NULL;
	HBITMAP bmpaddwmp = NULL;
	HBITMAP bmpAttributes = NULL;
	HBITMAP bmp7zip = NULL;
	HBITMAP bmpRotateLeft = NULL;
	HBITMAP bmpRotateRight = NULL;
	HBITMAP bmpNew = NULL;
	HBITMAP bmpView = NULL;
	HBITMAP bmppath = NULL;
	HBITMAP power_rename = NULL;
	//int main() {
		//IStream* strm = CreateStreamOnResource(MAKEINTRESOURCE(IDB_BITMAP3), RT_RCDATA);
		//Bitmap* b = new Bitmap(strm, 1);
	
		
		//b->GetHBITMAP(Color::Black, &hb);
		//MessageBox(NULL, TEXT("Hello World"), TEXT("textapp"), 0); //never appears before explorer crashes
		//int WINAPI WinMain(HINSTANCE hInst, HINSTANCE hPrevInstance, LPSTR lpCmdLine, int nCmdShow);
		//bmpCopy = (HBITMAP)LoadImageA(hInst, "IDB_BITMAP3", IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE | LR_DEFAULTSIZE);
		//return 1;
	//}

		STDMETHODIMP CIconInjector::Initialize(LPCITEMIDLIST pidlFolder, LPDATAOBJECT pDataObj, HKEY hProgID) {
		// Load the images 60079		
		//bmpCopy = (HBITMAP)LoadImageA(NULL, "C:\\e.dll,60079", IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE | LR_DEFAULTSIZE);
	//	main();
		//bmpCopy = (HBITMAP)LoadImageA(hInst, "IDB_BITMAP3", IMAGE_BITMAP, 0, 0, LR_DEFAULTSIZE);
		
bmpCopy = (HBITMAP)LoadImageA(NULL, "C:\\icon\\24\\copy.bmp", IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE | LR_DEFAULTSIZE);
		bmpCut = (HBITMAP)LoadImageA(NULL, "C:\\icon\\24\\cut.bmp", IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE | LR_DEFAULTSIZE);
		bmpPaste = (HBITMAP)LoadImageA(NULL, "C:\\icon\\24\\paste.bmp", IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE | LR_DEFAULTSIZE);
		bmpSendto = (HBITMAP)LoadImageA(NULL, "C:\\icon\\24\\sendto.bmp", IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE | LR_DEFAULTSIZE);
		bmpUndo = (HBITMAP)LoadImageA(NULL, "C:\\icon\\24\\undo.bmp", IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE | LR_DEFAULTSIZE);
		bmpRedo = (HBITMAP)LoadImageA(NULL, "C:\\icon\\24\\redo.bmp", IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE | LR_DEFAULTSIZE);
		bmpDelete = (HBITMAP)LoadImageA(NULL, "C:\\icon\\24\\delete.bmp", IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE | LR_DEFAULTSIZE);
		bmplinksource = (HBITMAP)LoadImageA(NULL, "C:\\icon\\24\\picklink.bmp", IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE | LR_DEFAULTSIZE);		//pick link source shell hardlink 
		bmpshortcut = (HBITMAP)LoadImageA(NULL, "C:\\icon\\24\\shortcut.bmp", IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE | LR_DEFAULTSIZE);		//create shortcut
		bmpRefresh = (HBITMAP)LoadImageA(NULL, "C:\\icon\\24\\refresh.bmp", IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE | LR_DEFAULTSIZE);			// refresh
		bmpOpenWith = (HBITMAP)LoadImageA(NULL, "C:\\icon\\24\\openwith.bmp", IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE | LR_DEFAULTSIZE);		// Open With
		bmpTarget = (HBITMAP)LoadImageA(NULL, "C:\\icon\\24\\target.bmp", IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE | LR_DEFAULTSIZE);			// Open Folder Location	
		bmpCase = (HBITMAP)LoadImageA(NULL, "C:\\icon\\24\\case.bmp", IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE | LR_DEFAULTSIZE);				// Case Sensitivity
		bmpSortBy = (HBITMAP)LoadImageA(NULL, "C:\\icon\\24\\sortby.bmp", IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE | LR_DEFAULTSIZE);			// Sort By		
		bmpView = (HBITMAP)LoadImageA(NULL, "C:\\icon\\24\\View.bmp", IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE | LR_DEFAULTSIZE);			// View
		bmpRename = (HBITMAP)LoadImageA(NULL, "C:\\icon\\24\\rename.bmp", IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE | LR_DEFAULTSIZE);			// Rename
		bmpProperties = (HBITMAP)LoadImageA(NULL, "C:\\icon\\24\\properties.bmp", IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE | LR_DEFAULTSIZE);		// Properties	 
		bmpPlay = (HBITMAP)LoadImageA(NULL, "C:\\icon\\24\\play.bmp", IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE | LR_DEFAULTSIZE);				// Play
		bmpaddwmp = (HBITMAP)LoadImageA(NULL, "C:\\icon\\24\\addwmp.bmp", IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE | LR_DEFAULTSIZE);			// Add To Windows Media Player List
		bmpAttributes = (HBITMAP)LoadImageA(NULL, "C:\\icon\\24\\attributes.bmp", IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE | LR_DEFAULTSIZE);	// Attributes
		bmpNew = (HBITMAP)LoadImageA(NULL, "C:\\icon\\24\\New.bmp", IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE | LR_DEFAULTSIZE);	// Rotate Right
		power_rename = (HBITMAP)LoadImageA(NULL, "C:\\icon\\24\\power_rename.bmp", IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE | LR_DEFAULTSIZE);	// Rotate Rightint err = GetLastError();
		return S_OK;
	}
	STDMETHODIMP CIconInjector::QueryContextMenu(HMENU hmenu, UINT uMenuIndex, UINT uidFirst, UINT uidLast, UINT flags) {
		using namespace std;
		if (flags & CMF_DEFAULTONLY) return S_OK; // Don't do anything if it's just a double-click
		int itemsCount = GetMenuItemCount(hmenu);
		for (int i = 0; i < itemsCount; i++) { // Iterate over the menu items
			MENUITEMINFO mii;
			ZeroMemory(&mii, sizeof(mii));
			mii.cbSize = sizeof(mii);
			mii.fMask = MIIM_FTYPE | MIIM_STRING;
			mii.dwTypeData = NULL;
			BOOL ok = GetMenuItemInfo(hmenu, i, TRUE, &mii); // Get the string length
			if (mii.fType != MFT_STRING) continue;
			UINT size = (mii.cch + 1) * 2; // Allocate enough space
			LPWSTR menuTitle = (LPWSTR)malloc(size);
			mii.cch = size;
			mii.fMask = MIIM_TYPE;
			mii.dwTypeData = menuTitle;
			ok = GetMenuItemInfo(hmenu, i, TRUE, &mii); // Get the actual string data
			mii.fMask = MIIM_BITMAP;
			bool chIcon = true;
			if (wcscmp(menuTitle, L"&Copy") == 0) {
				mii.hbmpItem = bmpCopy;
			}
			else if (wcscmp(menuTitle, L"Cu&t") == 0) {
				mii.hbmpItem = bmpCut;
			}
			else if (wcscmp(menuTitle, L"&Paste") == 0) {
				mii.hbmpItem = bmpPaste;
			}
			else if (wcsstr(menuTitle, L"Se&nd to") != NULL) {
				mii.hbmpItem = bmpSendto;
			}
			else if (wcsstr(menuTitle, L"&Undo") != NULL) {
				mii.hbmpItem = bmpUndo;
			}
			else if (wcsstr(menuTitle, L"&Redo") != NULL) {
				mii.hbmpItem = bmpRedo;
			}
			else if (wcscmp(menuTitle, L"&Delete") == 0) {
				mii.hbmpItem = bmpDelete;
			}
			else if (wcscmp(menuTitle, L"Pick &Link Source") == 0) {
				mii.hbmpItem = bmplinksource;
			}
			else if (wcsstr(menuTitle, L"Pick &Link Source") != NULL) {
				mii.hbmpItem = bmplinksource;
			}
			else if (wcscmp(menuTitle, L"Create &shortcut") == 0) {
				mii.hbmpItem = bmpshortcut;
			}
			else if (wcsstr(menuTitle, L"R&efresh") != NULL) {
				mii.hbmpItem = bmpRefresh;
			}
			else if (wcscmp(menuTitle, L"Open wit&h") == 0) {
				mii.hbmpItem = bmpOpenWith;
			}
			else if (wcsstr(menuTitle, L"Open &folder location") != NULL) {
				mii.hbmpItem = bmpTarget;
			}
			else if (wcscmp(menuTitle, L"Open &folder location") == 0) {
				mii.hbmpItem = bmpTarget;
			}
			else if (wcscmp(menuTitle, L"Open file locat&ion") == 0) {
				mii.hbmpItem = bmpTarget;
			}
			else if (wcsstr(menuTitle, L"Open file locat&ion") != NULL) {
				mii.hbmpItem = bmpTarget;
			}
			else if (wcsstr(menuTitle, L"Case Sensitivity") != NULL) {
				mii.hbmpItem = bmpCase;
			}
			else if (wcscmp(menuTitle, L"Case Sensitivity") == 0) {
				mii.hbmpItem = bmpCase;
			}
			else if (wcsstr(menuTitle, L"S&ort by") != NULL) {
				mii.hbmpItem = bmpSortBy;
			}
			else if (wcsstr(menuTitle, L"&View") != NULL) {
				mii.hbmpItem = bmpView;
			}
			else if (wcscmp(menuTitle, L"Rena&me") == 0) {
				mii.hbmpItem = bmpRename;
			}
			else if (wcscmp(menuTitle, L"Pr&operties") == 0) {
				mii.hbmpItem = bmpProperties;
			}
			else if (wcsstr(menuTitle, L"Pr&operties") != NULL) {
				mii.hbmpItem = bmpProperties;
			}
			else if (wcsstr(menuTitle, L"&Play") != NULL) {
				mii.hbmpItem = bmpPlay;
			}
			else if (wcsstr(menuTitle, L"&Add to Windows Media Player list") != NULL) {
				mii.hbmpItem = bmpaddwmp;
			}
			else if (wcscmp(menuTitle, L"Attributes") == 0) {
				mii.hbmpItem = bmpAttributes;
			}
			else if (wcscmp(menuTitle, L"Ne&w") == 0) {
				mii.hbmpItem = bmpNew;
			}
			else if (wcsstr(menuTitle, L"Ne&w") != NULL) {
				mii.hbmpItem = bmpNew;
			}
			else if (wcsstr(menuTitle, L"Po&werRename") != NULL) {
				mii.hbmpItem = power_rename;
			}
			else if (wcscmp(menuTitle, L"Po&werRename") == 0) {
				mii.hbmpItem = power_rename;
			}
			else {
				chIcon = false;
			}
			if (chIcon) SetMenuItemInfo(hmenu, i, TRUE, &mii);
			free(menuTitle);
		}
		return MAKE_HRESULT(SEVERITY_SUCCESS, FACILITY_NULL, 0); // Same as S_OK (= 0) but is The Right Thing To Do [TM]
	}
	STDMETHODIMP CIconInjector::InvokeCommand(LPCMINVOKECOMMANDINFO info) {
		return S_OK;
	}
	STDMETHODIMP CIconInjector::GetCommandString(UINT_PTR, UINT, UINT*, LPSTR, UINT) {
		return S_OK;

	}
