

/* this ALWAYS GENERATED file contains the definitions for the interfaces */


 /* File created by MIDL compiler version 8.01.0622 */
/* at Tue Jan 19 03:14:07 2038
 */
/* Compiler settings for ContextIcons.idl:
    Oicf, W1, Zp8, env=Win64 (32b run), target_arch=AMD64 8.01.0622 
    protocol : all , ms_ext, c_ext, robust
    error checks: allocation ref bounds_check enum stub_data 
    VC __declspec() decoration level: 
         __declspec(uuid()), __declspec(selectany), __declspec(novtable)
         DECLSPEC_UUID(), MIDL_INTERFACE()
*/
/* @@MIDL_FILE_HEADING(  ) */



/* verify that the <rpcndr.h> version is high enough to compile this file*/
#ifndef __REQUIRED_RPCNDR_H_VERSION__
#define __REQUIRED_RPCNDR_H_VERSION__ 500
#endif

#include "rpc.h"
#include "rpcndr.h"

#ifndef __RPCNDR_H_VERSION__
#error this stub requires an updated version of <rpcndr.h>
#endif /* __RPCNDR_H_VERSION__ */

#ifndef COM_NO_WINDOWS_H
#include "windows.h"
#include "ole2.h"
#endif /*COM_NO_WINDOWS_H*/

#ifndef __ContextIcons_i_h__
#define __ContextIcons_i_h__

#if defined(_MSC_VER) && (_MSC_VER >= 1020)
#pragma once
#endif

/* Forward Declarations */ 

#ifndef __IIconInjector_FWD_DEFINED__
#define __IIconInjector_FWD_DEFINED__
typedef interface IIconInjector IIconInjector;

#endif 	/* __IIconInjector_FWD_DEFINED__ */


#ifndef __IconInjector_FWD_DEFINED__
#define __IconInjector_FWD_DEFINED__

#ifdef __cplusplus
typedef class IconInjector IconInjector;
#else
typedef struct IconInjector IconInjector;
#endif /* __cplusplus */

#endif 	/* __IconInjector_FWD_DEFINED__ */


/* header files for imported files */
#include "oaidl.h"
#include "ocidl.h"

#ifdef __cplusplus
extern "C"{
#endif 


#ifndef __IIconInjector_INTERFACE_DEFINED__
#define __IIconInjector_INTERFACE_DEFINED__

/* interface IIconInjector */
/* [unique][uuid][object] */ 


EXTERN_C const IID IID_IIconInjector;

#if defined(__cplusplus) && !defined(CINTERFACE)
    
    MIDL_INTERFACE("110A49B7-4A79-493A-A7EA-C6008399951D")
    IIconInjector : public IUnknown
    {
    public:
    };
    
    
#else 	/* C style interface */

    typedef struct IIconInjectorVtbl
    {
        BEGIN_INTERFACE
        
        HRESULT ( STDMETHODCALLTYPE *QueryInterface )( 
            IIconInjector * This,
            /* [in] */ REFIID riid,
            /* [annotation][iid_is][out] */ 
            _COM_Outptr_  void **ppvObject);
        
        ULONG ( STDMETHODCALLTYPE *AddRef )( 
            IIconInjector * This);
        
        ULONG ( STDMETHODCALLTYPE *Release )( 
            IIconInjector * This);
        
        END_INTERFACE
    } IIconInjectorVtbl;

    interface IIconInjector
    {
        CONST_VTBL struct IIconInjectorVtbl *lpVtbl;
    };

    

#ifdef COBJMACROS


#define IIconInjector_QueryInterface(This,riid,ppvObject)	\
    ( (This)->lpVtbl -> QueryInterface(This,riid,ppvObject) ) 

#define IIconInjector_AddRef(This)	\
    ( (This)->lpVtbl -> AddRef(This) ) 

#define IIconInjector_Release(This)	\
    ( (This)->lpVtbl -> Release(This) ) 


#endif /* COBJMACROS */


#endif 	/* C style interface */




#endif 	/* __IIconInjector_INTERFACE_DEFINED__ */



#ifndef __ContextIconsLib_LIBRARY_DEFINED__
#define __ContextIconsLib_LIBRARY_DEFINED__

/* library ContextIconsLib */
/* [version][uuid] */ 


EXTERN_C const IID LIBID_ContextIconsLib;

EXTERN_C const CLSID CLSID_IconInjector;

#ifdef __cplusplus

class DECLSPEC_UUID("EA7B0CA1-BF70-406C-BD22-690E5F9E6618")
IconInjector;
#endif
#endif /* __ContextIconsLib_LIBRARY_DEFINED__ */

/* Additional Prototypes for ALL interfaces */

/* end of Additional Prototypes */

#ifdef __cplusplus
}
#endif

#endif


