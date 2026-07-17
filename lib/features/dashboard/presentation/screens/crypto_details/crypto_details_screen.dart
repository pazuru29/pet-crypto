import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_crypto/application/localization/s.dart';
import 'package:pet_crypto/application/ui/alert_helper.dart';
import 'package:pet_crypto/features/dashboard/presentation/bloc/crypto_details/crypto_details_bloc.dart';
import 'package:pet_crypto/features/dashboard/presentation/screens/crypto_details/widgets/crypto_info_view.dart';
import 'package:pet_crypto/widgets/app_title.dart';
import 'package:pet_crypto/widgets/error_view.dart';
import 'package:pet_crypto/widgets/loading_view.dart';

class CryptoDetailsScreen extends StatefulWidget {
  final String? id;

  const CryptoDetailsScreen({super.key, required this.id});

  @override
  State<CryptoDetailsScreen> createState() => _CryptoDetailsScreenState();
}

class _CryptoDetailsScreenState extends State<CryptoDetailsScreen> {
  late final CryptoDetailsBloc _cryptoDetailsBloc;

  @override
  void initState() {
    _cryptoDetailsBloc = context.read<CryptoDetailsBloc>();
    _cryptoDetailsBloc.add(CryptoDetailsInitEvent(id: widget.id));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            AppTitle(title: S.of(context).cryptoDetailsTitle, secondary: true),
            Expanded(
              child: BlocConsumer<CryptoDetailsBloc, CryptoDetailsState>(
                listener: (context, state) {
                  if (state.alertMessage != null) {
                    AlertHelper.showSnackBar(context, state.alertMessage!);
                  }
                },
                builder: (context, state) => switch (state.status) {
                  .initial || .loading => LoadingView(),
                  .error => ErrorView(
                    code: state.errorCode,
                    onTryAgain: () {
                      _cryptoDetailsBloc.add(
                        CryptoDetailsInitEvent(id: widget.id),
                      );
                    },
                  ),
                  .loaded => CryptoInfoView(
                    info: state.info!,
                    onLinkTap: (link) => _cryptoDetailsBloc.add(
                      CryptoDetailsOpenLinkEvent(link: link),
                    ),
                  ),
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
