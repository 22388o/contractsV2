arr = [
"0x344053b16d79a173a376443178d989350dd686bdd3e5fac2121763f82ffb64e3",
"0x0ea8dec1b0e903e258100bce3e0df6b2f73d64bc7e27b91e176e23a52daba30e",
"0x09928c79228d0e6ad1a72e094df7775fe88a5d1267568415ec3abc8d5d1c1d52",
"0x8a69f252a735f43d456d211147cc0622eb65918554aeb8039cf58f8333a65be8",
"0xfa67c3a64f2fad680c7b4417e770e8ad824c321ad3a4cccd49cac29da9c5fc5a",
"0xdcf7a1e379d329b50e938c0a35607e3b67e4ed8d50c470e50a1539e45765122e",
"0x794daa7a2fcc7907e552f6d15debefacf74e0de98c1f38a49fb59bc28dcdb8d4",
"0x1cc05ef1f019d43f6d9df00ab5ee54f74c31176e6ceffcbd323ed457bdc08b76",
"0x862db0f4a2a0486299a16a0a7ab3477da770dbe40a5ad9bb491e385eb8ab77c2",
"0x6a2b7310a7c231455efd41539b7d66aea0d22ba28f7e8d413787eb40d984adfa",
"0xc43b03e9513fa2539df8a717e125a5a4c8e17426ac423770ba88d01fb4518bf3",
"0xcb60490e04b818f3d7bad5a090148cf1dfde1fcd558529bfadef61ea3bb3a904",
"0x0b2e701b13d960f69393595e5e6098beda1e95b60b7ecc74ff3ba209e514035e",
"0x4041d76502826adaace4fddc3faa5d404befc17121c5cb49ae18c77b7f63745a",
"0xdd5ac0ceb69950df5cb0831e86bafcd80dfea8aef4788cb2aec0a06b60ef3b52",
"0x90e5bae98eabbdd648f3525a11b88085e7bd24b95711bac4b9b0c5ebe94c2488",
"0x6724c816e23b61f1c81c71ac98b061fa18c6dc4505043dc6751c651dc1bb7474",
"0xa0e26b46259be94484fb7b18b268526089e5979730ceffbee82a4905c5579c94",
"0x3e2b2f5ce3b076d9acb19b82e0a532e2089180b272a5751420faffb43e4a9e97",
"0x3446b1b6e8c44b9b928d96e1a7b98a2c45205532dc6036fc3645fdda0ce1b818",
"0x3ec644fb1fcec93e1f7710209ae77b613d02f3867a520e4053c9302ed7f490d6",
"0xbd4e3d7d4223da699bcb82e101341cc4e49063ec89b5cee58b74cef37454cc71",
"0xff32e1c51a0ce06de968c917f3c6b0243e9db57d6853b508c232718549e1d749",
"0xd001c3862a3422b62b7cd03b55125f409711ff1205be2268bc93f7fc89096f10",
"0x643521372fe8aab0efacf32b9f668fc06d76f5ffe77afe909b648b61e03c1040",
"0xb12cd8b913b651c806f12095347ead01a3d52f8a658d741d47cc161ad66f7c8b",
"0x96cd236057559b9c4b859215c76144feeaa465dcab2eb2e6c479ec9dc3b25515",
"0xb432143d2e805b08b4579cabd8721612c7cf97098a84f03a3139761fe9cf8002",
"0xd2bf7355f16d41115c6a7bbe031be398f7c02664a0c21ee7f5a0304b99c2d13f",
"0x697c0a6445a88a44163666986a1e1fac85703c0417e188d5915af1161899099a",
"0x9ca9e679d41b246ac8c299db9045306cb36600aa718ca64ff08a531e847cd351",
"0x80682b0cd17f6afb67dd5205170cad192e0ef2fbbc8d26fec7345f733d3fd97c",
"0xdde55f724053e369f604fee50143f91c28f866a988185b68f624d50dd585f20f",
"0x7a79dedc4c91f72f6fed3c1b7464b1aab0113b19a5d6cb462f4296c86c86d451",
"0x059df0f90edc66a13ef4db96d629fc32d6b80d3bc9155e1d6afbee64ea465453",
"0xefbbe993dd7bb34e7e83195b1ac53fe97aa4803e0fe2f9470cd7374b0f77699c",
"0x21a8bbd6df2ae55736568414119a44735944d0872d94d56223af18d30c5be341",
"0xc96eb12c89232ea472a508437b5abc0d2e10aa2769e76acb348a0ce0c38c96c3",
"0xf19f9931d587bf48d720cd836805eb740540e6cf04a949261dcc674224903436",
"0x67500b6416dd37baef5208be4abfe1d6e697534ee419080fb8fa8f3de05870cf",
"0x79c9c9dac3b70039444f31bbe4f8cabc11c2e46d8ab5c7fa1e406eb27156ae0c",
"0xef4b085537e1b30877536ca342039211c96c30e2fe3c7b94809972a11249464c",
"0x643b5400479477c3a1e6f5be095477c5176e09346e248c50df28a32561c874e5",
"0xf1746915c09000d51d29a9be6a86b61218dc15510b40ac99f42f1cd2c54e99a8",
"0x7e762caec064b27b88cc80b6fcc075a80766ea7d0e439db91d358ef8e281dd02",
"0x69c44817c9472db60c6c7620f31c937632742344c27b143234ed2604177ec46d",
"0x0d81c88c7c1e9db103c50e0afb357839b489f67da81f7701b094a52254a7ff5b",
"0x939eabc9d8c3ecbc01091f5b07ef1241caac14b7905ebdba6622ab67372db9e4",
"0x25e7803f79e6ea30224c59fa0373e303f01e9e901fa75364190c1d420676eeab",
"0xf89f9c9656d24e274b0f0c331400c64545ce8823fae09c2f4a51200426ee56d6",
"0x220a1d7384dd09973d45401d207ab4c95c710e083539912ebb51a31d1128becf",
"0x411b971b5e9a0388ba0c51f3d49d805f81c1b87921062560c1a63a9764619708",
"0xfc6d1b1827626d4aa6f0e297295a99d029a101b65b376218c414d4edc8a59cd3",
"0xc34f94fd1d2f3ca7642740f0a8465464054544c0891550e481e811cf00e471ea",
"0x778e76d45386aa172078c414de34d2ce2e4b3e81bc7412323abf09aa804dd35c",
"0x8ca22404927197c9851da382c1b485a9a3147fb052e4293075e7e72115aa9226",
"0xb180c31f07f9f4cb88f00ed579f7fd0af2b6a6c586206dfc757ba2aa4bbdeaa1",
"0xc55d6857ff1312eb212ef82049d16fb9f3209fee74bf086e821b38d284561034",
"0xebdc76d8b5fe944cf64e98ed35befc2211e39904b40e202f41725fd5fb1b5d8e",
"0x101881788d8db96937fc68870270251e5639f5fda6b445b6ad3e6010c7791057",
"0xfbc54cbcd12b726836b60de5acbfdf4236703141cb909bda0b67cb2242fd7d82",
"0x63850a89c2fb454db4769fbd5a72c4b2cfde2b48b3cced1225d875d65eb1f805",
"0x6715dd5f78397e7cca6f1bfb3be097e15765bbda6496ee38ca4e51c5eaf70d56",
"0x5ddb5e99de151b72422023fe76c30eb315146524250b46cd8e1dfa7cb7951c1e",
"0x9d96b5aa2dd167eaf95b575f46de6f8a2be35e6c8d5bdf65a1a22cb0ceef93cd",
"0xcc502c0d295363e2ae9e70c81bda81f2cabbf8c275c502ab96de3443fab26c9e",
"0xa759e5367346c12432d757b1e166256f77ffcbe15d9c2f849f42154eddfb81d9",
"0x4ac4486b64cacb068e20488a1300b785ebd9d0bdee4ad1e3e14e2f6dc13dc5f8",
"0xebbed1be4d95094ab6f793025dc057a60d6ecd90533cce3e52c3fcd933e7f851",
"0x1e55954f14236d5c7ddb7d4f894589a68d7382fb82c456181676649a42e8af13",
"0x7fd0a0328e603c3fe7dd6b1353d65f1920f405d3a6ebcad488249f192c98de1b",
"0x82f822fc9dc5f1ac47e25bf56e756aab7676e9bbdecabb1ce08380cd25c779db",
"0x6fc26a6234b6c8b52e006df773d506fa9bf4bcee568133635b21fa9bd8754d67",
"0xd13cd8e0e31a04197c806cd3e1fb5a679c71a574608b6803a419cdb96c74aace",
"0xc8b2cce154ee7615bff9a17b067d958d51bbd6fefe87833f48f54ef7d8a16fb3",
"0x6994c5977137c582ea80a6262942da2bfdab3217320d8d6249c69f100cc54aab",
"0xf3f637f085edad301fa1b1ba53afddfcad7f9238abef740bdcccebc07d544af2",
"0xced0d4246f35ecc1cc628043433e6ddbb723238de89172b116457283af1dc10c",
"0xe1629c0494bbb25cafdc98cdff24125b98423a7dead283460c7384c90da057a3",
"0x551e84e5cf7db30823c42b751b78a70f7f3280d76e9208ff5cd5570cd027faf6",
"0x88a80e4fe150013a19733e063039d741f37a00854017e4442bb2ae3d6493e36c",
"0xa7dfbddd96e277f32b9fbca4b3c72880077219a6f7950bc9d54a5c3bd2779144",
"0x92c8a591a39431f1ade50571c13f1903705856e7963983d332311a35a43b7a2f",
"0xf48bfeced886d1823d40d19c1c1b67191fb728732a2cb84dc23861667249dd72",
"0xc4cdb7fb99dbe713dd4bf18bf15196aaf06b4437427031736ba30c557a880415",
"0xafff2cfe4a227aec986fb8a3ed1d0f357d4e2875594d8d3a9c22bfcf575afe8d",
"0xf628f5b90dbf2bda8a7c2af8264758f8982776b1ddc092ab014e8183fb959e82",
"0xe2d7206d9128cc8b77af1ee235880ea5c94ce0f750c4eba489c9829f04cbec5f",
"0x59522efc8f130f4c53e278adc4971f996317885fd3102e16db497202bc053976",
"0xc1c70011f626ec92ada9e58b6992af2de7528bf1b74ec39ce6f41e6014894c59",
"0x7591fcbeaa14ebb03485da1f871d76829d4db4f9b4f9379d1154a51c4fa08e45",
"0x49d643b4ea2a6c540e3b7cbc75a3a5f8a8fe27ef2c2df1d1165a291b1eb2a0a2",
"0x3849fc039d76138a1d3443009bdd2d18837d4f38c33b5e904e22730053fa7502",
"0x65020d8c4072d54edb4b89e02dfbb069d4fa6b7aa605631d84458495bfa168df",
"0x9d3eecfed2c187fc60af120c09656e1c301bb56e91483aaa2c44a64ed8bde25d",
"0xdf0766fcd5ad955aa3fbdb2a5a8f4b2e5b33736c60c8a8c3764cf38594739dd7",
"0x00e3601e6037fa9606c74066821635351cfb9a04f88562cd315fc9a6f7fadb1a",
"0x24cacb20ed5eb0a69157653c977fa4dca7b5fc64ad23ceb5c0b547b8641b60a3",
"0x49a85a9a6c167b692e15ba30b4920170299985b261319d8f052c4d80111f6bbd",
"0xc7fcb150f546d19007df819d348d62c7ff3fd8e946954c58efe6152f900b8dfc",
"0xeb270c3beaeadc0fb336ddb826a61e0620ea10cf822007a6b8275ace34789005",
"0x1e7f93fffa11ff3da723910900ae673504df930efb16b48ffc065eaa07693a5e",
"0xaac1b1b107d4a814eadc65e49b0f217e0170c6e8d54a42bcccb6ed1d1312c70d",
"0x4d335d58e6b231b501e8178adf02201b1c765627c0d85b407a496dfd029ea591",
"0xb5c789fc2d21cf127cf0fe8a18c18a4da0d6fae3480552e6e578dd5d560bf0aa",
"0x660dfa5d926a09d7c2eadde19ff9e541235b78be6c22350f86e30003b7ba848a",
"0x1dbe013e31194f391545637d33ccde719d6ebc4cdfb78e14e97cfba42664f24e",
"0xb7f68347020c7df877c17615bc0aff9c5afba826c702866122d638602b400040",
"0xb5558995cbd94235c154592d1e21db062446ef93f1ea362edb805352b15061dd",
"0x1e9322ce5c3f3c30b83255a6ef6b3846fedd54a218047854497a020926620afa",
"0xebb8c898a4f9c44c87a39755f7f615bcd66d43a2f6846680d3a216f622c88148",
"0x926acaa41f10282e10f705b98d6fb141f3d3d83b8f7569123821e3c2e4a018d5",
"0x50e4cb0eeeb42b8f6c940328604d00ed75b16723084372721bcd95905d107dc9",
"0x5dad79d68f32ec66d197e60ce60befa1cf7bcb9d03282807755e948e403d1ab3",
"0x71bd7991401c116ac5959f28224c77af7d2420739bb236794cf5b06bb90a1c66",
"0xc9b489fe8c12212d4c5290b17bf6462a1fc7c81ec45b1495f2590fd46b406b02",
"0xd2c5c8c87ff103824765f1603dc07dc4df9bfc32f006865b810ebf40eb34ec28",
"0x3972f44e4a2d0fe1f029ae16589694632f9e34e18da77066ae9eb0f8784447e1",
"0x8155c55463da19c8a92c0ac01c5c7f3d2a338fc163ecdd840e352fd15bb6201b",
"0xc71f1d3ff795fb210289a5f5bd85ba4f72f9b2abfa2130ef7b75185f65aeafcc",
"0x38ea2257c97563cca57901ebd2c4b181ff05dcdb57eab5ba718c8d9dee0a7d5d",
"0x539aa1197eebbf7cd2f3e7b7ebdfa3d4e89e9c70f60f9b4803da13e0b246de57",
"0x4b151829ab136ae1a5cca207c5165505e1dc9c3db8b4f89142b440f2dbe6a27d",
"0x9a87b74da8091d24d061e75058e2338df33607d90d7518294b55024f8d8691e3",
"0x4aa9fc0f7df448f5777c495341650b76cdcf0d1d8480f4820ab4bef67b887d6c",
"0xcc331dbcb7c16b8ceec91e9bb99f7069045fad25ab24265fadcf84a2ca9ac122",
"0xe79ca6aea7d82578a7a113d1203e1ff14e67a03e14b6f336bd09b9781e6f1b25",
"0x052583b2587aaccaa4e9dfa090d343e7654b16404403fb6f994eb79a7206959c",
"0x7ba59f318b3aa857ec96aa37c0d5776ad675f06a9d19e160875848900d6d9a7e",
"0x00ce76410a25579a6a1de1b4548f6d4908b2279fb2605e476b07716027f1e7f5",
"0xc8cfd867cdc99302e7b70f70b731dfc274efbb5c5cf3beac9f942fd378b98ea2",
"0x2b94f312f64c40b8bf354de761e566a98b3b9492d41950919782f8b16d10a79b",
"0x009776ebf26008341f8725fcd8395b632ac14b562eaa36f50b1ab2b489de1317",
"0x6fb93667a81620878a6a7e8658ccc9c04f2c07e9fb342b8f23d4e3b308d0931b",
"0x7fa94b6f09fe8f1041ebbbf1d309f3a634105d85e4579643373e7a2c47b73a42",
"0x05674bcea937ffc9a7a008e0114468d777dd23e34f1c767a33125da2137febf0",
"0x6cc58b97899b7a9c1a5a7247d47ea3cff90e6aa53eea2b831fcd6236c313ccef",
"0x984b2bd31afdf976b23507edff2d69d53dcf6e4a09c3ed49833cf581818746c4",
"0xf422d4c348fc12ff70fb4224f66aeafa9d421e1323736b24cdd67eadf287d683",
"0x1421f8bb53db2b18311089cc81d25e29e00f6077068993f6b5b880bfa0216c4d",
"0x3e1b3927cb1353159edddbcbcaf54064b77b9725526f0b21b8aaab9c0c985c61",
"0xc51a80a8b06ea65488d58b5e1473806d82f1bcdac06344aabd967513fea1bc0c",
"0xb1f0e1289fdf6b203ac770bd7a2c36ab41c05e24ab2cff23d9daf77721028466",
"0x477524083e8846c35b86d64b3f752c775a455a61e32a14ffd02dd2d570bdbced",
"0x7134f9f2d9823ff72a4cb4d50d1375101d02fe3daae9a51da9a1e33438f46489",
"0x823ceafdd494936b3241a8dc95175d99ee1934c3e2c135981f174b5954dbca7c",
"0x80e3b22ac557502da357d725ecbb7074f3ee451ab64e96b56a78ecfcf5d208c9",
"0x30d9bc88276d942c764ec295c8a4fc0b72ff4ff22f423ca2d448abf19cf0c3ce",
"0x7ee94244c28ac7455cd7b7183a790fe91697aa5f5bdc8aed7fee45fb1a5bd70e",
"0x23138d9f9d4885ac142ac8271c6b5e28403b062de3cd66a88f2db2720a587d43",
"0x1e50a2c9fcfbdf08ebac37475e0f9291badb10f565874ee6044b9bd13cc84564",
"0x1a7619c2afec321e28838b2bcf8140322c6b009a4dd033f80a0908185541e327",
"0xe335cc6c0dbcc65e1290fe72f180da9b841cab637d29f49d271d54c77906a9cc",
"0xbe7439b5c6769e0757517b7329f548f6b02cad3f4549786be452c58d4a085ed9",
"0xcd65c6c6d531ab23580f30faccb2d610da5960b134ac56ece02f279f321bb391",
"0x99bfd20ed69c24a9f3c1695dffae4d6cd446cefb8289399dcb9e28ddbc3a9457",
"0x02981162b124ed8b86ad28ce562702e3692d287715a27dcf8325cc233e405a3f",
"0x672d80f150fbc2bf2c39f9d9f1c5ccfbaa2147556b0428040f70b826983fa7fc",
"0x0bc31be6ce4b4c445f1941b907115546a3bbaf14b33415cc613f063b2e874e92",
"0x9d0d007a34d955f2e42ccb7833ee1143050ad2dffad90c887ebd04b4db2d99c9",
"0x303e37a6fd9c5f61a1b5121da3dee02d4be66a217d424a340bd0523ee73e9c19",
"0x315ca0d6bc6792d1e6e958d4b4ead59c41cf077f70738aaeef0e51e09d93337d",
"0xc53a6370ade654856737fe4a57aad7336f61c4e9b8c93655e945e2ab7af4feef",
"0x203fa82276d21cf591c54cd32cbf9600bc29d96634e38a4202a627ebd86e93db",
"0x13833409b9038dd552a7e96f5a598431bb3c323133f92ec96d7a8971d5ff8df4",
"0x5eb42383ffe399c3b13fea9ae521035e7813e180843544acac7741e3d5710e76",
"0xf0cf27ec0be1db13e13051d4d45b647458b9d25ae63bff010c05f615c275719f",
"0x59bd50dda6195eaf99007bb9dfa1e51c5fcfc3bb0cfe53e1d1173d7a0b9522a4",
"0x374a125deb778dddb997746d08eca092143543da553a6278cb48655eae648fc5",
"0x71f48be0db776e6fb729d6bf22431c45e9662f73ac3b5024d8e18b31c3ce5155",
"0xf79881a59ff1e95c2919e0f167cef0bb2ca1b1c5db8f658afe7b19093590e94e",
"0x72ca3c63c2f06a0cf144521d94eafcc144f6fcc7ffbd5e821ea70e23d27c3c0d",
"0x78d673cbde37808da2246602c2b06ed97180179d99aabfd6387a19074767c180",
"0x678b4ed92255212a0855a8b8534c11920c47f8330ab5bbb18c65ebcd7bc16555",
"0x739caea419e67f9f0eadcb7c45c64afb0d2b87b0f64585962b1804f1fba0885a",
"0xe82860de176b38024bdfb82cd95a8dc54689a1e62651e126bd582314e8df648d",
"0xde5952a53fb2665578fd3d11ac6a7acddb10761e323353945cbdf859316d7421",
"0xb6202c0028e0169d9c10f5da2967f402cbe481a8d45e67c46229009e484b9859",
"0x58e0519f729150c2d33e714abba1a580277fb8212ef692e833fe299d24541ba4",
"0x165076c0969caf5403e5a19cd956426216abee82911b653f89018bb4d535ff82",
"0x4641e5fcc5e3d5254e949b9c6e5bb024a2ed06dd90b9dc09a5e85406a9834b81",
"0xb978e37fe29b923b08dd6f345ae59a23cd3809290d90a9ab1f9f188f66a0c1e2",
"0xf786b772b047006e6d397a136ebad019db2f86876b23b9a402e0174e782c8913",
"0x62cfe7d658b1c33144a745f259715c05c8a739277e02eab37f08f0b57d1b1887",
"0x38bbcc9a380e198819dc5bdf844daca86137f2f3980617d843e1c4a303e63022",
"0x4afca302e366355c4bacfef6324549d3467791d69c105f518dcf4ab90a3afb2a",
"0xf68cce38004af3c0ba45c2cb70d9fc631d626281f7a92eb737a022aea4fa7283",
"0xfe658097225c22cfda098b5f2ef2d4bcc6a94f570df52a1540ea59e80ff21b87",
"0xbfa6c0e227dd5295bb7fddf1b209445b81db57b1e15c1f14edd805ad6c6fb25a",
"0xfa490830c34b96c6b252c8406b3dfa4ff524eb4cfe147174333a6170fed7bdb9",
"0xff1cc7410e773986546446c0e0dcdbc68f959583b8c1222b72616a5bfc8ac2b3",
"0x06369468b03ea32e9142e44fb111d6346e33a14db1ade911658c3f49cd85c723",
"0x0e8026f763f2f0d6dc18df5eb4ed6849154b086b0f7d75d7209e20bfaf5a8763",
"0xc29f99cdd7ffbb9a6108f9055fd02c972ee4137fe678cfc363d255a7612a9f1b",
"0x6ec895a38f892d799b52c7ecc15503dfec4707a8ddc7aaf8adc274ce5e9cc1ed",
"0xdfaa9d6dc6a945e9914496d224dbd7cd7579d63a659582107bf83b08d77658e7",
"0x7c1e0010182e8a0cf54820b051127b0350bc81c67b57785f6ea05e8dbcb917a4",
"0x04eb4cbb41e1719fe8d4b89c46bc2367a808d7462b2961283a403f3ef023eb3a",
"0x2b31f02055436bc54c3791ec84885031eba6490361b189d8fad565cc6aa1eb1b",
"0x9406389d61a5ef71f68351d6f377df724b9af276d2e796392bb0bf627a479253",
"0xa0fe8bb49ceeddb451d5f7a8d31cc0289dd4c50ce243fff81939b1d9f9b58001",
"0x81eb593a19c157f166d4b58f3bd50cc9cf5d73c24f2ff8618124e388c808bd34",
"0x4407d7186e9a1067789887d5334aa4654cfe25a989ce2a8b4226e0c4d5c267ba",
"0xdcb269836e3437ab51b3bd19614e8e5ea7f8cfdaf2e7c771cb0f361971576cfe",
"0x8e7c52e7aff82c158cf8f9c9c3c0278ed15c03397cbc42a7f167918689b53546",
"0x79f5382df535dae7dddb9b29af5d84b5ea7ebe9eaadd273dbd6601964735045a",
"0x6266beac0597f557f78aac2be2d62a3282299a18176b69c5d33002218e930bb1",
"0xe89ffd76d0dae3e0f36916966444fc77112b7d6b0eb887370bf29b3bdc46548d",
"0x41d119430b441050c379a8960be89f421880f68d9bf55fa1002f7e7c748c585b",
"0xb3507dfe46cd1f9e6160860a93c2d9255dc69a2d049aaf19e390ddca5cb09eae",
"0x2e3ea2d36891971a1100681ea248d50eda2aafd46a44b340877790d53cd80a24",
"0x9606de0a5591a3bcaae62d0855d2032652c5c6ecc32d12803f96ab4c7d43b981",
"0xea6d0239ed30dd3583958a74f397624c9e8c8a9aaea388a9171b9d362a9ded9b",
"0xc02d1f22fb409ddc84395137fc98e91894dfae752dc4906176e20f2530b6e3b2",
"0xf6b2f6313a0a06e3bbc87aacf98fd84f326fe59db4cc4306427cd8cdfef8b122",
"0x4e417ae178a2882d5098235822c8fa9b3348a1ed1f1b3a894796719166dd91c0",
"0x4e8ceb90b3ec787f0de3a961affad293ac4929ff6202e6449f039c28eb42ea4c",
"0xebc4ffee4aa5f9086b6a928eae0ddc48e5c12b335a143813af1d1fdea1fa5e64",
"0xef48318982f598397454835a772ed0d3e8420311c73d186a1c4b66be0a57f6d1",
"0x2d54b2acad09fb46fa9d949643a904421101f192c2b1d34c6a5fb8911b2bb376",
"0x07ae573d8794adc0762930d9dbbaf963cd4d53141e6fa4928c0f122daf9f710a",
"0x3f615a1a01b9b0afd3d6084e9bb6e6c0bf26bc3468ac8e520840dba42e6b84e4",
"0x8377215c1bf357a2bce07af9364110fdaad39641c38e2d9fab9374c710d02611",
"0xec54a95033bd0bc71b5d3a51cc13d873e079d4fc94e0179a2d57ced38e7c0208",
"0x98dc9321862a11fea512c295416652856cd7a0fcacc04dd252b417aab59d4ad0",
"0x82a8b729e22913fb2a60d87c4618de69ab4b4e69c415f856b43738cce637f75d",
"0xc71d29354402e301ecbf2b2e485b4d4d3559f9c7f41442fa794787a54ca41950",
"0x0dd6fd4b66cf669b22b21a233fd653674bbdb67af12bb46dc00cfa9cec1b4ef5",
"0x027a3f9c39cec48606b13051f2ce9fea2d4815cadd39329297041abac720d133",
"0xf787d594e57e6c3e4d8c9a19bbfcdb42fef0cad508bf480f9ac6e42d17f0aca8",
"0x5d80ade284db0942f35b499768aea6ba0fd9b803eff9313f8b99bfd4246c228d",
"0x8f9e05f53f77873a31b9969282870b170d66454e45ab7e1b7b3479c010ff796c",
"0x15eda5f9067ead18fb6970808e6c00069dfcb50c32306374dadb7f4bf19bc654",
"0xac75938188dd04b45c58746d3f8db81facda8f3dad5d4b218fa3285cfece58b1"
]

