#include "Guids.bi"

#ifndef unicode
#define unicode
#endif

#include "windows.bi"
#include "win\ole2.bi"

' {9AC86F9F-4807-40F6-BBE0-1D7E905568AB}
DEFINE_IID(IID_ITestComServer, _
	&h9ac86f9f, &h4807, &h40f6, &hbb, &he0, &h1d, &h7e, &h90, &h55, &h68, &hab _
)

' {8093BC4B-F7BD-4D4A-AF46-F0D094DF9AF8}
DEFINE_CLSID(CLSID_TESTCOMSERVER_10, _
	&h8093bc4b, &hf7bd, &h4d4a, &haf, &h46, &hf0, &hd0, &h94, &hdf, &h9a, &hf8 _
)

' {F727B565-4533-4705-BD7B-083B3DBB6D00}
DEFINE_LIBID(LIBID_TESTCOMSERVER_10, _
	&hf727b565, &h4533, &h4705, &hbd, &h7b, &h08, &h3b, &h3d, &hbb, &h6d, &h00 _
)
