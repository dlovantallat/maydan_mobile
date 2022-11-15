import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../utilities/app_utilities.dart';

class ItemDetail extends StatefulWidget {
  const ItemDetail({Key? key}) : super(key: key);

  @override
  State<ItemDetail> createState() => _ItemDetailState();
}

/*
FlexibleSpaceBar(
            title: Text("ss"),

            background: Image.network(
              'https://images.unsplash.com/photo-1527153857715-3908f2bae5e8?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1988&q=80',
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const Image(
                image: AssetImage(mainProfileBottomNavigationSvg),
                fit: BoxFit.cover,
              ),
            ),
          ),
 */
class _ItemDetailState extends State<ItemDetail> {
  final ScrollController _sliverScrollController = ScrollController();
  var isPinned = false;

  @override
  void initState() {
    super.initState();

    _sliverScrollController.addListener(() {
      if (!isPinned &&
          _sliverScrollController.hasClients &&
          _sliverScrollController.offset > kToolbarHeight) {
        setState(() {
          isPinned = true;
        });
      } else if (isPinned &&
          _sliverScrollController.hasClients &&
          _sliverScrollController.offset < kToolbarHeight) {
        setState(() {
          isPinned = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(controller: _sliverScrollController, slivers: [
        SliverAppBar(
          expandedHeight: 200,
          pinned: true,
          stretch: true,
          flexibleSpace: Stack(
            children: [
              Container(
                color: Colors.white,
                width: double.infinity,
                child: Padding(
                  padding:
                      EdgeInsetsDirectional.only(bottom: isPinned ? 0 : 16),
                  child: Image.network(
                    'https://images.unsplash.com/photo-1527153857715-3908f2bae5e8?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1988&q=80',
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Image(
                      image: AssetImage(mainProfileBottomNavigationSvg),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: AlignmentDirectional.bottomEnd,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Stack(
                      alignment: AlignmentDirectional.center,
                      children: [
                        SvgPicture.asset(
                          height: 50,
                          favBoarderSvg,
                          semanticsLabel: '',
                        ),
                        SvgPicture.asset(
                          shareSvg,
                          semanticsLabel: '',
                        ),
                      ],
                    ),
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.only(start: 8, end: 8),
                      child: Stack(
                        alignment: AlignmentDirectional.center,
                        children: [
                          SvgPicture.asset(
                            height: 50,
                            favBoarderSvg,
                            semanticsLabel: '',
                          ),
                          SvgPicture.asset(
                            height: 24,
                            mainFullFavoriteBottomNavigationSvg,
                            semanticsLabel: '',
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
        SliverToBoxAdapter(
          child: Column(
            children: [],
          ),
        )
      ]),
    );
  }
}
