// IconInjector.cpp : Implementation of CIconInjector

#include "stdafx.h"
#include "IconInjector.h"
//#include "libloaderapi.h"
#include <string>
#include <Winuser.h>
// CIconInjector
HINSTANCE hInstance = NULL;
HMODULE   HHi     = GetModuleHandleA("ContextIcons.dll");
HBITMAP	  bmpCstm = (HBITMAP)LoadImage(HHi, MAKEINTRESOURCE(IDB_BITMAP22), IMAGE_BITMAP, 24, 24, LR_CREATEDIBSECTION | LR_SHARED);
HBITMAP	  bmpCpy  = (HBITMAP)LoadImage(HHi, MAKEINTRESOURCE(IDB_BITMAP1) , IMAGE_BITMAP, 24, 24, LR_CREATEDIBSECTION | LR_SHARED);
HBITMAP	  bmpCut  = (HBITMAP)LoadImage(HHi, MAKEINTRESOURCE(IDB_BITMAP2) , IMAGE_BITMAP, 24, 24, LR_CREATEDIBSECTION | LR_SHARED);  //LR_CREATEDIBSECTION
HBITMAP	  bmpLNK  = (HBITMAP)LoadImage(HHi, MAKEINTRESOURCE(IDB_BITMAP11), IMAGE_BITMAP, 24, 24, LR_CREATEDIBSECTION | LR_SHARED);
HBITMAP	  bmpDel  = (HBITMAP)LoadImage(HHi, MAKEINTRESOURCE(IDB_BITMAP4) , IMAGE_BITMAP, 24, 24, LR_CREATEDIBSECTION | LR_SHARED);
HBITMAP	  bmpNew  = (HBITMAP)LoadImage(HHi, MAKEINTRESOURCE(IDB_BITMAP3) , IMAGE_BITMAP, 24, 24, LR_CREATEDIBSECTION | LR_SHARED);
//HBITMAP	  bmpPst  = (HBITMAP)LoadImage(HHi, MAKEINTRESOURCE(IDB_BITMAP5) , IMAGE_BITMAP, 24, 24, LR_CREATEDIBSECTION | LR_SHARED);
HBITMAP	  bmpPath = (HBITMAP)LoadImage(HHi, MAKEINTRESOURCE(IDB_BITMAP6) , IMAGE_BITMAP, 24, 24, LR_CREATEDIBSECTION | LR_SHARED);
HBITMAP	  bmpPick = (HBITMAP)LoadImage(HHi, MAKEINTRESOURCE(IDB_BITMAP7) , IMAGE_BITMAP, 24, 24, LR_CREATEDIBSECTION | LR_SHARED);
HBITMAP	  bmpProp = (HBITMAP)LoadImage(HHi, MAKEINTRESOURCE(IDB_BITMAP20), IMAGE_BITMAP, 24, 24, LR_CREATEDIBSECTION | LR_SHARED);
HBITMAP   bmpRedo = (HBITMAP)LoadImage(HHi, MAKEINTRESOURCE(IDB_BITMAP13), IMAGE_BITMAP, 24, 24, LR_CREATEDIBSECTION | LR_SHARED);
HBITMAP	  bmpRefr = (HBITMAP)LoadImage(HHi, MAKEINTRESOURCE(IDB_BITMAP9) , IMAGE_BITMAP, 24, 24, LR_CREATEDIBSECTION | LR_SHARED);
HBITMAP	  bmpRen  = (HBITMAP)LoadImage(HHi, MAKEINTRESOURCE(IDB_BITMAP21), IMAGE_BITMAP, 24, 24, LR_CREATEDIBSECTION | LR_SHARED);
HBITMAP	  bmpSkul = (HBITMAP)LoadImage(HHi, MAKEINTRESOURCE(IDB_BITMAP23), IMAGE_BITMAP, 24, 24, LR_CREATEDIBSECTION | LR_SHARED);
//HBITMAP	  bmpSnd2 = (HBITMAP)LoadImage(HHi, MAKEINTRESOURCE(IDB_BITMAP10), IMAGE_BITMAP, 24, 24, LR_CREATEDIBSECTION | LR_SHARED);
HBITMAP	  bmpSrt  = (HBITMAP)LoadImage(HHi, MAKEINTRESOURCE(IDB_BITMAP15), IMAGE_BITMAP, 24, 24, LR_CREATEDIBSECTION | LR_SHARED);
HBITMAP	  bmpView = (HBITMAP)LoadImage(HHi, MAKEINTRESOURCE(IDB_BITMAP17), IMAGE_BITMAP, 24, 24, LR_CREATEDIBSECTION | LR_SHARED);
HBITMAP	  bmpGrpB = bmpSkul; //(HBITMAP)LoadImage(HHi, MAKEINTRESOURCE(IDB_BITMAP17), IMAGE_BITMAP, 24, 24, LR_CREATEDIBSECTION | LR_SHARED);
HBITMAP	  bmpUndo = (HBITMAP)LoadImage(HHi, MAKEINTRESOURCE(IDB_BITMAP13), IMAGE_BITMAP, 24, 24, LR_CREATEDIBSECTION | LR_SHARED);
HICON   bmpPst = (HICON)LoadImage(HHi, MAKEINTRESOURCE(IDI_ICON4), IMAGE_ICON, 24, 24, LR_CREATEDIBSECTION | LR_VGACOLOR | LR_SHARED);
HBITMAP BMPPst;
//HICON   bmpSkul = (HICON)LoadImage(HHi, MAKEINTRESOURCE(IDI_ICON12), IMAGE_ICON, 24, 24, LR_CREATEDIBSECTION | LR_SHARED);
//HICON   bmpNew = (HICON)LoadImage(HHi, MAKEINTRESOURCE(IDI_ICON22), IMAGE_ICON, 24, 24, LR_CREATEDIBSECTION | LR_VGACOLOR | LR_SHARED);
//HICON   bmpRen = (HICON)LoadImage(HHi, MAKEINTRESOURCE(IDI_ICON17), IMAGE_ICON, 24, 24, LR_CREATEDIBSECTION | LR_VGACOLOR | LR_SHARED);
//HICON   bmpRedo = (HICON)LoadImage(HHi, MAKEINTRESOURCE(IDI_ICON7), IMAGE_ICON, 24, 24, LR_CREATEDIBSECTION | LR_VGACOLOR | LR_SHARED);
//HICON   bmpRedo = (HICON)LoadImage(HHi, MAKEINTRESOURCE(IDI_ICON7), IMAGE_ICON, 24, 24, LR_SHARED);
//HICON   bmpUndo = (HICON)LoadImage(HHi, MAKEINTRESOURCE(IDI_ICON8), IMAGE_ICON, 24, 24, LR_CREATEDIBSECTION | LR_VGACOLOR | LR_SHARED);
//HICON   bmpView = (HICON)LoadImage(HHi, MAKEINTRESOURCE(IDI_ICON9), IMAGE_ICON, 24, 24, LR_CREATEDIBSECTION | LR_VGACOLOR | LR_SHARED);
//HICON   bmpSrt = (HICON)LoadImage(HHi, MAKEINTRESOURCE(IDI_ICON10), IMAGE_ICON, 24, 24, LR_CREATEDIBSECTION | LR_VGACOLOR | LR_SHARED);
HICON   bmpSnd2 = (HICON)LoadImage(HHi, MAKEINTRESOURCE(IDI_ICON12), IMAGE_ICON, 24, 24, LR_SHARED);
//HBITMAP   bmpPst = (HBITMAP)LoadImage(HHi, MAKEINTRESOURCE(IDI_ICON3), IMAGE_ICON, 24, 24, LR_LOADTRANSPARENT | LR_CREATEDIBSECTION | LR_SHARED);
//HICON   bmpShCt = (HICON)LoadImage(HHi, MAKEINTRESOURCE(IDI_ICON6), IMAGE_ICON, 24, 24, LR_CREATEDIBSECTION | LR_SHARED);
HBITMAP bmpShCt = bmpLNK;
ICONINFO iconinfo;
BOOL cunt;
BYTE lpXorBuf[32 * 32 * 3];
BYTE lpMaskBits[128];
HICON hicon;
HBITMAP	  bmpSnd22 = (HBITMAP)LoadImage(HHi, MAKEINTRESOURCE(IDB_BITMAP10), IMAGE_BITMAP, 24, 24, LR_CREATEDIBSECTION | LR_SHARED);
BITMAP really_gay;
//HBITMAP bmpCse  = (HBITMAP)LoadImage(HHi, MAKEINTRESOURCE(IDB_BITMAP6), IMAGE_BITMAP, 24, 24, LR_SHARED);	
//HBITMAP bmpTgt  = (HBITMAP)LoadImage(HHi, MAKEINTRESOURCE(IDB_BITMAP6), IMAGE_BITMAP, 24, 24, LR_SHARED);	

