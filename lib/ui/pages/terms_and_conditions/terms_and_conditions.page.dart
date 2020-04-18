import 'package:flutter/material.dart';
//import 'package:flutter_html_textview/flutter_html_textview.dart';

class TermsAndConditionsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new TermsAndConditionsPageState();
  }
}

class TermsAndConditionsPageState extends State<TermsAndConditionsPage> {
  String data = "";
//      "<style>p, h3, li, h5{margin: 20px; text-align: justify; font-family: Georgia, serif;}h3, h5{font-weight: bolder;}ul, ol{margin-left: -20px;}</style> <h3> Terms & Conditions </h3> <p> THE FOLLOWING TERMS & CONDITIONS APPLY TO YOUR ACCESS AND THE USE OF INETSOHO RESOURCES SDN BHD WEBSITE (WWW.INETSOHO.COM), ITS MOBILE APPLICATION (SNS APP) AND THE MOBILE MESSAGING SERVICES. BY ACCESSING ANY PAGE OF THIS WEBSITE, AND/OR USING THE MOBILE APPLICATION AND/ OR SERVICES, YOU AGREE TO BE BOUND BY THESE TERMS AND CONDITIONS WITHOUT LIMITATION OR QUALIFICATION. IF YOU DO NOT ACCEPT THESE TERMS AND CONDITIONS, PLEASE IMMEDIATELY DISCONTINUE YOUR ACCESS TO THIS WEBSITE AND/OR MOBILE APPLICATION AND/ OR USE OF THE MOBILE MESSAGING SERVICE. </p><h5> 1. General </h5> <p> The term \"iNetSOHO\" as used in these Terms and Conditions refers to iNetSOHO Resources Sdn Bhd <sub>1238083-P</sub>, a Malaysian mobile and e-commerce solution innovator located at C-21-3A, Trillion, 338, Jalan Tun Razak, 50400 Kuala Lumpur, Malaysia. The term \"iNetSOHO\" may also be extended to refer iNetSOHO subsidiaries, associate or affiliate companies, or assigned agent, either individually and/or collectively as the context requires. </p><p> All products and services of iNetSOHO and its partners herein provided are subject to the terms and conditions of the applicable agreements governing their use. These Terms and Conditions are meant to regulate subscriber/ user access to strictly www.snsapp.co and SNS App. </p><p> Specifically, the information, material, functions and content on SNS App may be changed from time to time with or without notice at iNetSOHO's absolute discretion. The continued access or use of the rich media messaging application SNS App herein subsequent to any such change will be deemed as acceptance by subscribers/ users to those changes. </p><h5> 2. Disclaimer </h5> <p> The materials and information on www.inetsoho.com and SNS App, including but not limited to information, data, text, graphics, audio, video, links or other items, are provided by iNetSOHO on an \"as is\" and \"as available\" basis. There may be references to material and information provided by third parties. </p><p> iNetSOHO does not make any express or implied warranties, representations or endorsements including but not limited to any warranties of title, non-infringement, merchantability, usefulness, operation, completeness, currentness, accuracy, satisfactory quality, reliability, fitness for a particular purpose, the material, information and/or functions therein and expressly disclaims liability for errors and omissions in such materials, information and/or functions. </p><p> Without derogation of the above and/or the terms and conditions of the applicable agreements governing iNetSOHO’s products like the mobile messaging application, SNS App and the corresponding mobile messaging service accessed via SNS App, reasonable measures will be taken by iNetSOHO to ensure the accuracy and validity of all information relating to transactions and products of iNetSOHO which originate exclusively from iNetSOHO. </p><p> Further the iNetSOHO does not warrant or represent that access to the whole or part(s) of our website and mobile messaging application, SNS App, that the materials, information and/or functions contained therein will be provided uninterrupted or free from errors or that any identified defect will be corrected, or that there will be no delays, failures, errors or loss of transmitted information, that no viruses or other contaminating or destructive properties will be transmitted or that no damage will occur to your computer system, smartphone or mobile device. </p><p> The materials, information and functions provided shall not under any circumstances be considered or construed as an offer or solicitation to sell, buy, give, take, issue, allot or transfer, or as the giving of any advice in respect of shares, stocks, bonds, notes, interests, unit trusts, mutual funds or other securities, investments, loans, advances, credits or deposits in any jurisdiction. </p><p> More specifically, subscribers/ users of our mobile messaging application, SNS App, are responsible to evaluate the quality, adequacy, completeness, currentness and usefulness of all content, advice, opinions and other information obtained or accessible while using SNS App for their messaging purposes. </p><h5> 3. Links </h5> <p> Links from or to other mobile applications on Google Play or Apple Store or any websites not owned and operated by iNetSOHO are meant for convenience only. </p><p> Such links to these resources are owned and operated by third parties and as such are not under the control of the iNetSOHO. Therefore iNetSOHO shall not be responsible and makes no warranties in respect of the contents of those mobile applications, the third parties named therein or their products and services. Furthermore, such links are not to be considered an endorsement or verification or approval of such mobile services or mobile applications. </p><p> You also grant us the right to disclose to third parties certain Registration Data about you. The information we obtain through your use of this site, including your Registration Data, is subject to our Privacy Policy, which is specifically incorporated by reference into these Terms of Use. </p><h5> 4. Copyright </h5> <p> Unless otherwise indicated, the copyright on SNS App and our website, its contents, including but not limited to the text, images, graphics, sound files, animation files, video files, and their arrangement, are the property of the iNetSOHO, and are protected by applicable Malaysian and international copyright laws. </p><p> No part or parts of our mobile application, SNS App and our website may be modified, copied, distributed, retransmitted, broadcast, displayed, performed, reproduced, published, licensed, transferred, sold or commercially dealt with in any manner without the express prior written consent of the iNetSOHO. </p><p> Any unauthorised reproduction, retransmission or other copying or modification of any of the contents of the iNetSOHO's SNS App and website may be in breach of statutory or common law rights which could be the subject of legal action. </p><p> iNetSOHO disclaims all liability which may arise from any unauthorised reproduction or illegal use of SNS App. </p><h5> 5. Trademarks </h5> <p> All trademarks, service marks, and logos displayed on SNS App and on our website are the property of the iNetSOHO. The use of any trademarks, service marks, and logos belonging to third party proprietors will be identified and the corresponding credit acknowledged. </p><p> Unless iNetSOHO grants written consent or the relevant third party proprietor of any of the trademarks, service marks or logos appearing on SNS App has been obtained, no license or right is granted to any party to use, download, reproduce, copy or modify such trademarks, services marks or logos. </p><p> Similarly, unless iNetSOHO has granted prior written consent or the relevant proprietor has been obtained, no such trademark, service mark or logo may be used as a link or to mark any link to the INetSOHO's SNS App, website or any other service belonging and operated by iNetSOHO. </p><h5> 6. Liability Exclusion </h5> <p> iNetSOHO and/or its associate/ affiliate companies and/or partners herein shall in no event be liable for any loss or damages howsoever arising whether in contract, tort, negligence, strict liability or any other basis, including without limitation, direct or indirect, special, incidental, consequential or punitive damages, or loss profits or savings arising in connection with your access or use or the inability to access or use our rich media messaging service on SNS App or iNetSOHO’s website, reliance on the information contained in SNS App or our website, any technical, hardware or software failure of any kind, the interruption, error, omission, delay in operation, computer viruses, or otherwise. This exclusion clause shall take effect to the fullest extent permitted by law. </p><h5> 7. Indemnity Clause </h5> <p> Subscribers/ users of our rich media messaging service on SNS App hereby irrevocably agree to indemnify and keep indemnified iNetSOHO from all liabilities, claims, losses and expenses, including any legal fees that may be incurred by iNetSOHO in connection with or arising from: </p><ul style=\"list-style-type:disc\"> <li> use or misuse of our rich media messaging service and any others services provided herein, or </li><li> your breach of these terms and conditions howsoever occasioned, or </li><li> any intellectual property right or proprietary right infringement claim made by a third party against iNetSOHO in connection with the use of our rich media messaging service on SNS App. </li></ul> <h5> 8. Termination </h5> <p> We reserve the right to terminate and/or suspend your access and use the rich media messaging service on SNS App at any time, for any reason. In particular, and without limitation, iNetSOHO may terminate and/or suspend your access should you violate any of these terms and conditions, or violate the rights of the iNetSOHO, of any other user, or of any third party. </p><h5> 9. Miscellaneous </h5> <p> The failure of iNetSOHO to exercise or enforce any right or provision of these terms and conditions shall not constitute a waiver of such right or provision. </p><p> If any part of these terms and conditions is determined to be invalid or unenforceable pursuant to applicable law, then the invalid and unenforceable provision will be deemed superseded by a valid, enforceable provision that most closely matches the intent of the original provision and the remainder of the other provisions of the terms and conditions shall continue in full force and effect. </p><p> Any rights not expressly granted herein are reserved. </p><h5> 10. Law and Jurisdiction </h5> <p> These terms and conditions are governed by and are to be construed in accordance with the Laws of Malaysia. </p><p> By accessing our website, www.sns.co, downloading our rich media mobile messaging application, SNS App, and/or using the rich media messaging services provided by iNetSOHO, you hereby consent to the exclusive jurisdiction of the Malaysian courts in Kuala Lumpur, Malaysia in all disputes arising out of or relating to the use of this website. </p><p> iNetSOHO makes no representation the materials, information, functions and/or services provided on our website and mobile messaging application are appropriate or available for use in jurisdictions other than Malaysia. </p><br><br><br><p> iNetSOHO Resources Sdn Bhd is compliant with the requirements of Personal Data Protection Act 2010 and Malaysia Communications and Multimedia Act 1998. </p><br><br><p> <i> Last updated: November 26, 2018 </i> </p>";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Terms and Conditions'),
        ),
        body: SingleChildScrollView(
          child:  Text('Terms and Conditions')//HtmlTextView(data: data),
        ));
  }
}