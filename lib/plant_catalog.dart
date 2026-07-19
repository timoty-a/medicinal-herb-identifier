class PlantProfile {
  const PlantProfile({
    required this.label,
    required this.commonName,
    required this.scientificName,
    required this.yorubaName,
    required this.igboName,
    required this.hausaName,
    required this.medicinalUses,
    required this.imageAssetPath,
    required this.habitatNote,
    required this.about,
    required this.healthBenefits,
    required this.commonUses,
    required this.preparation,
    required this.warnings,
    required this.searchKeywords,
  });

  final String label;
  final String commonName;
  final String scientificName;
  final String yorubaName;
  final String igboName;
  final String hausaName;
  final String medicinalUses;
  final String imageAssetPath;
  final String habitatNote;
  final String about;
  final List<String> healthBenefits;
  final List<String> commonUses;
  final String preparation;
  final List<String> warnings;
  final List<String> searchKeywords;
}

class PlantCatalog {
  static const double lowConfidenceThreshold = 0.80;
  static const double reviewConfidenceThreshold = 0.72;
  static const double reviewConfidenceGapThreshold = 0.14;
  static const int speciesCount = 5;

  static const List<PlantProfile> profiles = [
    PlantProfile(
      label: 'Aloe vera',
      commonName: 'Aloe Vera',
      scientificName: 'Aloe barbadensis miller',
      yorubaName: 'Ahon Erin',
      igboName: 'Aloe Vera',
      hausaName: 'Zaitun Ruwa',
      medicinalUses:
          'Traditionally used for burns, skin conditions, and digestion support.',
      imageAssetPath: 'assets/images/plants/aloe_vera.png',
      habitatNote:
          'A succulent widely cultivated in tropical home gardens and herbal plots.',
      about:
          'Aloe vera is a fleshy medicinal succulent valued for the clear gel stored inside its leaves. In community herbal practice, it is commonly associated with soothing skin irritation and supporting gentle home remedies.',
      healthBenefits: [
        'Traditionally associated with soothing minor skin irritation.',
        'Often used in herbal care for moisturizing dry skin.',
        'Commonly linked with simple household topical remedies.',
      ],
      commonUses: [
        'Topical application of the inner gel on the skin.',
        'Use in herbal mixtures prepared for external care.',
        'Occasional inclusion in carefully prepared home remedies.',
      ],
      preparation:
          'Wash the leaf, remove the outer surface carefully, and use only the clean inner gel for external traditional applications.',
      warnings: [
        'Use with caution on sensitive skin and patch-test first.',
        'Do not rely on aloe alone for serious burns or infections.',
        'Avoid informal internal use unless advised by a qualified professional.',
      ],
      searchKeywords: ['aloe', 'ahon erin', 'zaitun ruwa', 'succulent', 'skin'],
    ),
    PlantProfile(
      label: 'Bitter leaf',
      commonName: 'Bitter Leaf',
      scientificName: 'Vernonia amygdalina',
      yorubaName: 'Ewuro',
      igboName: 'Onugbu',
      hausaName: 'Shuwaka',
      medicinalUses:
          'Traditionally used for fever, malaria, and digestive disorders.',
      imageAssetPath: 'assets/images/plants/bitter_leaf.png',
      habitatNote:
          'A familiar West African shrub commonly grown around homes and farms.',
      about:
          'Bitter leaf is a well-known Nigerian medicinal and culinary plant recognized by its distinct bitter taste. It is regularly mentioned in local herbal knowledge for digestive comfort and fever-related traditional preparations.',
      healthBenefits: [
        'Traditionally associated with digestive support.',
        'Commonly linked with fever-related herbal mixtures.',
        'Widely used in community herbal practice for general wellness support.',
      ],
      commonUses: [
        'Washed leaves used in soups and local food preparation.',
        'Leaf infusions prepared in traditional household remedies.',
        'Herbal mixtures combined with other local medicinal plants.',
      ],
      preparation:
          'Leaves are usually rinsed thoroughly to reduce bitterness before culinary or traditional herbal preparation.',
      warnings: [
        'Do not treat persistent fever or severe illness with home remedies alone.',
        'Use clean preparation methods to reduce contamination risk.',
        'People with ongoing medical treatment should seek professional advice first.',
      ],
      searchKeywords: ['bitter leaf', 'ewuro', 'onugbu', 'shuwaka', 'vernonia'],
    ),
    PlantProfile(
      label: 'Moringa',
      commonName: 'Moringa',
      scientificName: 'Moringa oleifera',
      yorubaName: 'Ewe Igb\u00E1l\u00F3d\u00EC',
      igboName: 'Okwe Oyibo',
      hausaName: 'Zogale',
      medicinalUses:
          'Traditionally used for malnutrition support, inflammation, and diabetes management.',
      imageAssetPath: 'assets/images/plants/moringa.png',
      habitatNote:
          'A fast-growing tree widely cultivated across tropical Africa for food and herbal use.',
      about:
          'Moringa is valued as both a food plant and a medicinal resource. Its leaves are often discussed in local knowledge for their nutrient density and their role in everyday family wellness practices.',
      healthBenefits: [
        'Traditionally associated with nutrient support in diets.',
        'Commonly linked with household wellness and strength-building use.',
        'Often discussed in herbal practice for general body support.',
      ],
      commonUses: [
        'Fresh leaves added to soups and stews.',
        'Dried leaves ground for local food or drink mixtures.',
        'Traditional herbal infusions prepared from the leaves.',
      ],
      preparation:
          'Leaves are often washed, chopped, and cooked lightly, or dried carefully before being ground for later use.',
      warnings: [
        'Avoid replacing balanced medical care with moringa alone.',
        'Use clean, well-identified leaves during preparation.',
        'People with chronic conditions should seek medical guidance first.',
      ],
      searchKeywords: [
        'moringa',
        'zogale',
        'okwe oyibo',
        'ewe igbalodi',
        'nutrition',
      ],
    ),
    PlantProfile(
      label: 'Pawpaw leaf',
      commonName: 'Pawpaw Leaf',
      scientificName: 'Carica papaya',
      yorubaName: 'Ewe Ibepe',
      igboName: 'Akw\u1EE5kw\u1ECD Pawpaw',
      hausaName: 'Ganyen Gwanda',
      medicinalUses:
          'Traditionally used for malaria, dengue fever, and wound healing.',
      imageAssetPath: 'assets/images/plants/pawpaw_leaf.png',
      habitatNote:
          'Taken from the papaya plant, which is widely grown in tropical compounds and farms.',
      about:
          'Pawpaw leaf is frequently mentioned in herbal discussions because of its strong green sap and broad leaf structure. In local traditional practice, it is often included in decoctions and external preparations.',
      healthBenefits: [
        'Traditionally associated with fever-related household remedies.',
        'Commonly linked with external herbal preparation in local practice.',
        'Used in some communities as part of mixed-plant remedies.',
      ],
      commonUses: [
        'Leaf decoctions prepared in traditional settings.',
        'External application in selected local herbal mixtures.',
        'Combination with other medicinal leaves in household remedies.',
      ],
      preparation:
          'Leaves are usually washed and processed carefully in measured traditional preparations rather than used casually.',
      warnings: [
        'Do not self-medicate serious fever or infection with pawpaw leaf alone.',
        'Use only correctly identified leaves from a clean source.',
        'Traditional preparations should be approached cautiously and responsibly.',
      ],
      searchKeywords: [
        'pawpaw',
        'papaya',
        'ewe ibepe',
        'ganyen gwanda',
        'leaf',
      ],
    ),
    PlantProfile(
      label: 'Scent leaf',
      commonName: 'Scent Leaf',
      scientificName: 'Ocimum gratissimum',
      yorubaName: 'Efirin',
      igboName: 'Nchuanwu',
      hausaName: 'Daidoya',
      medicinalUses:
          'Traditionally used for cough, fever, and skin infections.',
      imageAssetPath: 'assets/images/plants/scent_leaf.png',
      habitatNote:
          'An aromatic herb often grown close to homes because of its culinary and medicinal value.',
      about:
          'Scent leaf is an aromatic Nigerian herb known for its strong smell and broad use in food and traditional care. It is commonly referenced in local practice for cough mixtures and herbal preparations for general wellness.',
      healthBenefits: [
        'Traditionally associated with cough and cold household remedies.',
        'Commonly linked with aromatic herbal preparations.',
        'Often included in local remedies for general comfort and cleansing.',
      ],
      commonUses: [
        'Fresh leaves added to soups and spice mixtures.',
        'Leaves crushed or infused for traditional household remedies.',
        'Combined with other herbs in simple local wellness preparations.',
      ],
      preparation:
          'Leaves are usually washed, lightly crushed, or simmered depending on the traditional use and recipe.',
      warnings: [
        'Strong herbal mixtures should be used cautiously.',
        'Do not rely on home remedies for persistent breathing problems.',
        'Seek proper care if symptoms are severe or prolonged.',
      ],
      searchKeywords: ['scent leaf', 'efirin', 'nchuanwu', 'daidoya', 'ocimum'],
    ),
  ];

  static PlantProfile profileForLabel(String label) {
    return profiles.firstWhere(
      (profile) => profile.label.toLowerCase() == label.toLowerCase(),
      orElse: () => PlantProfile(
        label: label,
        commonName: label,
        scientificName: 'Not mapped yet',
        yorubaName: label,
        igboName: 'Not added yet',
        hausaName: 'Not added yet',
        medicinalUses:
            'Add the plant details that correspond to this model label.',
        imageAssetPath: '',
        habitatNote: 'Not added yet.',
        about: 'Not added yet.',
        healthBenefits: const ['Add the plant benefits.'],
        commonUses: const ['Add the common uses.'],
        preparation: 'Add the preparation note.',
        warnings: const ['Add the warnings.'],
        searchKeywords: const [],
      ),
    );
  }
}
