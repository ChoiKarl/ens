import 'package:ens/page/select_page_day/select_page_day_item.dart';
import 'package:ens/page/select_page_day/select_page_day_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SelectPageOrDayPage extends StatefulWidget {
  const SelectPageOrDayPage({Key? key}) : super(key: key);

  @override
  _SelectPageOrDayPageState createState() => _SelectPageOrDayPageState();
}

class _SelectPageOrDayPageState extends State<SelectPageOrDayPage> {
  SelectPageOrDayViewModel viewModel = SelectPageOrDayViewModel();

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('选中页数或者天数')),
      body: ChangeNotifierProvider<SelectPageOrDayViewModel>.value(
        value: viewModel,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              selectPageWidget(),
              SizedBox(height: 20),
              selectDayWidget(),
              Expanded(child: Container()),
              confirmButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget selectPageWidget() {
    return Selector<SelectPageOrDayViewModel, int>(
      selector: (context, vm) => vm.selectedPages.length,
      builder: (context, _, __) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '选择页数',
              style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Wrap(
              children: viewModel.pages
                  .map((e) => GestureDetector(
                        onTap: () {
                          viewModel.selectPage(e);
                        },
                        child: SelectPageItemWidget(
                          string: e.toString(),
                          highlight: viewModel.selectedPages.contains(e),
                        ),
                      ))
                  .toList(),
            ),
          ],
        );
      },
    );
  }

  Widget selectDayWidget() {
    return Selector<SelectPageOrDayViewModel, int>(
      selector: (context, vm) => vm.selectedDays.length,
      builder: (context, _, __) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '选择日期',
              style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Wrap(
              children: viewModel.days
                  .map((e) => GestureDetector(
                        onTap: () {
                          viewModel.selectDay(e);
                        },
                        child: SelectPageItemWidget(
                          string: e.toString(),
                          highlight: viewModel.selectedDays.contains(e),
                        ),
                      ))
                  .toList(),
            ),
          ],
        );
      },
    );
  }

  Widget confirmButton() {
    return SafeArea(
      child: Consumer<SelectPageOrDayViewModel>(
        builder: (ctx, vm, _) {
          bool highlight = vm.selectedDays.isNotEmpty || vm.selectedPages.isNotEmpty;
          return Container(
            alignment: Alignment.center,
            height: 44,
            width: double.infinity,
            margin: EdgeInsets.only(bottom: 20),
            padding: EdgeInsets.symmetric(horizontal: 20),
            decoration:
                BoxDecoration(color: highlight ? Colors.pink : Colors.grey, borderRadius: BorderRadius.circular(22)),
            child: Text(
              '选择',
              style: TextStyle(
                color: highlight ? Colors.white : Colors.black,
                fontSize: 20,
              ),
            ),
          );
        },
      ),
    );
  }
}