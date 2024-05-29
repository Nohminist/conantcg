'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"canvaskit/skwasm.worker.js": "bfb704a6c714a75da9ef320991e88b03",
"canvaskit/skwasm.js": "5d4f9263ec93efeb022bb14a3881d240",
"canvaskit/canvaskit.wasm": "9251bb81ae8464c4df3b072f84aa969b",
"canvaskit/canvaskit.js.symbols": "74a84c23f5ada42fe063514c587968c6",
"canvaskit/skwasm.js.symbols": "c3c05bd50bdf59da8626bbe446ce65a3",
"canvaskit/skwasm.wasm": "4051bfc27ba29bf420d17aa0c3a98bce",
"canvaskit/canvaskit.js": "738255d00768497e86aa4ca510cce1e1",
"canvaskit/chromium/canvaskit.wasm": "399e2344480862e2dfa26f12fa5891d7",
"canvaskit/chromium/canvaskit.js.symbols": "ee7e331f7f5bbf5ec937737542112372",
"canvaskit/chromium/canvaskit.js": "901bb9e28fac643b7da75ecfd3339f3f",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"manifest.json": "258de6763a36415a9250b8d6c2e4c59b",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"flutter_bootstrap.js": "f5fd696bd454764d2b1adaba5f1c16e5",
"version.json": "9063135f8283498a8618b9376bd42c5b",
"index.html": "b77258d0d8b2008c32d6500e89259f05",
"/": "b77258d0d8b2008c32d6500e89259f05",
"main.dart.js": "053b7e88e03ccb00d5b73a6803efeb89",
"assets/AssetManifest.json": "531bdea157a973306c444274f5b4ac17",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "e986ebe42ef785b27164c36a9abc7818",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin.json": "3c1c9715728de36ce8528a4285642ed7",
"assets/fonts/MaterialIcons-Regular.otf": "ec8133252f84dadfc2b505de2d7c0336",
"assets/fonts/NotoSansJP-Regular.ttf": "022f32abf24d5534496095e04aa739b3",
"assets/assets/images/B01060.jpg": "d249e12f8e4bba230804ad6674c287b6",
"assets/assets/images/B01089.jpg": "18b71e6b8b36823598e6184243362a60",
"assets/assets/images/D02008.jpg": "cc7a3474282a0bb29940b12fce32cebd",
"assets/assets/images/D02015.jpg": "6d3f96b2354f4515ccbfb87fd1361941",
"assets/assets/images/B01038.jpg": "9842e0b73ab0ffc0f52b85716297fef2",
"assets/assets/images/B01049.jpg": "54dadf63709d1cffcd94dfd08757502e",
"assets/assets/images/B01084.jpg": "8119ee1f2c591b7477fc9af4ec398797",
"assets/assets/images/D04015.jpg": "ecb365ef9ae707dc4e4ed794cf558132",
"assets/assets/images/B01026P.jpg": "3cb068be0b933b37f8d9f74b15de3f9b",
"assets/assets/images/icon-cutIn.png": "d28b9c2e04e10dd77492d278402053e1",
"assets/assets/images/B01100.jpg": "e4add4ecd16f3f960485f396c5324376",
"assets/assets/images/PR014.jpg": "965c7ffdc18ec34b2733c9b5bf93b193",
"assets/assets/images/D01008.jpg": "26f162e414ee3c3d3b7093caef5002ef",
"assets/assets/images/D01013.jpg": "57d6aa0d986f29ccce5d2565d14b7327",
"assets/assets/images/B01031.jpg": "6e8f26bcb49d4b393c001e97dbec675a",
"assets/assets/images/B01012.jpg": "745ee4200053e666ff52af4e9c261f96",
"assets/assets/images/B01080.jpg": "d9aec239c0a5063ce93b4483ab2c0a38",
"assets/assets/images/B01044P.jpg": "8b2b81c41172cc9a4b3f6081e76c14ba",
"assets/assets/images/PR002.jpg": "0c56d1c14b3a7a3b4dbb24deea88e942",
"assets/assets/images/B01011.jpg": "7ea9a84ac773447909b30bb6e128de1e",
"assets/assets/images/D04001.jpg": "cf33f2cb8693eb82756a2689c9baa576",
"assets/assets/images/B01019.jpg": "c0a61db5605a3c1f501cf3269920c6d3",
"assets/assets/images/B01076.jpg": "710ed0e5d132d12fb89fb54fb2182be6",
"assets/assets/images/D02002.jpg": "46f5605a910909db4f142f339ee347f5",
"assets/assets/images/D02009.jpg": "cb41b1a91836906e98a38b27cbf97cd7",
"assets/assets/images/B01060P.jpg": "6cedca1b57c7f477fb84596745fcc0ec",
"assets/assets/images/B01080P.jpg": "2b8de4486ec28eab604a59b97d54ea0f",
"assets/assets/images/B01082.jpg": "b51a01c8c29b0461f756da822f5bab41",
"assets/assets/images/B01056.jpg": "9a842e546c086eecbb8f1505f948b3b0",
"assets/assets/images/B01077.jpg": "569836229d8421f51ae6435b3c2209a4",
"assets/assets/images/B01024.jpg": "aecddf4905db3950c95b10eb12b7469a",
"assets/assets/images/D04013.jpg": "a383d4fb8fc03465f23e78b6c60f34b3",
"assets/assets/images/D01010.jpg": "131ea7427030f09beea4df834dee0027",
"assets/assets/images/B01092P.jpg": "5f5a0fc00550c3657b54aec64941484e",
"assets/assets/images/D03013.jpg": "5d972ea05adff4972d98be547a77a5f8",
"assets/assets/images/B01028P.jpg": "a38692f3207b5fc87e6be4f80fb9cf06",
"assets/assets/images/B01002.jpg": "8bba49687159297a46324c1061c29bb0",
"assets/assets/images/D02016.jpg": "f55ff5e78902cb730406a6afb6c70345",
"assets/assets/images/B01100P.jpg": "9fa3a49ba6eeed7626e2d79ce5ff1126",
"assets/assets/images/D01007.jpg": "e1a649e6d8d771d06ccee6a00c7e17b2",
"assets/assets/images/B01090.jpg": "01015fd601b89be0e33f62021f0ae501",
"assets/assets/images/B01020.jpg": "d2182b81ddcb164bd2d0e60ab80dfd55",
"assets/assets/images/B01001P.jpg": "98a55de178515d62f2bb8c8bc62cbef3",
"assets/assets/images/D03007.jpg": "7c14b6f542be8138e759db49cd8a0e27",
"assets/assets/images/B01059P.jpg": "99a49629bebedddaf9d999051d494414",
"assets/assets/images/B01099.jpg": "ab947ac4fb115fc69551f488b9a623d7",
"assets/assets/images/B01058.jpg": "15daf3684cd0f1ff7c4d650b86778c9c",
"assets/assets/images/D05016.jpg": "e0a362786bde011dafb21250e030b01f",
"assets/assets/images/D01012.jpg": "61f9cb3378be18b936a46a9c99952d2f",
"assets/assets/images/B01005.jpg": "5a350e7f7701531dc143842008686950",
"assets/assets/images/PR013.jpg": "e1e8c60c8623d7038467d693aebf33d6",
"assets/assets/images/D04002.jpg": "95d942cb2b4c62e6b3b19a0c8ed7c4a9",
"assets/assets/images/B01030.jpg": "9864d93edda4db8477ddac568dde39bf",
"assets/assets/images/B01004.jpg": "aefd97bf106c27d1ff10183f7fd77ac6",
"assets/assets/images/PR004.jpg": "3243ecc7ce62a0a3dc5b0d5a5cf7ef4b",
"assets/assets/images/B01039.jpg": "b0cd375b4f85f8809f464bfce32b1a95",
"assets/assets/images/B01086P.jpg": "3fc23d1c9eed31ae50a843aa09e6764c",
"assets/assets/images/B01094.jpg": "740f1eefbb1cfc4220e1113559daca92",
"assets/assets/images/PR001.jpg": "2d84669b3ceb084c581fe5a68599db43",
"assets/assets/images/B01037.jpg": "3c5cd57787c4020ebc453a63b3a23962",
"assets/assets/images/B01091.jpg": "2ab90d0715e15412857a9865972f4552",
"assets/assets/images/B01033.jpg": "a4c30dbc5315060996ad473e6c7b6ed3",
"assets/assets/images/D02007.jpg": "94bd78fbbc4dff2a473d0b4d21bb796c",
"assets/assets/images/D03009.jpg": "05021a86f0d078870ecc77f72224cdcf",
"assets/assets/images/D03002.jpg": "bc741a2f02f55ae08b43c1dcd189d751",
"assets/assets/images/B01007.jpg": "2dca6c179454119dbae128166a4438f4",
"assets/assets/images/D02014.jpg": "d733020b2657104ad33e6294df63a8df",
"assets/assets/images/D05014.jpg": "a6b7620ff960f6ef0b358a6764be8667",
"assets/assets/images/D04011.jpg": "9894507633963bc5547f601549ee93fd",
"assets/assets/images/B01099P.jpg": "f05e0d7d8947bed7b5fbf8d08dd2ccc3",
"assets/assets/images/D01011.jpg": "c03572ae49f7963f457070be8d991b9a",
"assets/assets/images/PR015.jpg": "59a1b6e838abd46dcbfcb5ad1038e108",
"assets/assets/images/B01034.jpg": "a33f238ecf3ea8f72b3e744ab3dadce0",
"assets/assets/images/B01102P.jpg": "f158c71be0ca768e0c6a1f73f50a09f8",
"assets/assets/images/B01101P.jpg": "4ff7fe19a1692ecd87e45a4d81ee4cbe",
"assets/assets/images/D04004.jpg": "6f721c42c7895b7a5d0ced6424896851",
"assets/assets/images/B01022.jpg": "7d7903bbc26bc8b62564a1ae6da1b2b2",
"assets/assets/images/B01004P.jpg": "250364c128955cb4be4ace8332c053f4",
"assets/assets/images/B01014.jpg": "33dcf34fd2155c954a2cbb672075cb71",
"assets/assets/images/B01050.jpg": "a9ad8f2926be8da2a274970e7af0a668",
"assets/assets/images/B01064.jpg": "b34220da658163380be93b7b565c43a6",
"assets/assets/images/B01067.jpg": "29027cbeae0fe207d971a22891e5cd80",
"assets/assets/images/B01055P.jpg": "28241f8269b02f221134258d7255bb57",
"assets/assets/images/B01009.jpg": "23f20d6d6dfb5206c0f83a18b9e159d8",
"assets/assets/images/D01002.jpg": "4aa5e39b64f9e9daca0e95c2aed52e94",
"assets/assets/images/B01062P.jpg": "d8c513cf58284adb5537e334d0ed5c06",
"assets/assets/images/B01047P.jpg": "a3e5551c6f9628670f7847335131dfe1",
"assets/assets/images/B01094P.jpg": "32067052a659fb1fca1953723760915f",
"assets/assets/images/B01063.jpg": "4605f2b55821282d15d20fd777a2692f",
"assets/assets/images/B01015.jpg": "9b5807a525b29120b74197b4bfc52e86",
"assets/assets/images/B01096P.jpg": "fb47cdb16140f74e329c9dd3f0754695",
"assets/assets/images/B01078P.jpg": "8c3f9c04ef78d015a977374c74d20e6c",
"assets/assets/images/back.png": "7d03a0fbfd8692d17b2b4538daf59552",
"assets/assets/images/D05003.jpg": "d852cd587c5507f3d1ef0bbdb376fbfc",
"assets/assets/images/B01075.jpg": "6499d60d67da0395c3a8730e697ca3d5",
"assets/assets/images/B01078.jpg": "e648bf17b4bc90259e535aa57c1ea653",
"assets/assets/images/B01028.jpg": "9221eb0dc3d2aa63103a0b1116d20a7b",
"assets/assets/images/PR019.jpg": "68c5754f97344fb7a388c6ce16d585fd",
"assets/assets/images/B01041P.jpg": "5554f65a843be8f3cba0a6dbcdc73ab3",
"assets/assets/images/B01072P.jpg": "2be5dc7c69ee6e14673378af93d68b39",
"assets/assets/images/B01087.jpg": "5e8099979c130c6c2df4d6d49ab2136d",
"assets/assets/images/D01006.jpg": "cbbc7dce941d35fb6f9c58c3175328f4",
"assets/assets/images/D05010.jpg": "09b7710b6414ec76c9d8f93d3636353e",
"assets/assets/images/B01093.jpg": "ecc4bf87c0b3ef4330fb97d515a87419",
"assets/assets/images/D04012.jpg": "d178ca542de6f1f9c86de134bb68e146",
"assets/assets/images/B01059.jpg": "a5fc625cfb921f4e0680247ac1ac065e",
"assets/assets/images/D03008.jpg": "c9678f10f95c5d76c9bd6c223f67e0f1",
"assets/assets/images/D05002.jpg": "9b5bd4e25f2bc20db86879b5157ce8c7",
"assets/assets/images/B01009P.jpg": "a0577e9e60bfeb3f5ad7e83663eba703",
"assets/assets/images/D02001.jpg": "9a69aada345027ba20acbb3460b168c3",
"assets/assets/images/B01025.jpg": "d38b4cde05b5d753d8f6b5c9bab03130",
"assets/assets/images/B01073P.jpg": "fdd2e8e1822e92a9bf780ad58ab20dc0",
"assets/assets/images/B01003.jpg": "887f911c5193ed8b24f9e0921da0b51f",
"assets/assets/images/PR012.jpg": "f65c7721fb1f842e83ffdc3fd977ad09",
"assets/assets/images/B01043P.jpg": "e7402a5f382f07bc2f634d7ea01cccda",
"assets/assets/images/PR003.jpg": "6fb5d8649cd5756f71267a75c0335859",
"assets/assets/images/B01008.jpg": "2892a494a7e3ddb9e7033a0fa2058385",
"assets/assets/images/D01005.jpg": "16d4fe5d441dc149a103818af5115fcf",
"assets/assets/images/B01071.jpg": "6d2ac1be933d9c355553487ce450b9c8",
"assets/assets/images/D02004.jpg": "ca7c499e0cf34c335e0e893ae9c7fa5d",
"assets/assets/images/B01054P.jpg": "7296a798025ace56a2a7d5df158b7a90",
"assets/assets/images/B01041.jpg": "9e07254cd7b4af3f791d830402331383",
"assets/assets/images/D04007.jpg": "ecd593016ab600dc4007296ca437a6af",
"assets/assets/images/D02003.jpg": "6b8728ac0d6013e6d1521bef7ccd1320",
"assets/assets/images/B01066.jpg": "f33dce0d672b77eb879d38960693b250",
"assets/assets/images/D03012.jpg": "bd0ca438cb6d9a6f0dae981a1dfaae3c",
"assets/assets/images/D03005.jpg": "4f415fcdf0c3d8b126d6dc5517d54324",
"assets/assets/images/PR005.jpg": "eb0a86bb11947bd1a752f37baa223493",
"assets/assets/images/B01036.jpg": "85988d00fe87c0ee9e03eb1487e19a7d",
"assets/assets/images/B01002P.jpg": "e638e66744c416d5cb715c2198456b3e",
"assets/assets/images/D03014.jpg": "3d7a99040bc238b229a566c4e3b5cbde",
"assets/assets/images/D04003.jpg": "799e64cbae80b19879b3a7cedbbabb25",
"assets/assets/images/B01069.jpg": "b455cc6f203c8d4a50c3711e6b5d5889",
"assets/assets/images/B01006P.jpg": "9f966197f05c8a8d5930276954bf89e5",
"assets/assets/images/D05004.jpg": "7adea99f6614836f4c7ff6414cc29357",
"assets/assets/images/B01062.jpg": "663cd108d27d245e000bbaa7cbba03d3",
"assets/assets/images/B01029.jpg": "c9b6d3afd43afb53c7fbe0a77b0f8522",
"assets/assets/images/D01014.jpg": "e5068bf22897b2eaa97b91d86b6f01f3",
"assets/assets/images/B01076P.jpg": "615b42e3d652ec8686fd180be6a27d2d",
"assets/assets/images/B01057P.jpg": "092ffada20d426f050f5986a390e7356",
"assets/assets/images/B01081.jpg": "af28c19b2551a168285a7636635beddc",
"assets/assets/images/PR021.jpg": "acb8c943d3c4d994a3366b2bda6cd03c",
"assets/assets/images/B01042.jpg": "3da969b15190d744fa15a4e775335a9f",
"assets/assets/images/D02013.jpg": "79cba1f15491eddac590651190953272",
"assets/assets/images/B01084P.jpg": "4813b14c004c09b1cda0f22f5fda87c0",
"assets/assets/images/D02005.jpg": "67d7f62fa32f081087a402887ea152b5",
"assets/assets/images/D01015.jpg": "73c5a00d59d254846be93184fc76cd9b",
"assets/assets/images/D02006.jpg": "a8685911481039be4e5c864048644a49",
"assets/assets/images/B01048P.jpg": "7022cbf8c4d323f9189f1e43a49989f5",
"assets/assets/images/B01070.jpg": "6c897c293243040e76f7f233d7950b3a",
"assets/assets/images/B01052.jpg": "088139b0f8970bf7182d0718b24f1ce3",
"assets/assets/images/B01027.jpg": "aaf58abe4677cd637cbf7e3eb2f4d1fd",
"assets/assets/images/B01086.jpg": "3014aeabaebe958ce4b5761698ea64e2",
"assets/assets/images/D03010.jpg": "7baabeab87942204382096f19b312a43",
"assets/assets/images/B01061P.jpg": "144ead6e3bdb0b183253d087f7a980ab",
"assets/assets/images/D02010.jpg": "51e569051b6176110610e599311d4124",
"assets/assets/images/D01001.jpg": "771001061ac722a3b8c6d61b34fe64ed",
"assets/assets/images/B01038P.jpg": "f7e539d1a958fd5ff19937bc07f3fc34",
"assets/assets/images/B01005P.jpg": "48e401698bccbfc8a5b57e295fc37b91",
"assets/assets/images/B01061.jpg": "3923f6629e6c5c387576e59f9746eccd",
"assets/assets/images/B01040P.jpg": "3e413b0a201f8568698f9e74e40a4239",
"assets/assets/images/B01079.jpg": "73335c66cbf749f06a61330c8e82d7bd",
"assets/assets/images/D05008.jpg": "91c10c88df60a4dd3d120d509f1e13a3",
"assets/assets/images/D04010.jpg": "cc64a9e4a1184ec198d0ab5bff1d23d5",
"assets/assets/images/B01035.jpg": "719256842971c201e1a26dbe590aefc3",
"assets/assets/images/D05013.jpg": "652c87d4feeaf8a8c8e7c86eb3cd36ed",
"assets/assets/images/B01096.jpg": "8749f33f79be401cb8c4abb25962db02",
"assets/assets/images/B01042P.jpg": "8579bf31a0eb01eb372e6684c1ec181e",
"assets/assets/images/B01047.jpg": "73286c3f4e9d52ddef48273b0abb99c1",
"assets/assets/images/B01098P.jpg": "5a11f48d836f9170d0c266dd5d520928",
"assets/assets/images/B01031P.jpg": "f29ca7fd336c0a0ae13a25758316d33c",
"assets/assets/images/B01081P.jpg": "908f0640ef928384577d357191289c3d",
"assets/assets/images/B01003P.jpg": "2d4e6f1e0e60a9d952e6eaab30a246a8",
"assets/assets/images/D04006.jpg": "fa174d7d7ab975672e3793de36b18653",
"assets/assets/images/D04014.jpg": "819f0ccd91f4609180f8a1c86a27ff2f",
"assets/assets/images/D02011.jpg": "c49e4a98b3b5990728830130fab7c1ef",
"assets/assets/images/B01010.jpg": "0bef6d96903723ef08fec6f6dde89812",
"assets/assets/images/D05001.jpg": "cede42c91a9cb6f45ed2c3e4be996d5e",
"assets/assets/images/B01019P.jpg": "78884697477a70162aab84a8b57da9c6",
"assets/assets/images/B01026.jpg": "e33b8f4197ae5540a1267c2bea94c3b4",
"assets/assets/images/B01030P.jpg": "33942d2c7845b23819e9e57409e0a56d",
"assets/assets/images/B01013P.jpg": "fb85d2f2ab7d0a892a33121534450bfe",
"assets/assets/images/B01023P.jpg": "c347df7575fdd560b9364489a041a681",
"assets/assets/images/D01004.jpg": "5ddd3e222a0c77af8b64e9ca794488a2",
"assets/assets/images/B01017.jpg": "c690e161642c0b31f44e76af8bf766f5",
"assets/assets/images/B01074.jpg": "887cf2e3bea691ac0a050cad8c1ced33",
"assets/assets/images/B01055.jpg": "a07b487323cc6f4e858e2db362d43922",
"assets/assets/images/D04005.jpg": "6e5532f9cef2cf32b5cfda4f6314cb6e",
"assets/assets/images/B01001.jpg": "6692becaf2dcbe472e9b986af6860e6a",
"assets/assets/images/D03003.jpg": "cb4eb577c91ddde1a562c46740c6a51f",
"assets/assets/images/D05012.jpg": "8cf3ebfe3437716ccc5a054e66ea022f",
"assets/assets/images/B01098.jpg": "0593fbd3719395a368cfd23f0ee532b2",
"assets/assets/images/icon-inspiration.png": "88f8de1d839c5c8ae5ed65d1f4ee1ff1",
"assets/assets/images/B01065.jpg": "320ee3e3e002bf5e22507386b6ec3636",
"assets/assets/images/D05015.jpg": "2c294b235645da45cdfc33bb59f8df42",
"assets/assets/images/B01013.jpg": "1f0543023c60bbabfd99a923fc4a2409",
"assets/assets/images/B01048.jpg": "c9c0b9afabbbeb8f8d608243dfc0c656",
"assets/assets/images/B01083.jpg": "57b9a4c0d9e5ed0c5759b54afe0e99fd",
"assets/assets/images/D05009.jpg": "36ca60aa68065cd1d6d9d7b8b225c198",
"assets/assets/images/D01009.jpg": "c5aa7d7b10bb893ef563479c70470da2",
"assets/assets/images/B01101.jpg": "9e224400e2ad49b97ab1ae4c79d3667c",
"assets/assets/images/B01051.jpg": "6ee6a81217512cefbb94e2543a03f214",
"assets/assets/images/B01057.jpg": "cbed9aae09d74466ade7a0b7c84d75ad",
"assets/assets/images/B01045.jpg": "ac39a42b440eadf25271097267bd294e",
"assets/assets/images/B01046.jpg": "f9fa1177b31cff5e6379bd174d4686c8",
"assets/assets/images/B01032.jpg": "f05d5b77a10bb0baf598123e2fe39860",
"assets/assets/images/B01102.jpg": "099a6728d7e3ef7dafe1392e58c0db28",
"assets/assets/images/B01033P.jpg": "d4968e68fa65557ad21dd96defd36b6f",
"assets/assets/images/B01016.jpg": "bcf1363380cad6e41498e27fb0c1e728",
"assets/assets/images/PR006.jpg": "cad21bd65fcb80d5940bad00ae6981cf",
"assets/assets/images/B01018.jpg": "02a5757df017e0e97daa35f1f4b56e23",
"assets/assets/images/D05006.jpg": "75756cb6062759a0567286b5f40cb41c",
"assets/assets/images/B01088.jpg": "f99825adb6fce02c427f6f97814b521d",
"assets/assets/images/B01073.jpg": "9a60e8e8dea2be0b4218dd84ad89d492",
"assets/assets/images/D03011.jpg": "db27f037520536308c22717c9dc33d48",
"assets/assets/images/B01024P.jpg": "888a3b0386f9759a724b354aec6bdf32",
"assets/assets/images/PR018.jpg": "405da1437d536eec42b8739cfcb5be24",
"assets/assets/images/B01097P.jpg": "3c0ae3cac1730386809435d13fa75a84",
"assets/assets/images/D04016.jpg": "321777fab19000550385c7171230c798",
"assets/assets/images/D03016.jpg": "aac228c4251a1e2196d4946918f97f67",
"assets/assets/images/B01072.jpg": "9f75246dd04f81cd79d65107e236fba6",
"assets/assets/images/B01006.jpg": "e2fee74f44ce00483c229800588213ad",
"assets/assets/images/D03001.jpg": "62d831dacdb1bfdf43a8a9c69fe0344a",
"assets/assets/images/D03004.jpg": "07b623a19c92818cdc5742fc4237ddee",
"assets/assets/images/B01021.jpg": "d78344d542e6944d73434df906557ece",
"assets/assets/images/B01085.jpg": "58f7b7ccb9207fe6e705d6689ad86bc7",
"assets/assets/images/D01016.jpg": "a166cb4df2bff092dcc7c5a897a0d5dc",
"assets/assets/images/B01065P.jpg": "9f4fdb9c76c54614c362b774e5c8ac8c",
"assets/assets/images/D01003.jpg": "fa9b6e2edc760e26a8bbde151cfc727d",
"assets/assets/images/D03006.jpg": "2c768039673ffd542005f3af0d9103cb",
"assets/assets/images/B01097.jpg": "c4d9a8fc495d66d2046692f38f61d756",
"assets/assets/images/D03015.jpg": "0d0512dea61127304a8956f1343351ca",
"assets/assets/images/B01095.jpg": "f5a70255410572428091923393a01b59",
"assets/assets/images/B01054.jpg": "43b3b4374cbda40ea4d740c6af37e3ca",
"assets/assets/images/B01079P.jpg": "ca1c6e929fea0584f5dc04a4d886b262",
"assets/assets/images/D05007.jpg": "de634a7dfeab091a7718710ead781555",
"assets/assets/images/PR016.jpg": "9bd557ec709ff90edda5deeee35f8659",
"assets/assets/images/PR020.jpg": "f409a2efbf290d966d52f2aeb8d56dd4",
"assets/assets/images/PR017.jpg": "56b89e8ee80106efd4c2a352b33d6028",
"assets/assets/images/B01040.jpg": "de3ca526568b10e24d4bc33aaa3e25e7",
"assets/assets/images/D02012.jpg": "4ecc3949790cf162aa170742607e950f",
"assets/assets/images/B01092.jpg": "bb225e7171be0db0c65b1d90f6fa0401",
"assets/assets/images/B01044.jpg": "0c4f70ffbdd2cc3f0891ee9f5b2fa59d",
"assets/assets/images/B01023.jpg": "290ad7b3c2e7e9829fdf6932e8270e5f",
"assets/assets/images/D05005.jpg": "7d9a7840246e0d920548a05e21a6beb1",
"assets/assets/images/B01010P.jpg": "a469e32351961fd83a3602471a1b82d4",
"assets/assets/images/B01016P.jpg": "536447c068943287010fc94d281f7cb3",
"assets/assets/images/D04008.jpg": "2d17d6a7b9b8e94304eb7a86125a24ea",
"assets/assets/images/B01025P.jpg": "20c3c4b947e2037357ad3c02773f9943",
"assets/assets/images/B01090P.jpg": "c6028d4472c4c0b7a983cdf07e27be3a",
"assets/assets/images/B01053.jpg": "064d43a7ba1da9a89f158f0a6b262751",
"assets/assets/images/B01066P.jpg": "9746103722cee780cb2bb3741efc0383",
"assets/assets/images/B01043.jpg": "99de789141475aa665be139e9bf31d76",
"assets/assets/images/B01068.jpg": "022385d0a845a63ded2c4aaa4986e86a",
"assets/assets/images/B01034P.jpg": "e43845e77c1caf2a424836711826e634",
"assets/assets/images/D05011.jpg": "7e20b25ca40dbd514a3901a1d1fe834d",
"assets/assets/images/D04009.jpg": "e1f7adea6d4f29c2801fc89211cd61b3",
"assets/assets/csv/conan-cardgame%2520-%2520cardsByNumber2.csv": "4835e04ebea0f2fa6610f025a525d669",
"assets/assets/csv/conan-cardgame%2520-%2520productContents.csv": "5964d76ede4d2dcfff467b336b25c581",
"assets/NOTICES": "28278a09a9e750d87b9c7d45d93c2bdd",
"assets/AssetManifest.bin": "9860577625a69717eb9ad8ee46b5eb16",
"assets/FontManifest.json": "818cc7449afde41483f96dd97522e13d",
"flutter.js": "383e55f7f3cce5be08fcf1f3881f585c"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
