import 'package:flutter/material.dart';
import 'package:flutter_cep/models/cep_model.dart';

class AddressWidget extends StatelessWidget {
  final CepModel? cepModel;

  const AddressWidget({super.key, this.cepModel});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (cepModel == null) {
      return SizedBox.shrink();
    }

    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            gradient: LinearGradient(
              colors: [
                theme.colorScheme.primary,
                theme.colorScheme.secondary,
              ],
            ),
          ),
          child: Column(
            children: [
              Icon(
                Icons.check_circle_rounded,
                size: 48,
                color: Colors.white,
              ),
              const SizedBox(
                height: 8.0,
              ),
              Text(
                "CEP Econtrado",
                style: theme.textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                ),
              ),
              Text(
                "Informações do endereço",
                style: theme.textTheme.titleMedium?.copyWith(
                  color: Colors.white.withValues(alpha: 0.9),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        _InfoCard(
          icon: Icons.location_on_rounded,
          title: 'CEP',
          subtitle: cepModel!.cep,
          color: theme.colorScheme.primary,
        ),
        _InfoCard(
          icon: Icons.streetview_rounded,
          title: 'Logradouro',
          subtitle: cepModel!.logradouro,
          color: theme.colorScheme.secondary,
        ),
        _InfoCard(
          icon: Icons.home_rounded,
          title: 'Bairro',
          subtitle: cepModel!.bairro,
          color: theme.colorScheme.tertiary,
        ),
        _InfoCard(
          icon: Icons.location_city_rounded,
          title: 'Cidade',
          subtitle: cepModel!.localidade,
          color: Colors.green,
        ),
        _InfoCard(
          icon: Icons.map_rounded,
          title: 'Estado',
          subtitle: cepModel!.estado,
          color: Colors.orange,
        ),
        if (cepModel!.complemento.isNotEmpty) ...[
          _InfoCard(
            icon: Icons.info_rounded,
            title: 'Complemento',
            subtitle: cepModel!.complemento,
            color: Colors.purple,
          ),
        ],
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;

  const _InfoCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: color.withValues(
            alpha: 0.2,
          ),
        ),
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: color.withValues(
              alpha: 0.1,
            ),
            blurRadius: 8.0,
            offset: Offset(0.0, 2.0),
          ),
        ],
      ),
      child: Row(
        spacing: 16.0,
        children: [
          Container(
            padding: EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
