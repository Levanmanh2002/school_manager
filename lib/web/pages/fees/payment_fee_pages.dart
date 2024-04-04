import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:school_web/web/constants/style.dart';
import 'package:school_web/web/pages/dashboard/config/responsive.dart';
import 'package:school_web/web/pages/home/view/mobile/widget/title_tab_widget.dart';
import 'package:school_web/web/utils/assets/icons.dart';
import 'package:school_web/web/widgets/custom_text_widgets.dart';

class PaymentFeePages extends StatefulWidget {
  const PaymentFeePages({super.key});

  @override
  State<PaymentFeePages> createState() => _PaymentFeePagesState();
}

class _PaymentFeePagesState extends State<PaymentFeePages> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _mssvController = TextEditingController();

  final searchController = TextEditingController();
  final historyController = TextEditingController();
  final ValueNotifier<bool> isClearVisible = ValueNotifier<bool>(false);
  final ValueNotifier<bool> isClearHistoryVisible = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      isClearVisible.value = searchController.text.isNotEmpty;
    });
    historyController.addListener(() {
      isClearHistoryVisible.value = historyController.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _mssvController.dispose();
    searchController.dispose();
    historyController.dispose();
    isClearVisible.dispose();
    isClearHistoryVisible.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 32),
          child: Column(
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Học phí',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: AppColors.blackColor),
                ),
              ),
              const SizedBox(height: 24),
              ItemSearch(formKey: _formKey, mssvController: _mssvController),
              const SizedBox(height: 24),
              ItemData(
                isClearVisible: isClearVisible,
                searchController: searchController,
                isClearHistoryVisible: isClearHistoryVisible,
                historyController: historyController,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ItemData extends StatelessWidget {
  const ItemData({
    super.key,
    required this.isClearVisible,
    required this.searchController,
    required this.isClearHistoryVisible,
    required this.historyController,
  });

  final ValueNotifier<bool> isClearVisible;
  final ValueNotifier<bool> isClearHistoryVisible;
  final TextEditingController searchController;
  final TextEditingController historyController;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Color(0x143A73C2),
            blurRadius: 8.0,
            offset: Offset(0, 0),
          ),
          BoxShadow(
            color: Color(0x143A73C2),
            blurRadius: 8.0,
            offset: Offset(0, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Thông tin học sinh',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.blackColor),
              ),
              Row(
                children: [
                  InkWell(
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.primaryColor),
                      ),
                      child: Row(
                        children: [
                          SvgPicture.asset(IconAssets.coinsIcon),
                          const SizedBox(width: 8),
                          const Text(
                            'Thêm khoản khác',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 24),
                  InkWell(
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: AppColors.primaryColor,
                      ),
                      child: Row(
                        children: [
                          SvgPicture.asset(IconAssets.moneyIcon),
                          const SizedBox(width: 8),
                          const Text(
                            'Nộp học phí',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColors.whiteColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: Responsive.isTablet(context)
                  ? MediaQuery.of(context).size.width
                  : MediaQuery.of(context).size.width / 1.26,
              child: titleTabWidget(
                name: 'Họ và tên',
                code: 'MSSV',
                industry: 'Ngành nghề',
                email: 'Email',
                phone: 'Số điện thoại',
                status: 'Trạng thái',
                detail: 'Chi tiết',
              ),
            ),
          ),
          Container(),
          const Divider(),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Học phí chưa thanh toán ( Sử dụng MÃ TRA CỨU để tra cứu )',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.blackColor,
                ),
              ),
              const Spacer(),
              SearchField(isClearVisible: isClearVisible, searchController: searchController),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: AppColors.trokeColor,
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: Responsive.isTablet(context)
                    ? MediaQuery.of(context).size.width
                    : MediaQuery.of(context).size.width / 1.26,
                child: Column(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        color: AppColors.yellow100Color,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8),
                          topRight: Radius.circular(8),
                        ),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 100,
                              child: Text(
                                'Mã tra cứu',
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.yellow700Color),
                              ),
                            ),
                            SizedBox(
                              width: 250,
                              child: Text(
                                'Nội dung',
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.yellow700Color),
                              ),
                            ),
                            SizedBox(
                              width: 121,
                              child: Text(
                                'Số tiền phát hành',
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.yellow700Color),
                              ),
                            ),
                            SizedBox(
                              width: 121,
                              child: Text(
                                'Số tiền đóng',
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.yellow700Color),
                              ),
                            ),
                            SizedBox(
                              width: 121,
                              child: Text(
                                'Còn nợ',
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.yellow700Color),
                              ),
                            ),
                            SizedBox(
                              width: 120,
                              child: Text(
                                'Hạn đóng',
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.yellow700Color),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Lịch sử đóng học phí ( Sử dụng MÃ TRA CỨU để tra cứu )',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.blackColor,
                ),
              ),
              const Spacer(),
              SearchField(isClearVisible: isClearHistoryVisible, searchController: historyController),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: AppColors.trokeColor,
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: Responsive.isTablet(context)
                    ? MediaQuery.of(context).size.width
                    : MediaQuery.of(context).size.width / 1.26,
                child: Column(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8),
                          topRight: Radius.circular(8),
                        ),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 100,
                              child: Text(
                                'Mã tra cứu',
                                style:
                                    TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.whiteColor),
                              ),
                            ),
                            SizedBox(
                              width: 250,
                              child: Text(
                                'Nội dung',
                                style:
                                    TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.whiteColor),
                              ),
                            ),
                            SizedBox(
                              width: 121,
                              child: Text(
                                'Số tiền phát hành',
                                style:
                                    TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.whiteColor),
                              ),
                            ),
                            SizedBox(
                              width: 121,
                              child: Text(
                                'Số tiền đóng',
                                style:
                                    TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.whiteColor),
                              ),
                            ),
                            SizedBox(
                              width: 121,
                              child: Text(
                                'Còn nợ',
                                style:
                                    TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.whiteColor),
                              ),
                            ),
                            SizedBox(
                              width: 120,
                              child: Text(
                                'Hạn đóng',
                                style:
                                    TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.whiteColor),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ItemSearch extends StatelessWidget {
  const ItemSearch({
    super.key,
    required GlobalKey<FormState> formKey,
    required TextEditingController mssvController,
  })  : _formKey = formKey,
        _mssvController = mssvController;

  final GlobalKey<FormState> _formKey;
  final TextEditingController _mssvController;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Color(0x143A73C2),
            blurRadius: 8.0,
            offset: Offset(0, 0),
          ),
          BoxShadow(
            color: Color(0x143A73C2),
            blurRadius: 8.0,
            offset: Offset(0, 0),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            CustomTextWidgets(
              controller: _mssvController,
              title: 'Nhập MSSV',
              hintText: '123456789',
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                FilteringTextInputFormatter.deny(' '),
                LengthLimitingTextInputFormatter(12),
              ],
              validator: true,
            ),
            const SizedBox(height: 24),
            InkWell(
              onTap: () {
                if (_formKey.currentState!.validate()) {}
              },
              child: Align(
                alignment: Alignment.centerRight,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: AppColors.primaryColor,
                  ),
                  child: const Text(
                    'Xác nhận',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.whiteColor),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchField extends StatelessWidget {
  const SearchField({
    super.key,
    required this.isClearVisible,
    required this.searchController,
  });

  final ValueNotifier<bool> isClearVisible;
  final TextEditingController searchController;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ValueListenableBuilder<bool>(
        valueListenable: isClearVisible,
        builder: (context, isVisible, child) {
          return TextFormField(
            controller: searchController,
            inputFormatters: [
              FilteringTextInputFormatter.deny(RegExp(r'[.,-/]')),
              LengthLimitingTextInputFormatter(25),
            ],
            decoration: InputDecoration(
              isDense: true,
              fillColor: const Color(0xFFF7F7FC),
              filled: true,
              hintText: 'Tìm kiếm',
              hintStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Color(0xFF7E8695),
              ),
              prefixIcon: Container(
                width: 20,
                height: 20,
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsetsDirectional.only(start: 12),
                  child: SvgPicture.asset('assets/icons/search.svg', width: 20, height: 20),
                ),
              ),
              suffix: isVisible
                  ? InkWell(
                      onTap: () {
                        searchController.clear();
                        isClearVisible.value = false;
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: Container(
                          padding: const EdgeInsets.all(3),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFF7E8695),
                          ),
                          child: const Icon(Icons.clear_rounded, color: Colors.white, size: 12),
                        ),
                      ),
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(41),
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 16),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(41),
                borderSide: const BorderSide(color: Color(0xFFF7F7FC)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(41),
                borderSide: const BorderSide(color: Color(0xFFF7F7FC)),
              ),
            ),
          );
        },
      ),
    );
  }
}
