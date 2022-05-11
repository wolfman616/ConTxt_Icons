// IconInjector.cpp : Implementation of CIconInjector
//#include "libloaderapi.h"

#include "stdafx.h"
#include "IconInjector.h"
#include <string>
#include <Winuser.h>
#include <sstream>
#include <vector>
#include <iostream>

using namespace std;

HBITMAP SpuncFunc(HICON hbizzle) {
	ICONINFO iconinfo;
	ICONINFO iconinfo2;
	BYTE     lpXorBuf[32 * 32 * 3];
	BYTE     lpMaskBits[128];
	if ((GetIconInfo(hbizzle, &iconinfo)) && (iconinfo.hbmColor)) {
		::GetBitmapBits(iconinfo.hbmMask, sizeof(lpMaskBits), lpMaskBits);
		::GetBitmapBits(iconinfo.hbmColor, 32 * 32 * 3, lpXorBuf);
		for (int i = 0; i < 32 * 32 * 3; i += 3) {
			int r = lpXorBuf[i + 2];
			int g = lpXorBuf[i + 1];
			int b = lpXorBuf[i];
		}
		GetIconInfo(hbizzle, &iconinfo2);
		return (HBITMAP)CopyImage(iconinfo2.hbmColor, IMAGE_BITMAP, 0, 0, LR_DEFAULTSIZE | LR_CREATEDIBSECTION);
	}
}

HMODULE   HHi     = GetModuleHandleA("ContextIcons.dll");

HBITMAP	  bmpCstm = (HBITMAP)LoadImage(HHi, MAKEINTRESOURCE(IDB_BITMAP22), IMAGE_BITMAP, 0, 0, LR_DEFAULTSIZE | LR_CREATEDIBSECTION | LR_SHARED);
HBITMAP	  bmpCpy  = (HBITMAP)LoadImage(HHi, MAKEINTRESOURCE(IDB_BITMAP1),  IMAGE_BITMAP, 0, 0, LR_DEFAULTSIZE | LR_CREATEDIBSECTION | LR_SHARED);
HBITMAP	  bmpCut  = (HBITMAP)LoadImage(HHi, MAKEINTRESOURCE(IDB_BITMAP2),  IMAGE_BITMAP, 0, 0, LR_DEFAULTSIZE | LR_CREATEDIBSECTION | LR_SHARED);
HBITMAP	  bmpLNK  = (HBITMAP)LoadImage(HHi, MAKEINTRESOURCE(IDB_BITMAP11), IMAGE_BITMAP, 0, 0, LR_DEFAULTSIZE | LR_CREATEDIBSECTION | LR_SHARED);
HBITMAP	  bmpNew  = (HBITMAP)LoadImage(HHi, MAKEINTRESOURCE(IDB_BITMAP3),  IMAGE_BITMAP, 0, 0, LR_DEFAULTSIZE | LR_CREATEDIBSECTION | LR_SHARED);
HBITMAP	  bmpPath = (HBITMAP)LoadImage(HHi, MAKEINTRESOURCE(IDB_BITMAP6),  IMAGE_BITMAP, 0, 0, LR_DEFAULTSIZE | LR_CREATEDIBSECTION | LR_SHARED);
HBITMAP	  bmpProp = (HBITMAP)LoadImage(HHi, MAKEINTRESOURCE(IDB_BITMAP20), IMAGE_BITMAP, 0, 0, LR_DEFAULTSIZE | LR_CREATEDIBSECTION | LR_SHARED);
HBITMAP	  bmpRefr = (HBITMAP)LoadImage(HHi, MAKEINTRESOURCE(IDB_BITMAP9),  IMAGE_BITMAP, 0, 0, LR_DEFAULTSIZE | LR_CREATEDIBSECTION | LR_SHARED);
HBITMAP	  bmpRen  = (HBITMAP)LoadImage(HHi, MAKEINTRESOURCE(IDB_BITMAP21), IMAGE_BITMAP, 0, 0, LR_DEFAULTSIZE | LR_CREATEDIBSECTION | LR_SHARED);
HBITMAP	  bmpSkul = (HBITMAP)LoadImage(HHi, MAKEINTRESOURCE(IDB_BITMAP23), IMAGE_BITMAP, 0, 0, LR_DEFAULTSIZE | LR_CREATEDIBSECTION | LR_SHARED);
HBITMAP	  bmpSrt  = (HBITMAP)LoadImage(HHi, MAKEINTRESOURCE(IDB_BITMAP15), IMAGE_BITMAP, 0, 0, LR_DEFAULTSIZE | LR_CREATEDIBSECTION | LR_SHARED);
HBITMAP	  bmpView = (HBITMAP)LoadImage(HHi, MAKEINTRESOURCE(IDB_BITMAP17), IMAGE_BITMAP, 0, 0, LR_DEFAULTSIZE | LR_CREATEDIBSECTION | LR_SHARED);
HBITMAP	  bmpSnd3 = (HBITMAP)LoadImage(HHi, MAKEINTRESOURCE(IDB_BITMAP10), IMAGE_BITMAP, 0, 0, LR_DEFAULTSIZE | LR_CREATEDIBSECTION | LR_SHARED);
HBITMAP   HB_CreateShtCt = bmpLNK;