results = {}

#arr = ["0x7ba59f318b3aa857ec96aa37c0d5776ad675f06a9d19e160875848900d6d9a7e", "0xac75938188dd04b45c58746d3f8db81facda8f3dad5d4b218fa3285cfece58b1"]
claimTopic = "0x24bce930431f78244a70aacbe370a3d06e5fd605a0bb737db20457a7f593e5d0"
stakeTopic = "0xc5017594d2723c038bb216e5bcef3ac65910ade839c0e63253bf5b59efbf0fd7"

users = []
claimed = []
stakingStartTimestamp = []
OOKI_ETH_LP = Contract.from_abi("OOKI_ETH_LP", "0xEaaddE1E14C587a7Fb4Ba78eA78109BB32975f1e", interface.IPancakePair.abi)
SUSHI = Contract.from_abi("SUSHI", "0x6b3595068778dd592e39a122f4f5a5cf09c90fe2", TestToken.abi)
for tx in arr:
    trans = chain.get_transaction(tx)
    print("processing: ", tx)
    if len(trans.logs)>0:
        for log in trans.logs:
            if log["topics"][0].hex() == claimTopic or log["topics"][0].hex() == stakeTopic:
                address = log["topics"][1]
                address = address.hex()[:2]+address.hex()[26:]

                token = log["topics"][2]
                token = token.hex()[:2]+token.hex()[26:]
                print(token, OOKI_ETH_LP)
                if(token.lower() != SUSHI.address.lower() and token.lower() != OOKI_ETH_LP.address.lower()):
                    continue

                value = int(log['data'], 16)

                if(address not in results):
                    results[address] = {
                        'stakingStartTimestamp': 0,
                        'claimed': 0
                    }
                    users.append(address)

                result = results[address]
                if(log["topics"][0].hex() == claimTopic):
                    result['claimed'] = result['claimed'] + value
                if(log["topics"][0].hex() == stakeTopic):
                    result['stakingStartTimestamp'] = trans.timestamp

                claimed.append(result['claimed'])
                stakingStartTimestamp.append(result['stakingStartTimestamp'])