STDMETHODIMP CIconInjector::Initialize(LPCITEMIDLIST pidlFolder, LPDATAOBJECT pDataObj, HKEY hProgID) { // Load the images
	return S_OK;																									      
}
STDMETHODIMP CIconInjector::QueryContextMenu(HMENU hmenu, UINT uMenuIndex, UINT uidFirst, UINT uidLast, UINT flags) {
	using namespace std;
	
	//	mii.hbmpItem = bmpShCt;
	if (cunt = GetIconInfo(bmpPst, &iconinfo)) //hbmColor    hbmMask
	// handle a color icon
		if (iconinfo.hbmColor)
		{
			BYTE lpMaskBits[128];
			::GetBitmapBits(iconinfo.hbmMask, sizeof(lpMaskBits), lpMaskBits);

			// get the color icon bits
			::GetBitmapBits(iconinfo.hbmColor, 32 * 32 * 3, lpXorBuf);

			// run on raw bits
			for (int i = 0; i < 32 * 32 * 3; i += 3)
			{
				int r = lpXorBuf[i + 2];
				int g = lpXorBuf[i + 1];
				int b = lpXorBuf[i];
				// here you can change the rgb simply change the lpXorBuf
			}
			// create the new icon from the change xorbuf 
			//	HBITMAP hIcon = ::CreateBitmap(32, 32, 1, 24, lpMaskBits);
			hicon = ::CreateIcon(0, 24, 24, 1, 32, lpMaskBits, lpXorBuf);
			//mii.hbmpItem = NULL;
			//mii.hbmpItem = (HBITMAP)hIcon;
			//HBITMAP hBitmap = (HBITMAP)CopyImage(iconinfo.hbmColor, IMAGE_BITMAP, 0, 0, 0);
			ICONINFO iconinfo2;
			GetIconInfo(bmpPst, &iconinfo2);
			BMPPst = iconinfo2.hbmColor;
			mii.hbmpItem = (HBITMAP)CopyImage(BMPPst, IMAGE_BITMAP, 24, 24, LR_CREATEDIBSECTION);
		}

	//HBITMAP turface = iconinfo.hbmColor;




	if (flags & CMF_DEFAULTONLY) return S_OK;            // Don't do anything if double-click
	int itemsCount = GetMenuItemCount(hmenu);
	for (int i = 0; i < itemsCount; i++) {               // Iterate over YOUR MEN-u items
		MENUITEMINFO mii;
		ZeroMemory(&mii, sizeof(mii));
		mii.cbSize = sizeof(mii);
		mii.fMask = MIIM_FTYPE | MIIM_STRING;
		mii.dwTypeData = NULL;
		BOOL ok = GetMenuItemInfo(hmenu, i, TRUE, &mii); // Get the string length
		if (mii.fType != MFT_STRING) continue;
		UINT size = (mii.cch + 1) * 2;                   // Allocate enough space
		LPWSTR menuTitle = (LPWSTR)malloc(size);
		mii.cch = size;
		mii.fMask = MIIM_TYPE;
		mii.dwTypeData = menuTitle;
		ok = GetMenuItemInfo(hmenu, i, TRUE, &mii);      // Get the actual string data
		mii.fMask = MIIM_BITMAP;
		bool chIcon = true;
		if (wcscmp(menuTitle, L"S&ort by") == 0)
			mii.hbmpItem = bmpSrt;
		else if (wcscmp(menuTitle, L"&View") == 0)
			mii.hbmpItem = bmpView;
		else if (wcscmp(menuTitle, L"&Group by") == 0)
			mii.hbmpItem = bmpGrpB;
		else if (wcscmp(menuTitle, L"Cu&t") == 0)
			mii.hbmpItem = bmpCut;
		else if (wcscmp(menuTitle, L"&Copy") == 0) 
			mii.hbmpItem = bmpCpy;
		else if (wcsstr(menuTitle, L"&Copy") != NULL)
			mii.hbmpItem = bmpCpy;
		else if (wcscmp(menuTitle, L"&Paste") == 0) {
		//	GetIconInfo(bmpPst, &iconinfo);
			mii.hbmpItem = bmpPst; //iconinfo.hbmColor;
		}
		else if (wcscmp(menuTitle, L"Paste &shortcut") == 0)
			mii.hbmpItem = bmpShCt;
		else if (wcscmp(menuTitle, L"Rena&me") == 0)
			mii.hbmpItem = bmpRen;	
		else if (wcscmp(menuTitle, L"Se&nd to") == 0)
			mii.hbmpItem = bmpSnd22;			//(HBITMAP)LoadImage(bmpSnd2, MAKEINTRESOURCE(iconinfo.hbmColor), IMAGE_BITMAP, 24, 24, LR_CREATEDIBSECTION | LR_SHARED);
		else if (wcscmp(menuTitle, L"&Delete") == 0) {
			mii.hbmpItem = bmpDel;
		//	mii.hbmpChecked = NULL;
		//	mii.hbmpUnchecked = NULL;
		}
		else if (wcscmp(menuTitle, L"Create &shortcut") == 0) {
			//	mii.hbmpItem = bmpShCt;
			if (cunt = GetIconInfo(bmpSnd2, &iconinfo)) //hbmColor    hbmMask
			// handle a color icon
			if (iconinfo.hbmColor)
			{
				BYTE lpMaskBits[128];
				::GetBitmapBits(iconinfo.hbmMask, sizeof(lpMaskBits), lpMaskBits);

				// get the color icon bits
				::GetBitmapBits(iconinfo.hbmColor, 32 * 32 * 3, lpXorBuf);

				// run on raw bits
				for (int i = 0; i < 32 * 32 * 3; i += 3)
				{
					int r = lpXorBuf[i + 2];
					int g = lpXorBuf[i + 1];
					int b = lpXorBuf[i];
					// here you can change the rgb simply change the lpXorBuf
				}
			// create the new icon from the change xorbuf 
			//	HBITMAP hIcon = ::CreateBitmap(32, 32, 1, 24, lpMaskBits);
			hicon = ::CreateIcon(0, 24, 24, 1, 32, lpMaskBits, lpXorBuf);
			//mii.hbmpItem = NULL;
			//mii.hbmpItem = (HBITMAP)hIcon;
			//HBITMAP hBitmap = (HBITMAP)CopyImage(iconinfo.hbmColor, IMAGE_BITMAP, 0, 0, 0);
			ICONINFO iconinfo2;
			GetIconInfo(hicon, &iconinfo2);
			mii.hbmpItem = (HBITMAP)CopyImage(iconinfo2.hbmColor, IMAGE_BITMAP, 24, 24, LR_CREATEDIBSECTION);
			}		

			//HBITMAP turface = iconinfo.hbmColor;

		}

		else if (wcscmp(menuTitle, L"Ne&w") == 0)
			mii.hbmpItem = bmpNew;
		else if (wcscmp(menuTitle, L"Mana&ge") == 0)
			mii.hbmpItem = bmpSkul;
		else if (wcscmp(menuTitle, L"R&efresh") == 0)
			mii.hbmpItem = bmpRefr;
		else if (wcscmp(menuTitle, L"Pr&operties") == 0)
			mii.hbmpItem = bmpProp;
		else if (wcsstr(menuTitle, L"Undo") != NULL) {
			mii.hbmpItem = bmpUndo;
			SetMenuItemInfo(hmenu, i, TRUE, &mii);
			mii.fMask = MIIM_STRING;
			if (wcsstr(menuTitle, L"Move") != NULL)
				mii.dwTypeData = L"Undo Move";
			else if (wcsstr(menuTitle, L"New") != NULL)
				mii.dwTypeData = L"Undo New file";
			else if (wcsstr(menuTitle, L"Paste") != NULL)
				mii.dwTypeData = L"Undo Paste";
			else if (wcsstr(menuTitle, L"Delete") != NULL)
				mii.dwTypeData = L"Undo Delete";
			else mii.dwTypeData = L"Undo";
		} 

		else if (wcscmp(menuTitle, L"La&rge icons") == 0)
			mii.hbmpItem = bmpView;
		else if (wcsstr(menuTitle, L"Redo") != NULL) {
			mii.hbmpItem = bmpRedo;
			SetMenuItemInfo(hmenu, i, TRUE, &mii);
			mii.fMask = MIIM_STRING;
			if (wcsstr(menuTitle, L"move") != NULL)
				mii.dwTypeData = L"Redo Move";
			else if (wcsstr(menuTitle, L"New") != NULL)
				mii.dwTypeData = L"Undo New file";
			else if (wcsstr(menuTitle, L"Paste") != NULL)
				mii.dwTypeData = L"Redo Paste";
			else if (wcsstr(menuTitle, L"delete") != NULL)
				mii.dwTypeData = L"Redo Delete";
			else
				mii.dwTypeData = L"Redo";
		}
		else if (wcsstr(menuTitle, L"Link Source") != NULL)
			mii.hbmpItem = bmpPick;		
		else if (wcsstr(menuTitle, L"Customise this") != NULL)
			mii.hbmpItem = bmpCstm;				
		else chIcon = false;
		if (chIcon) SetMenuItemInfo(hmenu, i, TRUE, &mii);
			free(menuTitle); //mii.fMask = MIIM_STRING;		
		//	else if (wcsstr(menuTitle, L"&Redo") != NULL) {
		//		mii.hbmpItem = bmpRedo;
		//	}
		//	else if (wcscmp(menuTitle, L"Open file locat&ion") == 0) {
		//		mii.hbmpItem = bmpTarget;
		//	}	
		//	else if (wcscmp(menuTitle, L"Attributes") == 0) {
		//		mii.hbmpItem = bmpAttributes;
		//}
		//	else if (wcscmp(menuTitle, L"&Copy here") == 0) {
		//		mii.hbmpItem = bmpCopy;
		//}
	}
	return MAKE_HRESULT(SEVERITY_SUCCESS, FACILITY_NULL, 0);		// Same as S_OK
}
STDMETHODIMP CIconInjector::InvokeCommand(LPCMINVOKECOMMANDINFO info) {
	return S_OK;
}
STDMETHODIMP CIconInjector::GetCommandString(UINT_PTR, UINT, UINT*, LPSTR, UINT) {

	return S_OK;
}

