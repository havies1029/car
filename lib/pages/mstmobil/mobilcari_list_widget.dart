import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:rentcarapp/widgets/showdialoghapus_widget.dart';
import 'package:rentcarapp/blocs/mstmobil/mobilcari_bloc.dart';
import 'package:rentcarapp/blocs/mstmobil/mobilcrud_bloc.dart';
import 'package:rentcarapp/pages/mstmobil/mobilcari_tile_widget.dart';

class MobilCariListWidget extends StatefulWidget {
	final String searchText;
	const MobilCariListWidget({super.key, required this.searchText});

	@override
	MobilCariListWidgetState createState() => MobilCariListWidgetState();
}

class MobilCariListWidgetState extends State<MobilCariListWidget> {
	late MobilCariBloc mobilCariBloc;
	late MobilCrudBloc mobilCrudBloc;
	final ScrollController _scrollController = ScrollController();

	@override
	void initState() {
		super.initState();
		_scrollController.addListener(_onScroll);
	}

	@override
	void dispose() {
		_scrollController
			..removeListener(_onScroll)
			..dispose();
		super.dispose();
	}

	@override
	Widget build(BuildContext context) {
		mobilCariBloc = BlocProvider.of<MobilCariBloc>(context);
		mobilCrudBloc = BlocProvider.of<MobilCrudBloc>(context);
		return BlocConsumer<MobilCariBloc, MobilCariState>(
			builder: (context, state) {
			if (state.status == ListStatus.success) {
			return state.items.isNotEmpty
				? Flexible(
					child: ListView.builder(
						padding: EdgeInsets.zero,
						controller: _scrollController,
						itemCount: state.items.length,
						itemBuilder: (_, index) => Container(
							margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
							padding: const EdgeInsets.all(0.2),
							decoration: BoxDecoration(
								borderRadius: BorderRadius.circular(15.0)),
							child: Column(
								children: <Widget>[
									Slidable(
										endActionPane: ActionPane(
											motion: const BehindMotion(),
												children: [
													SlidableAction(
														onPressed: (context) {
															mobilCariBloc.add(
																UbahMobilCariEvent(
																	recordId: state
																		.items[index]
																		.mmobilId));
														},
														backgroundColor: Colors.green,
														icon: Icons.edit,
														label: "Edit",
													),
													SlidableAction(
														onPressed: (context) {
															showDialogHapus(
																state.items[index].mmobilId);
														},
														backgroundColor: Colors.red,
														icon: Icons.delete,
														label: "Delete",
													),
												]),
											child: MobilCariTileWidget(												
												mmobilId: state.items[index].mmobilId,
												platNo: state.items[index].platNo,
												polisAkhir: state.items[index].polisAkhir,
												polisMulai: state.items[index].polisMulai,
												polisNo: state.items[index].polisNo,
												insurerNama: state.items[index].insurerNama??'',
												statusNama: state.items[index].statusNama??'',
												stnkNo: state.items[index].stnkNo,
												stnkTempo: state.items[index].stnkTempo,
												thnBuat: state.items[index].thnBuat,
												tipeNama: state.items[index].tipeNama??'',
												warnaNama: state.items[index].warnaNama??'',
											)),
							],
						),
					)),
				)
			: const Center(
				child: Padding(
					padding: EdgeInsets.only(top: 80.0),
					child: Text(
						'No Data Available!!',
						style: TextStyle(
							color: Colors.red,
							fontSize: 12.0,
							fontWeight: FontWeight.bold),
					),
				),
			);
		} else {
			return const Center(
					child: Text(
						'No Data Available!!',
						style: TextStyle(
							color: Colors.red,
							fontSize: 12.0,
							fontWeight: FontWeight.bold),
					),
				);
			}
			}, buildWhen: (previous, current) {
				return (current.status == ListStatus.success);
			}, listener: (context, state) {}
		);
	}
	void _onScroll() {
		if (!_scrollController.hasClients) return;
		if (_scrollController.position.pixels ==
				_scrollController.position.maxScrollExtent) {
			mobilCariBloc.add(FetchMobilCariEvent(
				searchText: widget.searchText, hal: mobilCariBloc.state.hal));
		}
	}

	onHapusFunction(String recordId) {
		mobilCrudBloc.add(MobilCrudHapusEvent(recordId: recordId));
	}

	void showDialogHapus(String recordId) {
		showDialog(
			context: context,
			barrierDismissible: false,
			builder: (BuildContext context) {
				return ShowDialogHapusWidget(onHapusFunction: onHapusFunction, recordId: recordId);
			}
		).then((value) {
			mobilCariBloc.add(CloseDialogMobilCariEvent());
		});
	}

}