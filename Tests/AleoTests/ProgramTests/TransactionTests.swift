//
//  TransactionTests.swift
//  
//
//  Created by Nafeh Shoaib on 11/22/23.
//

import XCTest

@testable import Aleo

final class TransactionTests: XCTestCase {
    
    let transactionString = "{\"type\":\"execute\",\"id\":\"at1rh04nydu2m07n9wm3pugmlaqh7775lfuawa86ed4eymv2q9wkc9qahtx66\",\"execution\":{\"transitions\":[{\"id\":\"au1xe07pjnw6970k9lh0rfvpdnudcz0gcyy5qmv2efp3qrdxkkaj5rseklkfk\",\"program\":\"credits.aleo\",\"function\":\"transfer_public\",\"inputs\":[{\"type\":\"public\",\"id\":\"6830040130268084683056203786650856838291629627526850542328121029117462649106field\",\"value\":\"aleo1q6qstg8q8shwqf5m6q5fcenuwsdqsvp4hhsgfnx5chzjm3secyzqt9mxm8\"},{\"type\":\"public\",\"id\":\"3522622156280992546879723962866054193411134839313162974822034464277507937156field\",\"value\":\"1u64\"}],\"outputs\":[{\"type\":\"future\",\"id\":\"6287946476679554718269040652777030908815963134664267470652690289159774741065field\",\"value\":\"{\\n  program_id: credits.aleo,\\n  function_name: transfer_public,\\n  arguments: [\\n    aleo1q6qstg8q8shwqf5m6q5fcenuwsdqsvp4hhsgfnx5chzjm3secyzqt9mxm8,\\n    aleo1q6qstg8q8shwqf5m6q5fcenuwsdqsvp4hhsgfnx5chzjm3secyzqt9mxm8,\\n    1u64\\n  ]\\n}\"}],\"tpk\":\"1124897318163588088766079717854473596955076479615330099205126740598806373414group\",\"tcm\":\"5379517959399780344431681060960827894902462418861353186658003065156167347920field\"}],\"global_state_root\":\"sr1tml46c266j4gzv9qpk0adkt6tkl4mjq7s7supuy8dmv9lq09j5zsd5eqsz\",\"proof\":\"proof1qyqsqqqqqqqqqqqpqqqqqqqqqqq9eqfncmzufz24n5xvfk2yy2lm7k0jh2y23yj5ssekln7h2nmlc62mnjwe794rn5dxwwf7unaamfyqqxzhaqnm3xws740w8gwt3dt22r5l43xa9rhn6yc0vpuu46mal3a86n3qmc8yegeh8afyetmz7rs8mq8766v6rryrnhnhl8xudl3tr7rk50f0lrz36cjwp0vpg46fzq4wv9n3eglkn9ztx4kzhh9d0wmqgcqvv2e6lrnaqp9cafaxjh88pzfjn26vyq3y50hazf9c9ysc84x33mn4wculvu67z2utduq5qyy933qqtn7u5rtsztmtakuu2japhf7qcvrc663vkuk9s0twufhh42d2kk3ukf00290jxqe9qnfwr3txz05spv7tp88e7dduldq5wwulae6wm3nztzmzdjrypfz08awuvkzuale9h96hy8nyjt2znntu20c4xemlsyqpfn6ce0sv5nn5shxx2up8kw9xtyle3pcyaum9hsw29ctqcjqmn53j7dxy6ep37cfvnflxqctpuqqgtgss9tp5rzg4vp46fw8nsjztdum9xm2xp0d8hglr2v8fuyh38afsw0kymhn2lznaag7cwud0guqtpdn2l2zgn4sjg7n0gdd0ueg5ujeydmqkxx8dp9a4g456q4jvukjt2cycuvef5slqt3hwnuh6ez5qys785f6xw8xsc5ns6ee3la7rf3p24mkpeakd5ay73q30m3qezux2xzqv35zy8jclv7lxpvcnej8tkstf00fzh9l44q382hpt8eejyp3vs3pq2n3n2e0eq30zatqyrvqsqs4cllynrcytc6v9seuqgtdnzy5rr3vcwwhlrxzm2h66e9q4z94r7zpnkm6xt4yermvys6twaw6sncwt5x64qjdnatddjpeh97uszkvamu6kmltu2unnq2mq4kverfsg8ncpvkhvre77yjhgmw5nevw2az0s2dwr6navrchn7pdwkmmjcu9dedn40jacflfeld7agznzjw3cpwewyhhufu49l5ttjpqrcpl3yzn2m3h3mgq5ea4xedf8370lmmr4ansr60x5d0qwrx08n6r8qe6vq2jlk5t8fey0mcgteef0hxe84vm5khehwjr9vu7p839jpysctaz3z88zcum9nw6z04gqvj3dqvldndldatwknwu4plnlpsqxhg5x8qc0qvqqqqqqqqqqqf57wtv2gucqnx8n0ejkhtywfmxrvewes27sr0ng67f7900w4kga6ztwnzhvtpd4rv0qqhjfmkwssqqvzr0sf8p6hsda4wgak42gtdcxfkf8xfywmdpgecqhxcptdrtvluv9adsn8vc5vwds4kd54thnaggqqxz3799lcez0f8v2xencv2z76fwvgp52wrnh5qyjtteckn2nhlhq8e60eq358pw2lezf74flec2wp4e8gvk5xtrwwy36j36axmy9pmh9kwa9cnsykxzwx38kdtqhnqytsyqqefuv9d\"},\"fee\":{\"transition\":{\"id\":\"au1etgu5md0jd6r3ddyyyg2sr63r5t07tpyaz452redx4rkzjq0dsqqhpp390\",\"program\":\"credits.aleo\",\"function\":\"fee_public\",\"inputs\":[{\"type\":\"public\",\"id\":\"6202819827443625105167501394613513736747919402680330317066933896152810974533field\",\"value\":\"263388u64\"},{\"type\":\"public\",\"id\":\"562300717734796433896686862094601391435687829906952149841892194225660591975field\",\"value\":\"10000u64\"},{\"type\":\"public\",\"id\":\"7883237601094350949043895657366086123587113448531301549046231111645620087265field\",\"value\":\"2003683512649368822747780913503982093177226997476011687299266369052228066725field\"}],\"outputs\":[{\"type\":\"future\",\"id\":\"4003143084174123056047141027259441734516045162674697571360224656380933228034field\",\"value\":\"{\\n  program_id: credits.aleo,\\n  function_name: fee_public,\\n  arguments: [\\n    aleo1q6qstg8q8shwqf5m6q5fcenuwsdqsvp4hhsgfnx5chzjm3secyzqt9mxm8,\\n    273388u64\\n  ]\\n}\"}],\"tpk\":\"6391092584190750271169179247921812490330238842823180033518604373506188720330group\",\"tcm\":\"1287501176934805652296722632500653287206667978232913581134582827412687172453field\"},\"global_state_root\":\"sr1tml46c266j4gzv9qpk0adkt6tkl4mjq7s7supuy8dmv9lq09j5zsd5eqsz\",\"proof\":\"proof1qyqsqqqqqqqqqqqpqqqqqqqqqqq0vc7dct0xgm89qpdtq9cljzp27k4u0fa0nz0hd8nqlsgjkcj08evn2840dj4k4ygh8tlce383kmqqq9suy0upadgravumuq32nne0zd6673xwj74vunuugsyv40q5ypfjkmdt7t2dsl60ahqpquh5scecyqq6xcz9v72n84l2xl62c79vdc6h99vm5z4ag2mzt5j8lng4dfscxlf9ka067nyu05yh0xq46s7fhzqtf3eadr4kd4fpqqgmkzaj348juxuxqjexv5xtlyl38p6cu5lnn4wylg0w3a02wj4atm5k8rumsaup6dsk6lg9l2r7y3x0cjgw3fc9c9pqnkm86p8udhsjrxxmtp2gaevawyrezqk58x2hwfrgs83f2zhqqhrlxrq6642xjvj02mcj9llucyu234zd04m3hpl05hzu4fx2cuu8wxh74uw0h4dsq8l7g9qm3cn7s87d6drs29j4rexrfwjlnn4hsuvt09elcjtju9ll44vkv004hnmc3rx2gsjwxqgrhxc0w0prntkvzqpmtk33a6fq0v0adeagnc30c76va997pfe37d48z2yvjg9npnvu7xq56tzu32gsnvq8mxnu86zvj5qt2w268h4k9f20smjy2256n6tl7v3m0zxvaqjg8qgwvucwr5r0eufxn7h48eqx6zxawhr5l03jtkgqccqkn5qc67ds9hwn8xrh8hwahu8xf8tykuaq0m7kqm4ww3uzncqtnjxnxgswkj8zecqjvj0p5cs9muejvzgfr6dfr6ekmxm62quecp5q40j9n5vaflwjmwmme5n29ejnf4gfq6yfjt0gdf95mecszfprqjuyr7hvn93qk5qlhcdve9e9sh5q42wj5y74v50jycsp5zuy76es7669stqf3wl0su6zkd44yuwu8tglqdk62mmmjx9590qxcftuqzsthvky3pp0pzpmfelawh0snx439xq5m47zt4u4tf3qga0l5zasvs95n5yulrumfj5uyxs3ssnf47vnh7v2xxmetc46gml2hxwtzsf5uykwdg36l5xxfe9zyn3fzv58vk4hddudkm93plkkqszl956aat24q55tfd5cvmxyy4vu4pg7lvrztf6zm8mpa74ruy8f7vzescnct06qwtf06tygpqya32ehfh23crr9s0s6g8dvzwaq9k26jq0qqk287ps8qvqqqqqqqqqqqn3e0c3qnwqq9pcuczyc53yy7qrya5gapevrkpxf8tm7mmeg8ujh88ru7lj24j0d9almx5uherfysqqwdy8z5kr7ky8qhz4z4ze8qx8mlcd5ksxs7vdpktn2nz3437yejegtu0k6u68up4spsfhgmt9z03vqq9fujl8u73uquc8xjpqqpvwr8dsf4zy3s5p2n43w7gh6kte0luxs76pmkhns42fkktusftt4ymyw083c580awfx97zeq76wyp3x2fn3lmeepwpkva2ms9u757yp2mj62qqqqsuydxg\"}}"
    
    let transactionID = "at1rh04nydu2m07n9wm3pugmlaqh7775lfuawa86ed4eymv2q9wkc9qahtx66"


    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testTransactionStringConstructorAndAccessorMethods() throws {
        let transaction = Transaction(transactionString)!
        let id = transaction.id
        let type = transaction.type
        
        let recoveredString = transaction.toString()
        
        XCTAssertEqual(id, transactionID)
        XCTAssertEqual(type, "execute")
        XCTAssertEqual(recoveredString, transactionString)
    }
}
