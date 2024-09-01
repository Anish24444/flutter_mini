import 'dart:math';
import 'package:flutter/material.dart';

class Product {
  String name;
  double dimensionalAccuracy;
  double surfaceRoughness;
  double buildTime;
  double elongation;
  double tensileStrength;
  double processCost;
  String amProcessUnit;
  String machineType;
  String material;
  double rank;

  Product({
    required this.name,
    required this.dimensionalAccuracy,
    required this.surfaceRoughness,
    required this.buildTime,
    required this.elongation,
    required this.tensileStrength,
    required this.processCost,
    required this.amProcessUnit,
    required this.machineType,
    required this.material,
    this.rank = 0.0,
  });
}

class ProductRankingScreen extends StatefulWidget {
  const ProductRankingScreen({Key? key}) : super(key: key);

  @override
  _ProductRankingScreenState createState() => _ProductRankingScreenState();
}

class _ProductRankingScreenState extends State<ProductRankingScreen> {
  List<Product> products = [
    Product(
      name: 'Machine 1',
      dimensionalAccuracy: 0.1,
      surfaceRoughness: 0.2,
      buildTime: 50,
      elongation: 0.8,
      tensileStrength: 300,
      processCost: 1000,
      amProcessUnit: 'Goal material jetting (mj)',
      machineType: 'project mjp 2500',
      material: 'visijet m2r wt',
    ),
    Product(
      name: 'Machine 2',
      dimensionalAccuracy: 0.05,
      surfaceRoughness: 0.1,
      buildTime: 70,
      elongation: 0.9,
      tensileStrength: 350,
      processCost: 1200,
      amProcessUnit: 'vat photopoly merijation (vjpp)',
      machineType: 'eka dlp 3d printer',
      material: 'abs tru resin',
    ),
    Product(
      name: 'Machine 3',
      dimensionalAccuracy: 0.15,
      surfaceRoughness: 0.3,
      buildTime: 60,
      elongation: 0.7,
      tensileStrength: 250,
      processCost: 800,
      amProcessUnit: 'Material extrusion(ME)',
      machineType: 'pratham lfa 3d printer',
      material: 'pla plus',
    ),
    Product(
      name: 'Machine 4',
      dimensionalAccuracy: 0.08,
      surfaceRoughness: 0.15,
      buildTime: 55,
      elongation: 0.85,
      tensileStrength: 320,
      processCost: 1100,
      amProcessUnit: 'powder bed fusion(pbf)',
      machineType: 'eos p396',
      material: 'Nylon12 pa 220',
    ),
    Product(
      name: 'Machine 5',
      dimensionalAccuracy: 0.12,
      surfaceRoughness: 0.25,
      buildTime: 65,
      elongation: 0.75,
      tensileStrength: 280,
      processCost: 950,
      amProcessUnit: 'jet que neo',
      machineType: 'eos p290 ',
      material: 'Nylon11 pa 210',
    ),
    // Add more 3D printers with their attributes
  ];

  Map<String, double> weights = {
    'dimensionalAccuracy': 20,
    'surfaceRoughness': 20,
    'buildTime': 20,
    'elongation': 20,
    'tensileStrength': 20,
    'processCost': 20,
  };

