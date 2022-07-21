import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:polkawallet_sdk/api/types/txInfoData.dart';
import 'package:polkawallet_sdk/plugin/index.dart';
import 'package:polkawallet_sdk/storage/keyring.dart';
import 'package:polkawallet_sdk/utils/i18n.dart';
import 'package:polkawallet_ui/components/v3/back.dart';
import 'package:polkawallet_ui/components/v3/button.dart';
import 'package:polkawallet_ui/pages/scanPage.dart';
import 'package:polkawallet_ui/utils/i18n.dart';
import 'package:qr_flutter_fork/qr_flutter_fork.dart';

class QrSenderPageParams {
  QrSenderPageParams(this.txInfo, this.params, {this.rawParams});
  final TxInfoData txInfo;
  final List? params;
  final String? rawParams;
}

class QrSenderPage extends StatefulWidget {
  const QrSenderPage(this.plugin, this.keyring, {Key? key}) : super(key: key);
  final PolkawalletPlugin plugin;
  final Keyring keyring;

  static const String route = 'tx/uos/sender';

  @override
  createState() => _QrSenderPageState();
}

class _QrSenderPageState extends State<QrSenderPage> {
  Uint8List? _qrPayload;

  Future<Uint8List?> _getQrCodeData(BuildContext context) async {
    if (_qrPayload != null) {
      return _qrPayload;
    }

    final QrSenderPageParams args =
        ModalRoute.of(context)!.settings.arguments as QrSenderPageParams;

    final Map? res = await widget.plugin.sdk.api.uos
        .makeQrCode(args.txInfo, args.params!, rawParam: args.rawParams);

    debugPrint('make qr code');

    setState(() {
      _qrPayload =
          Uint8List.fromList(List<int>.from(Map.of(res!['qrPayload']).values));
    });
    return _qrPayload;
  }

  Future<void> _handleScan(BuildContext context) async {
    final res = (await Navigator.of(context).pushNamed(ScanPage.route))
        as QRCodeResult?;
    if (res != null && res.type == QRCodeResultType.hex) {
      if (!mounted) return;
      Navigator.of(context).pop(res.hex);
    }
  }

  @override
  Widget build(BuildContext context) {
    final dic = I18n.of(context)!.getDic(i18n_full_dic_ui, 'common')!;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
          title: Text(dic['tx.qr']!),
          centerTitle: true,
          leading: const BackBtn()),
      body: SafeArea(
        child: FutureBuilder(
          future: _getQrCodeData(context),
          builder: (_, AsyncSnapshot<Uint8List?> snapshot) {
            return ListView(
              padding: const EdgeInsets.only(top: 16),
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    snapshot.hasData
                        ? QrImage(
                            data: '',
                            rawBytes: snapshot.data,
                            size: screenWidth - 24,
                            foregroundColor:
                                Theme.of(context).textTheme.headline1?.color,
                          )
                        : const CupertinoActivityIndicator(),
                    Visibility(
                        visible: snapshot.hasData,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Button(
                            icon: SvgPicture.asset(
                              'packages/polkawallet_ui/assets/images/scan.svg',
                              width: 28,
                              color: Theme.of(context).cardColor,
                            ),
                            title: dic['uos.scan'] ?? "",
                            onPressed: () {
                              _handleScan(context);
                            },
                          ),
                        ))
                  ],
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
