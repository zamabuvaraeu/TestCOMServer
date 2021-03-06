#include "Guids.bi"

' {8093BC4B-F7BD-4D4A-AF46-F0D094DF9AF8}
DEFINE_CLSID(CLSID_TESTCOMSERVER_VERSION10, _
	&h8093bc4b, &hf7bd, &h4d4a, &haf, &h46, &hf0, &hd0, &h94, &hdf, &h9a, &hf8 _
)

' {4DC1A94A-CED2-4B2A-B61A-6B0213DF7F63}
DEFINE_CLSID(CLSID_CONNECTIONPOINT_DISPATCH, _
	&h4DC1A94A, &hCED2, &h4B2A, &hB6, &h1A, &h6B, &h02, &h13, &hDF, &h7F, &h63 _
)
' {2A3DD892-3FFC-4FC5-9D55-951333565150}
DEFINE_CLSID(CLSID_CONNECTIONPOINT_VIRTUALTABLE, _
	&h2A3DD892, &h3FFC, &h4FC5, &h9D, &h55, &h95, &h13, &h33, &h56, &h51, &h50 _
)

' {9AC86F9F-4807-40F6-BBE0-1D7E905568AB}
DEFINE_IID(IID_ITestComServer, _
	&h9ac86f9f, &h4807, &h40f6, &hbb, &he0, &h1d, &h7e, &h90, &h55, &h68, &hab _
)

' {AC4B9914-B444-40D5-8D37-D7EC78B31538}
DEFINE_IID(IID_ITestComServerEvents, _
	&hac4b9914, &hb444, &h40d5, &h8d, &h37, &hd7, &hec, &h78, &hb3, &h15, &h38 _
)

' {EA31EDD9-8073-407A-87FA-06261B6C26ED}
DEFINE_IID(DIID_ITestComServerEvents, _
	&hEA31EDD9, &h8073, &h407A, &h87, &hFA, &h06, &h26, &h1B, &h6C, &h26, &hED _
)

' {47D449F7-1B64-4626-AD32-A6CCEC06BF33}
DEFINE_IID(IID_ITestComServerEventsConnectionPoint, _
	&h47D449F7, &h1B64, &h4626, &hAD, &h32, &hA6, &hCC, &hEC, &h06, &hBF, &h33 _
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

' {B196B286-BAB4-101A-B69C-00AA00341D07}
DEFINE_IID(IID_IConnectionPoint, _
	&hB196B286, &hBAB4, &h101A, &hB6, &h9C, &h00, &hAA, &h00, &h34, &h1D, &h07 _
)

' {B196B284-BAB4-101A-B69C-00AA00341D07}
DEFINE_IID(IID_IConnectionPointContainer, _
	&hB196B284, &hBAB4, &h101A, &hB6, &h9C, &h00, &hAA, &h00, &h34, &h1D, &h07 _
)

' {00020400-0000-0000-C000-000000000046}
DEFINE_IID(IID_IDispatch, _
	&h00020400, &h0000, &h0000, &hC0, &h00, &h00, &h00, &h00, &h00, &h00, &h46 _
)

' {A6EF9860-C720-11D0-9337-00A0C90DCAA9}
DEFINE_IID(IID_IDispatchEx, _
	&hA6EF9860, &hC720, &h11D0, &h93, &h37, &h00, &hA0, &hC9, &h0D, &hCA, &hA9 _
)

' {B196B285-BAB4-101A-B69C-00AA00341D07}
DEFINE_IID(IID_IEnumConnectionPoints, _
	&hB196B285, &hBAB4, &h101A, &hB6, &h9C, &h00, &hAA, &h00, &h34, &h1D, &h07 _
)

' {B196B287-BAB4-101A-B69C-00AA00341D07}
DEFINE_IID(IID_IEnumConnections, _
	&hB196B287, &hBAB4, &h101A, &hB6, &h9C, &h00, &hAA, &h00, &h34, &h1D, &h07 _
)

' {FC4801A3-2BA9-11CF-A229-00AA003D7352}
DEFINE_IID(IID_IObjectWithSite, _
	&hFC4801A3, &h2BA9, &h11CF, &hA2, &h29, &h00, &hAA, &h00, &h3D, &h73, &h52 _
)

' {B196B283-BAB4-101A-B69C-00AA00341D07}
DEFINE_IID(IID_IProvideClassInfo, _
	&hB196B283, &hBAB4, &h101A, &hB6, &h9C, &h00, &hAA, &h00, &h34, &h1D, &h07 _
)

' {A6BC3AC0-DBAA-11CE-9DE3-00AA004BB851}
DEFINE_IID(IID_IProvideClassInfo2, _
	&hA6BC3AC0, &hDBAA, &h11CE, &h9D, &hE3, &h00, &hAA, &h00, &h4B, &hB8, &h51 _
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