HICON     hiconTmp;

HBITMAP   HB_PickLink = SpuncFunc(hiconTmp = (HICON)LoadImage(HHi, MAKEINTRESOURCE(IDI_ICON32), IMAGE_ICON, 24, 24, LR_DEFAULTSIZE | LR_SHARED));
HBITMAP   HB_Paste    = SpuncFunc(hiconTmp = (HICON)LoadImage(HHi, MAKEINTRESOURCE(IDI_ICON4),  IMAGE_ICON, 24, 24, LR_DEFAULTSIZE | LR_SHARED));
HBITMAP   HB_SortBy   = SpuncFunc(hiconTmp = (HICON)LoadImage(HHi, MAKEINTRESOURCE(IDI_ICON10), IMAGE_ICON, 24, 24, LR_DEFAULTSIZE | LR_SHARED));
HBITMAP   HB_GroupBy  = SpuncFunc(hiconTmp = (HICON)LoadImage(HHi, MAKEINTRESOURCE(IDI_ICON37), IMAGE_ICON, 24, 24, LR_DEFAULTSIZE | LR_SHARED));
HBITMAP   HB_Cmd      = SpuncFunc(hiconTmp = (HICON)LoadImage(HHi, MAKEINTRESOURCE(IDI_ICON33), IMAGE_ICON, 24, 24, LR_DEFAULTSIZE | LR_SHARED));
HBITMAP   HB_Undo     = SpuncFunc(hiconTmp = (HICON)LoadImage(HHi, MAKEINTRESOURCE(IDI_ICON34), IMAGE_ICON, 24, 24, LR_DEFAULTSIZE | LR_SHARED));
HBITMAP   HB_Redo     = SpuncFunc(hiconTmp = (HICON)LoadImage(HHi, MAKEINTRESOURCE(IDI_ICON35), IMAGE_ICON, 24, 24, LR_DEFAULTSIZE | LR_SHARED));
HBITMAP   HB_Del      = SpuncFunc(hiconTmp = (HICON)LoadImage(HHi, MAKEINTRESOURCE(IDI_ICON36), IMAGE_ICON, 24, 24, LR_DEFAULTSIZE | LR_SHARED));

STDMETHODIMP CIconInjector::Initialize(LPCITEMIDLIST pidlFolder, LPDATAOBJECT pDataObj, HKEY hProgID) {
	return S_OK;
}

