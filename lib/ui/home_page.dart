import 'package:flutter/material.dart';
import 'package:flutter_cep/models/cep_model.dart';
import 'package:flutter_cep/repositories/cep_repository.dart';
import 'package:flutter_cep/ui/widgets/address_widget.dart';
import 'package:http/http.dart' as http;
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final repository = CepRepository(client: http.Client());
  final cepController = TextEditingController();
  final cepFormatter = MaskTextInputFormatter(
    mask: "#####-###",
    filter: {'#': RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );

  String? errorMessage;
  CepModel? cepModel;
  bool isLoading = false;

  Future<void> buscarCep() async {
    FocusScope.of(context).unfocus();
    setState(() {
      isLoading = true;
      errorMessage = null;
      cepModel = null;
    });

    final cep = cepController.text.trim();

    if (cep.isEmpty) {
      setState(() {
        isLoading = false;
        errorMessage = "Digite um CEP Válido.";
      });
      return;
    }

    try {
      final addressModel = await repository.consultarCep(cep);
      setState(() {
        isLoading = false;
        cepModel = addressModel;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = "Erro ao buscar endereço.";
      });
    }
  }

  @override
  void dispose() {
    cepController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Consulta de CEP'),
        leading: Icon(
          Icons.location_city,
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          spacing: 24.0,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.primary.withValues(alpha: 0.1),
                    theme.colorScheme.secondary.withValues(alpha: 0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Column(
                spacing: 4.0,
                children: [
                  Icon(
                    Icons.search_rounded,
                    size: 48,
                    color: theme.colorScheme.primary,
                  ),
                  Text(
                    'Busque por qualquer CEP',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  Text(
                    "Digite o CEP e descubra o endereço completo",
                    style: theme.textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            TextField(
              controller: cepController,
              inputFormatters: [cepFormatter],
              keyboardType: TextInputType.number,
              maxLength: 9,
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.location_on_rounded,
                ),
                labelText: "CEP",
                hintText: "Digite o CEP (ex: 01310-100)",
                counterText: '',
              ),
            ),
            AnimatedSwitcher(
              duration: Duration(milliseconds: 200),
              child: isLoading
                  ? Container(
                      height: 50.0,
                      width: 200.0,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        spacing: 12.0,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.0,
                            ),
                          ),
                          Text(
                            "Buscando CEP",
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ElevatedButton.icon(
                      onPressed: buscarCep,
                      label: Text("Buscar CEP"),
                      icon: Icon(Icons.search_rounded),
                    ),
            ),
            if (errorMessage != null) ...[
              Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: theme.colorScheme.error.withValues(
                    alpha: 0.1,
                  ),
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(
                    color: theme.colorScheme.error.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  spacing: 12.0,
                  children: [
                    Icon(
                      Icons.error_outline_rounded,
                      color: theme.colorScheme.error,
                      size: 24.0,
                    ),
                    const SizedBox(
                      width: 12.0,
                    ),
                    Text(
                      errorMessage ?? '',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.error,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            if (cepModel != null)
              AnimatedOpacity(
                opacity: cepModel != null ? 1.0 : 0.0,
                duration: Duration(milliseconds: 500),
                child: AddressWidget(
                  cepModel: cepModel,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
