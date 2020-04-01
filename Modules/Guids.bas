#include "Guids.bi"

' {9AC86F9F-4807-40F6-BBE0-1D7E905568AB}
DEFINE_IID(IID_ITestComServer, _
	&h9ac86f9f, &h4807, &h40f6, &hbb, &he0, &h1d, &h7e, &h90, &h55, &h68, &hab _
)

' {AC4B9914-B444-40D5-8D37-D7EC78B31538}
DEFINE_IID(IID_ITestComServerEvents, _
	&hac4b9914, &hb444, &h40d5, &h8d, &h37, &hd7, &hec, &h78, &hb3, &h15, &h38 _
)

' {8093BC4B-F7BD-4D4A-AF46-F0D094DF9AF8}
DEFINE_CLSID(CLSID_TESTCOMSERVER_10, _
	&h8093bc4b, &hf7bd, &h4d4a, &haf, &h46, &hf0, &hd0, &h94, &hdf, &h9a, &hf8 _
)

' {F727B565-4533-4705-BD7B-083B3DBB6D00}
DEFINE_LIBID(LIBID_TESTCOMSERVER_10, _
	&hf727b565, &h4533, &h4705, &hbd, &h7b, &h08, &h3b, &h3d, &hbb, &h6d, &h00 _
)

#ifdef GUIDS_WITHOUT_MINGW

' {00000001-0000-0000-C000-000000000046}
DEFINE_IID(IID_IClassFactory, _
	&h00000001, &h0000, &h0000, &hC0, &h00, &h00, &h00, &h00, &h00, &h00, &h46 _
)

' {00020400-0000-0000-C000-000000000046}
DEFINE_IID(IID_IDispatch, _
	&h00020400, &h0000, &h0000, &hC0, &h00, &h00, &h00, &h00, &h00, &h00, &h46 _
)

' {A6EF9860-C720-11D0-9337-00A0C90DCAA9}
DEFINE_IID(IID_IDispatchEx, _
	&hA6EF9860, &hC720, &h11D0, &h93, &h37, &h00, &hA0, &hC9, &h0D, &hCA, &hA9 _
)

' {FC4801A3-2BA9-11CF-A229-00AA003D7352}
DEFINE_IID(IID_IObjectWithSite, _
	&hFC4801A3, &h2BA9, &h11CF, &hA2, &h29, &h00, &hAA, &h00, &h3D, &h73, &h52 _
)

' {B196B283-BAB4-101A-B69C-00AA00341D07}
DEFINE_IID(IID_IProvideClassInfo, _
	&hB196B283, &hBAB4, &h101A, &hB6, &h9C, &h00, &hAA, &h00, &h34, &h1D, &h07 _
)

' {A7ABA9C1-8983-11CF-8F20-00805F2CD064}
DEFINE_IID(IID_IProvideMultipleClassInfo, _
	&hA7ABA9C1, &h8983, &h11CF, &h8F, &h20, &h00, &h80, &h5F, &h2C, &hD0, &h64 _
)

' {DF0B3D60-548F-101B-8E65-08002B2BD119}
DEFINE_IID(IID_ISupportErrorInfo, _
	&hDF0B3D60, &h548F, &h101B, &h8E, &h65, &h08, &h00, &h2B, &h2B, &hD1, &h19 _
)

' {00000000-0000-0000-C000-000000000046}
DEFINE_IID(IID_IUnknown, _
	&h00000000, &h0000, &h0000, &hC0, &h00, &h00, &h00, &h00, &h00, &h00, &h46 _
)

' {00000000-0000-0000-0000-000000000000}
DEFINE_IID(IID_NULL, _
	&h00000000, &h0000, &h0000, &h00, &h00, &h00, &h00, &h00, &h00, &h00, &h00 _
)

' {00000000-0000-0000-0000-000000000000}
DEFINE_GUID(GUID_NULL, _
	&h00000000, &h0000, &h0000, &h00, &h00, &h00, &h00, &h00, &h00, &h00, &h00 _
)

#endif