STDMETHODIMP CIconInjector::QueryContextMenu(HMENU hmenu, UINT uMenuIndex, UINT uidFirst, UINT uidLast, UINT flags) {
	//LPCTSTR lpszString = L"jizz";
	//COPYDATASTRUCT cds;
	//cds.dwData = 1; // can be anything
	//cds.cbData = sizeof(TCHAR) * (_tcslen(lpszString) + 1);
	//cds.lpData = (PVOID)lpszString;
	//HRESULT OK = SendMessageA((HWND)"0xb41658", WM_COPYDATA, (WPARAM)(HWND)"0xb41658",(LPARAM)(LPVOID)&cds);
	//std::stringstream ssTmp;
	//std::string Data;
	//ssTmp << OK;
	//ssTmp >> Data;
	//MessageBoxA(NULL, (LPCSTR)Data.c_str(),"cunt", MB_OK | MB_ICONHAND);

	//tagMENUINFO mi;
	//ZeroMemory(&mi, sizeof(mi));
	//mi.cbSize = sizeof(mi);
	////  | MIIM_STRING; //MIM_STYLE MIM_BACKGROUND; //MIM_APPLYTOSUBMENUS | MIIM_STRING;	
	////mi.dwStyle    = NULL;
	////mi.cyMax      = NULL;
	////mi.hbrBack    = NULL;
	////mi.dwContextHelpID = NULL;
	////mi.dwMenuData = NULL;
	//// (UINT)flags = 132132;
	//BOOL ok = GetMenuInfo(hmenu, &mi);
	//mi.fMask = MIM_BACKGROUND; // MIM_BACKGROU//mi.fMask = MIM_BACKGROUND;
	////HANDLE  hData;
	//std::stringstream ssTmp;
	//std::string Data;
	//ssTmp << mi.hbrBack;
	//ssTmp >> Data;
	//LPCSTR Data2 = Data.c_str();

	if  (flags & CMF_DEFAULTONLY)  return  S_OK;                   // Don't do anything if double-click

	int itemsCount = GetMenuItemCount(hmenu);
	
	for (int i = 0; i < itemsCount; i++) {                         // Iterate over YOUR MEN(u) items
		MENUITEMINFO mii;
		ZeroMemory( &mii, sizeof(mii));
		mii.cbSize     =    sizeof(mii);
		mii.fMask      =    MIIM_FTYPE | MIIM_STRING;
		mii.dwTypeData =  NULL;
		BOOL ok        =    GetMenuItemInfo(hmenu, i, TRUE, &mii); // Get the string length
		if (mii.fType !=    MFT_STRING) continue;
		UINT size      =    (mii.cch + 1) * 2;                     // Allocate enough space
		LPWSTR menuTitle =  (LPWSTR)malloc(size);
		mii.cch        =    size;
		mii.fMask      =    MIIM_TYPE;
		mii.dwTypeData =    menuTitle;
		ok = GetMenuItemInfo(hmenu, i, TRUE, &mii);                // Get the actual string data
		mii.fMask      =    MIIM_BITMAP;
		bool chIcon    =    true;
		if (wcscmp(menuTitle,          L"S&ort by")        == 0)
			mii.hbmpItem = bmpSrt;
		else if (wcscmp(menuTitle,     L"&View")           == 0)
			mii.hbmpItem = bmpView;
		else if (wcscmp(menuTitle,     L"&Group by")       == 0)
			mii.hbmpItem = HB_GroupBy;
		else if (wcscmp(menuTitle,     L"Cu&t")            == 0)
			mii.hbmpItem = bmpCut;
		else if (wcscmp(menuTitle,     L"&Copy")           == 0)
			mii.hbmpItem = bmpCpy;
		else if (wcsstr(menuTitle,     L"&Copy")          != NULL)
			mii.hbmpItem = bmpCpy;
		else if (wcscmp(menuTitle,     L"&Paste")          == 0)
			mii.hbmpItem = HB_Paste;
		else if (wcscmp(menuTitle,     L"Paste &shortcut") == 0)
			mii.hbmpItem = HB_CreateShtCt;
		else if (wcscmp(menuTitle,     L"Rena&me")         == 0)
			mii.hbmpItem = bmpRen;
		else if (wcscmp(menuTitle,     L"Se&nd to")        == 0)
			mii.hbmpItem = bmpSnd3;			//  (HBITMAP)LoadImage(bmpSnd2, MAKEINTRESOURCE(iconinfo.hbmColor), IMAGE_BITMAP, 32, 32, LR_CREATEDIBSECTION | LR_SHARED);
		else if (wcscmp(menuTitle,     L"&Delete")         == 0)
			mii.hbmpItem = HB_Del;
		else if (wcsstr(menuTitle,     L"ancel")          != NULL)
			mii.hbmpItem = HB_Del;		//	mii.hbmpUnchecked = NULL;
		else if (wcsstr(menuTitle,     L"shortcut")       != NULL)  //  else if (wcscmp(menuTitle, L"Create &shortcut") == 0) {
			mii.hbmpItem = HB_CreateShtCt;
		else if (wcscmp(menuTitle,     L"Ne&w")            == 0)
			mii.hbmpItem = bmpNew;
		else if (wcscmp(menuTitle,     L"Mana&ge")         == 0)
			mii.hbmpItem = bmpSkul;
		else if (wcsstr(menuTitle,     L"efresh")         != NULL)
			mii.hbmpItem = bmpRefr;
		else if (wcsstr(menuTitle,     L"operties")       != NULL)
			mii.hbmpItem = bmpProp;
		else if (wcscmp(menuTitle,     L"La&rge icons")    == 0)
			mii.hbmpItem = bmpView;
		else if (wcsstr(menuTitle,     L"Undo")           != NULL) {
			mii.hbmpItem = HB_Undo;
			SetMenuItemInfo(hmenu, i, TRUE, &mii);
			mii.fMask = MIIM_STRING;
			if (wcsstr(menuTitle,      L"Move") != NULL)
				mii.dwTypeData =       L"&Undo Move";
			else if (wcsstr(menuTitle, L"New") != NULL)
				mii.dwTypeData =       L"&Undo New-file";
			else if (wcsstr(menuTitle, L"Paste") != NULL)
				mii.dwTypeData =       L"&Undo Paste";
			else if (wcsstr(menuTitle, L"Delete") != NULL)
				mii.dwTypeData =       L"&Undo Delete";
			else if (wcsstr(menuTitle, L"Rename") != NULL)
				mii.dwTypeData =       L"&Undo Rename";
		   else mii.dwTypeData =       L"Undo";
		}
		else if (wcsstr(menuTitle,     L"Redo") != NULL) {
			mii.hbmpItem = HB_Redo;
			SetMenuItemInfo(hmenu, i, TRUE, &mii);
			mii.fMask = MIIM_STRING;
			if (wcsstr(menuTitle,      L"move") != NULL)
				 mii.dwTypeData =      L"&Redo Move";
			else if (wcsstr(menuTitle, L"New") != NULL)
				 mii.dwTypeData =      L"&Redo New-file";
			else if (wcsstr(menuTitle, L"Paste") != NULL)
				 mii.dwTypeData =      L"&Redo Paste";
			else if (wcsstr(menuTitle, L"delete") != NULL)
				 mii.dwTypeData =      L"&Redo Delete";
			else if (wcsstr(menuTitle, L"Rename") != NULL)
                 mii.dwTypeData =      L"&Redo Rename";
			else mii.dwTypeData =      L"&Redo";
		}
		else if (wcsstr(menuTitle,     L"Sync or back up this folder") != NULL) {
			SetMenuItemInfo(hmenu, i, TRUE, &mii);
			mii.fMask = MIIM_STRING;
			mii.dwTypeData =           L"&Sync to G";
		}
		else if (wcsstr(menuTitle, L"Encrypt and upload to Drive") != NULL) {
			SetMenuItemInfo(hmenu, i, TRUE, &mii);
			mii.fMask      = MIIM_STRING;
			mii.dwTypeData = L"&Encrypt to G";
		}
		else if (wcscmp(menuTitle, L"Sync or back up this folder") == 0) {
			SetMenuItemInfo(hmenu, i, TRUE, &mii);
			mii.fMask      = MIIM_STRING;
			mii.dwTypeData = L"&Sync to G";
		}
		else if (wcscmp(menuTitle, L"Encrypt and upload to Drive") == 0) {
			SetMenuItemInfo(hmenu, i, TRUE, &mii);
			mii.fMask = MIIM_STRING;
			mii.dwTypeData = L"&Encrypt to G";
		}
		else if (wcscmp(menuTitle,     L"&Copy here") == 0)
			mii.hbmpItem = bmpCpy;
		else if (wcscmp(menuTitle,     L"&Move here") == 0)
			mii.hbmpItem = bmpSnd3;
		else if (wcsstr(menuTitle,     L"ink Source") != NULL)
			mii.hbmpItem = HB_PickLink;
		else if (wcsstr(menuTitle,     L"Drop") != NULL)
			mii.hbmpItem = HB_PickLink;
		else if (wcsstr(menuTitle,     L"Customise this") != NULL)
			mii.hbmpItem = bmpCstm;
		else if (wcscmp(menuTitle,     L"Cmd") == 0)
			mii.hbmpItem = HB_Cmd;
		else chIcon = false;

		if (chIcon) SetMenuItemInfo(hmenu, i, TRUE, &mii);
		free(menuTitle); //mii.fMask = MIIM_STRING;		
	}
	return MAKE_HRESULT(SEVERITY_SUCCESS, FACILITY_NULL, 0);		// Same as S_OK
}

STDMETHODIMP CIconInjector::InvokeCommand(LPCMINVOKECOMMANDINFO info) {
	return S_OK;
}

STDMETHODIMP CIconInjector::GetCommandString(UINT_PTR, UINT, UINT*, LPSTR, UINT) {
	return S_OK;
}