  bool adjustWeightsMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mini Project"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        adjustWeightsMode = true;
                      });
                    },
                    child: const Text('Adjust Weights'),
                  ),
                  if (adjustWeightsMode)
                    ...[
                      const SizedBox(height: 16),
                      const Text(
                        'Adjust Attribute Weights:',
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      for (var attribute in weights.keys)
                        attributeWeightSlider(attribute),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            adjustWeightsMode = false;
                          });
                        },
                        child: const Text('Done Adjusting'),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            weights = {
                              'dimensionalAccuracy':0,
                              'surfaceRoughness': 0,
                              'buildTime': 0,
                              'elongation': 0,
                              'tensileStrength': 0,
                              'processCost': 0,
                            };
                          });
                        },
                        child: const Text('Readjust Weights'),
                      ),
                    ],
                ],
              ),
            ),
            const Divider(height: 20),
            ElevatedButton(
              onPressed: () {
                rankProductsUsingTOPSIS();
              },
              child: const Text('Rank Products'),
            ),
            const SizedBox(height: 16),
            // Add a button to show rank order
            ElevatedButton(
              onPressed: () {
                showRankOrder();
              },
              child: const Text('Show Rank Order'),
            ),
            const SizedBox(height: 16),
            for (var product in products)
              ProductBox(
                product: product,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductDetailsScreen(product: product, weights: weights),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget attributeWeightSlider(String attribute) {
    return Column(
      children: [
        Text(attribute),
        const SizedBox(height: 5),
        Slider(
          value: weights[attribute]!,
          onChanged: adjustWeightsMode
              ? (value) {
            double total = weights.values.reduce((value, element) => value + element) - weights[attribute]!;
            if (total + value <= 100.0 && total + value >= 0.0) {
              setState(() {
                weights[attribute] = value;
              });
            }
          }
              : null,
          min: 0,
          max: 100,
          divisions: 100,
          label: weights[attribute]!.toStringAsFixed(2),
        ),
      ],
    );
  }

  double calculateRank(Product product) {
    double rank = 0.0;
    rank += product.dimensionalAccuracy * weights['dimensionalAccuracy']!;
    rank += (1 / product.surfaceRoughness) * weights['surfaceRoughness']!;
    rank += product.buildTime * weights['buildTime']!;
    rank += product.elongation * weights['elongation']!;
    rank += (1 / product.tensileStrength) * weights['tensileStrength']!;
    rank += product.processCost * weights['processCost']!;
    return rank;
  }

  void rankProductsUsingTOPSIS() {
    List<List<double>> criteriaMatrix = products.map((product) {
      return [
        product.dimensionalAccuracy,
        product.surfaceRoughness,
        product.buildTime,
        product.elongation,
        product.tensileStrength,
        product.processCost,
      ];
    }).toList();

    List<List<double>> normalizedMatrix = normalizeCriteriaMatrix(criteriaMatrix);
    List<List<double>> weightedNormalizedMatrix = calculateWeightedNormalizedMatrix(normalizedMatrix);

    List<double> positiveIdeal = calculateIdealSolution(weightedNormalizedMatrix, true);
    List<double> negativeIdeal = calculateIdealSolution(weightedNormalizedMatrix, false);

    List<double> separationMeasures = calculateSeparationMeasures(weightedNormalizedMatrix, positiveIdeal, negativeIdeal);

    List<double> topsisScores = calculateTOPSISScores(separationMeasures);

    for (int i = 0; i < products.length; i++) {
      products[i].rank = topsisScores[i];
    }

    products.sort((a, b) => b.rank.compareTo(a.rank));

    setState(() {});
  }

  List<List<double>> normalizeCriteriaMatrix(List<List<double>> matrix) {
    List<double> sumOfSquares = List.filled(matrix[0].length, 0.0);
    for (int j = 0; j < matrix[0].length; j++) {
      for (int i = 0; i < matrix.length; i++) {
        sumOfSquares[j] += pow(matrix[i][j], 2);
      }
      sumOfSquares[j] = sqrt(sumOfSquares[j]);
    }

    List<List<double>> normalizedMatrix = List.generate(matrix.length, (index) => List.filled(matrix[0].length, 0.0));
    for (int i = 0; i < matrix.length; i++) {
      for (int j = 0; j < matrix[0].length; j++) {
        normalizedMatrix[i][j] = matrix[i][j] / sumOfSquares[j];
      }
    }

    return normalizedMatrix;
  }

  List<List<double>> calculateWeightedNormalizedMatrix(List<List<double>> matrix) {
    List<List<double>> weightedNormalizedMatrix =
    List.generate(matrix.length, (index) => List.filled(matrix[0].length, 0.0));

    for (int i = 0; i < matrix.length; i++) {
      for (int j = 0; j < matrix[0].length; j++) {
        weightedNormalizedMatrix[i][j] = matrix[i][j] * weights.values.elementAt(j);
      }
    }

    return weightedNormalizedMatrix;
  }

  List<double> calculateIdealSolution(List<List<double>> matrix, bool isPositive) {
    List<double> idealSolution = List.filled(matrix[0].length, isPositive ? double.negativeInfinity : double.infinity);

    for (int j = 0; j < matrix[0].length; j++) {
      for (int i = 0; i < matrix.length; i++) {
        if (isPositive) {
          idealSolution[j] = max(idealSolution[j], matrix[i][j]);
        } else {
          idealSolution[j] = min(idealSolution[j], matrix[i][j]);
        }
      }
    }

    return idealSolution;
  }

  List<double> calculateSeparationMeasures(List<List<double>> matrix, List<double> positiveIdeal, List<double> negativeIdeal) {
    List<double> separationMeasures = List.filled(matrix.length, 0.0);

    for (int i = 0; i < matrix.length; i++) {
      double positiveDistance = calculateEuclideanDistance(matrix[i], positiveIdeal);
      double negativeDistance = calculateEuclideanDistance(matrix[i], negativeIdeal);

      separationMeasures[i] = negativeDistance / (positiveDistance + negativeDistance);
    }

    return separationMeasures;
  }

  double calculateEuclideanDistance(List<double> vector1, List<double> vector2) {
    double sum = 0;
    for (int i = 0; i < vector1.length; i++) {
      sum += pow(vector1[i] - vector2[i], 2);
    }
    return sqrt(sum);
  }

  List<double> calculateTOPSISScores(List<double> separationMeasures) {
    List<double> topsisScores = List.filled(separationMeasures.length, 0.0);

    for (int i = 0; i < separationMeasures.length; i++) {
      topsisScores[i] = 1 / (1 + separationMeasures[i]);
    }

    return topsisScores;
  }

  void showRankOrder() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Rank Order'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              for (int i = 0; i < products.length; i++)
                Text(
                  '${i + 1}. ${products[i].name} - Rank Score: ${products[i].rank.toStringAsFixed(2)}',
                ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    rankProductsUsingTOPSIS();
  }
}

class ProductDetailsScreen extends StatelessWidget {
  final Product product;
  final Map<String, double> weights;

  const ProductDetailsScreen({Key? key, required this.product, required this.weights}) : super(key: key);

  double calculateRank() {
    double rank = 0.0;
    rank += product.dimensionalAccuracy * weights['dimensionalAccuracy']!;
    rank += (1 / product.surfaceRoughness) * weights['surfaceRoughness']!;
    rank += product.buildTime * weights['buildTime']!;
    rank += product.elongation * weights['elongation']!;
    rank += (1 / product.tensileStrength) * weights['tensileStrength']!;
    rank += product.processCost * weights['processCost']!;
    return rank;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Product Name: ${product.name}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text('Dimensional Accuracy: ${product.dimensionalAccuracy}'),
            Text('Surface Roughness: ${product.surfaceRoughness}'),
            Text('Build Time: ${product.buildTime}'),
            Text('Elongation: ${product.elongation}'),
            Text('Tensile Strength: ${product.tensileStrength}'),
            Text('Process Cost: ${product.processCost}'),
            const SizedBox(height: 10),
            Text('AM Process Unit: ${product.amProcessUnit}'),
            Text('Machine Type: ${product.machineType}'),
            Text('Material: ${product.material}'),
            const SizedBox(height: 20),
            Text(
              'Rank Score: ${calculateRank().toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductBox extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;

  const ProductBox({Key? key, required this.product, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Text(
              product.name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 8),
            const Text('Click to view details', style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(
    const MaterialApp(
      home: ProductRankingScreen(),
    ),
  );
}
