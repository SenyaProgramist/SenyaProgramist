import 'package:phrasal_verbs/model/phrasal_verb.dart';
import 'dart:math';

class PhrasalVerbsBank {
  List<PhrasalVerb> get verbs {
    return _verbs;
  }

  List<PhrasalVerb> verbsToLearn(Category category, int level) {
    int res = (level - 1) * 5;
    print(res);
    return _verbs
        .where((e) => e.category == category)
        .toList()
        .getRange(res, res + 5)
        .toList();
  }

  var random = Random();

  List<PhrasalVerb> optionsListGeneral(int length) {
    List<PhrasalVerb> _list = [];
    for (var i = 0; i < length; i++) {
      var pV = verbs[random.nextInt(verbs.length - 1)];
      _list.add(pV);
    }
    return _list;
  }

  static int levelScoreFinal(List<Level> subLevels) {
    int res = 0;
    int maxRes = 90;
    //15 points for 5 level
    subLevels.forEach((l) {
      res = res + l.progress;
      print(res);
    });
    print('score');
    print(res / maxRes);
    return res != 0 ? (res / maxRes * 100).ceil() : 1;
  }

  List<Level> getSubLevelsRange(int levelIndex, {List<Level> levels}) {
    return levels.getRange(levelIndex * 6, (levelIndex + 1) * 6).toList();
  }

  String nameOfPhrasalVerb(PhrasalVerb pV) {
    String secondPreposition = '';
    if (pV.secondPreposition != null) {
      secondPreposition = ' ' +
          pV.secondPreposition.toString().substring(12).replaceAll('\$', '');
    }
    return shortenVerb(pV) +
        ' ' +
        shortenPreposition(pV) +
        ' ' +
        shortenPreposition2(pV);
  }

  void categoriesBreakdown() {
    List<PhrasalVerb> bank = verbs;
    List<Category> categories = [];

    for (var verb in bank) {
      if (!categories.contains(verb.category)) {
        categories.add(verb.category);
      }
    }

    for (var category in categories) {
      List<PhrasalVerb> verbsByCategory = [];
      for (var verb in bank) {
        if (verb.category == category) {
          verbsByCategory.add(verb);
        }
      }
      print(category);
      print('LEVELS ${verbsByCategory.length ~/ 5}');
      print('EXTRA ${verbsByCategory.length % 5}');
      print('\n');

      verbsByCategory.clear();
    }
  }

  void categoryBreakByNumber() {
    List<PhrasalVerb> bank = PhrasalVerbsBank().verbs;
    List<Category> categories = [];

    for (var verb in bank) {
      if (!categories.contains(verb.category)) {
        categories.add(verb.category);
      }
    }
    List<Map<int, String>> levels = [];
    for (var category in categories) {
      List<PhrasalVerb> verbsByCategory = [];
      for (var verb in bank) {
        if (verb.category == category) {
          verbsByCategory.add(verb);
        }
      }
      levels.add({
        verbsByCategory.length ~/ 5:
            PhrasalVerbsBank().categoryToLabel(category)
      });
//                      print('LEVELS ${verbsByCategory.length ~/ 5}');
      verbsByCategory.clear();
    }
    levels.sort((a, b) => a.keys.first.compareTo(b.keys.first));
    levels.forEach((e) {
      if (e.keys.first != 0) {}
      print(e.values.first.toString() + " " + e.keys.first.toString());
    });
  }

  void levelsLeft() {
    List<PhrasalVerb> bank = PhrasalVerbsBank().verbs;
    List<Category> categories = [];

    for (var verb in bank) {
      if (!categories.contains(verb.category)) {
        categories.add(verb.category);
      }
    }
    List<Map<String, int>> levels = [];
    for (var category in categories) {
      List<PhrasalVerb> verbsByCategory = [];
      for (var verb in bank) {
        if (verb.category == category) {
          verbsByCategory.add(verb);
        }
      }
      levels.add({
        PhrasalVerbsBank().categoryToLabel(category):
            verbsByCategory.length ~/ 5
      });
//                      print('LEVELS ${verbsByCategory.length ~/ 5}');
      verbsByCategory.clear();
    }
    levels.sort((a, b) => a.values.first.compareTo(b.values.first));
    levels.forEach((e) {
      e[e.keys.first] = e.values.first -
          this
              .levels
              .where((l) => this.categoryToLabel(l.category) == e.keys.first)
              .length;
      if (e.values.first != 0) {
        print(e.keys.first.toString() + " " + e.values.first.toString());
      }
    });
    for (var level in this.levels) {
      if (this
              .levels
              .where(
                  (e) => e.category == level.category && e.level == level.level)
              .toList()
              .length >
          1) {
        print(level.category.toString() + level.level.toString());
      }
    }
  }

  List<Category> categoriesList() {
    List<Category> categories = [];
    for (var e in _verbs) {
      if (!categories.contains(e.category)) {
        categories.add(e.category);
      }
    }
    return categories;
  }

  List<Preposition> prepositionsList() {
    List<Preposition> prepositions = [];
    for (var e in _verbs) {
      if (!prepositions.contains(e.preposition)) {
        prepositions.add(e.preposition);
      }
    }
    return prepositions;
  }

  List<PhrasalVerb> verbsListByCategory(
      Category category, List<PhrasalVerb> verbs) {
    return verbs.where((pV) => pV.category == category).toList();
  }

  String categoryToLabel(Category category) {
    return '${category.toString().substring(9)[0].toUpperCase()}${category.toString().substring(10)}';
  }

  String capitalize(String str) {
    return str[0].toUpperCase() + str.substring(1);
  }

  String shortenVerb(PhrasalVerb pV) {
    return pV.name.toString().substring(5).replaceAll('\$', '');
  }

  String shortenPreposition(PhrasalVerb pV) {
    return pV.preposition.toString().substring(12).replaceAll('\$', '');
  }

  String shortenPrepositionNoPv(Preposition prep) {
    return prep.toString().substring(12).replaceAll('\$', '');
  }

  String shortenPreposition2(PhrasalVerb pV) {
    if (pV.secondPreposition != null) {
      return pV.secondPreposition.toString().substring(12).replaceAll('\$', '');
    } else {
      return '';
    }
  }

  List<PhrasalVerb> _verbs = [
    //
    //
    //
    //
    //FOOD
    PhrasalVerb(
      Verb.bolt,
      Preposition.down,
      'to eat a large amount of food very quickly',
      Category.food,
      'Jeffrey had only 15 minutes for lunch so he had to bolt it down',
    ),
    PhrasalVerb(
      Verb.boil,
      Preposition.over,
      'to cause liquid to overflow during boiling',
      Category.food,
      'She was cooking pasta on high heat and it boiled over',
    ),
    PhrasalVerb(
      Verb.chop,
      Preposition.up,
      'to cut into pieces',
      Category.food,
      'Jack is chopping up the onions for the salad',
    ),
    PhrasalVerb(
      Verb.cut,
      Preposition.back,
      'to consume less of a particular thing or food',
      Category.food,
      'Luise is lactose intolerant and had to cut back on dairy',
    ),
    PhrasalVerb(
      Verb.eat,
      Preposition.out,
      'to eat outside your home, especially in a restaurant',
      Category.food,
      'John and Kate eat out at least once a week and every time they choose a different restaurant',
    ),
    PhrasalVerb(
      Verb.pick,
      Preposition.up,
      'to collect something from another place',
      Category.food,
      'I’m going to an Italian restaurant to pick up our order',
    ),
    PhrasalVerb(
      Verb.whip,
      Preposition.up,
      'to prepare a meal very quickly',
      Category.food,
      'I had surprise visitors yesterday, thankfully I managed to whip up a light meal',
    ),
    PhrasalVerb(
      Verb.pig,
      Preposition.out,
      'to eat a lot',
      Category.food,
      'Alice is on a diet, but she always pigs out on her cheat days',
    ),
    PhrasalVerb(
      Verb.bake,
      Preposition.off,
      'to finish baking partly baked food',
      Category.food,
      'She baked off the bread in the oven',
    ),
    PhrasalVerb(
      Verb.boil,
      Preposition.away,
      'to cause liquid to evaporate completely by boiling',
      Category.food,
      'She forgot to switch off the cooker and all the water boiled away',
    ),
    PhrasalVerb(
      Verb.boil,
      Preposition.down,
      'to reduce a liquid by cooking to a thick sauce',
      Category.food,
      'The sauce was too thin and needed to be boiled down',
    ),
    PhrasalVerb(
      Verb.warm,
      Preposition.up,
      'to heat food that has already been cooked',
      Category.food,
      'My husband has to work late and I warm up food for him when he gets back home',
    ),
    PhrasalVerb(
      Verb.cut,
      Preposition.off,
      'to remove by cutting',
      Category.food,
      'He cut all the fat off',
    ),
    PhrasalVerb(
      Verb.cut,
      Preposition.out,
      'to shape or form by cutting',
      Category.food,
      'He cut several pieces of pastry out',
    ),
    PhrasalVerb(
      Verb.cut,
      Preposition.up,
      'to cut into pieces using a sharp knife',
      Category.food,
      'She cut the pie up into equal slices',
    ),
    PhrasalVerb(
      Verb.eat,
      Preposition.up,
      'to eat all the food that you have been given; to eat until everything is finished',
      Category.food,
      'Matt, eat up. I don’t want you to leave out broccoli again, it’s good for your health',
    ),
    PhrasalVerb(
      Verb.peel,
      Preposition.off,
      'to remove the skin/rind/outer covering of fruit/vegetables etc.',
      Category.food,
      'She peeled the skin off the apples for the fruit salad',
    ),
    PhrasalVerb(
      Verb.slice,
      Preposition.off,
      'to divide or cut something from a larger piece',
      Category.food,
      'He sliced the meat off the bone',
    ),
    //
    //FOOD
    //
    //
    //
    //
    //
    //
    //
    //
    //MONEY
    PhrasalVerb(
      Verb.pay,
      Preposition.off,
      'to finish paying money owed for something',
      Category.money,
      'We have finally paid off our mortgage after fifteen years',
    ),
    PhrasalVerb(
      Verb.live,
      Preposition.on,
      'If you live on an amount of money, that is the money that you use to buy only what you need',
      Category.money,
      'It\'s hard to imagine what these people live on',
    ),
    PhrasalVerb(
      Verb.fork,
      Preposition.out,
      'to spend a lot of money on something, especially unwillingly',
      Category.money,
      'We had to fork out a small fortune on their education',
    ),
    PhrasalVerb(
      Verb.run,
      Preposition.up,
      'to create lots of debt',
      Category.money,
      'How had he managed to run up so many debts?',
    ),
    PhrasalVerb(
      Verb.rip,
      Preposition.off,
      'to charge someone too much money for something',
      Category.money,
      'Tourists complain of being ripped off by local cab drivers',
    ),
    PhrasalVerb(
      Verb.save,
      Preposition.up,
      'to keep money so that you can buy something with it in the future',
      Category.money,
      'It took her months to save up enough money to go travelling',
    ),
    PhrasalVerb(
      Verb.put,
      Preposition.aside,
      'to save something, usually time or money, for a special purpose',
      Category.money,
      'She puts some money aside for her retirement',
    ),
    PhrasalVerb(
      Verb.squirrel,
      Preposition.away,
      'to put something away in a secret place, especially money',
      Category.money,
      'The family had a large fortune squirrelled away',
    ),
    PhrasalVerb(
      Verb.pay,
      Preposition.back,
      'to give someone the same amount of money that you borrowed from them',
      Category.money,
      'I’ll be able to pay you back next week',
    ),
    PhrasalVerb(
      Verb.splash,
      Preposition.out,
      'to buy something expensive that you do not really need',
      Category.money,
      'A young millionaire has just splashed out on a brand new car',
    ),
    PhrasalVerb(
      Verb.put,
      Preposition.down,
      'to pay part of the cost of something',
      Category.money,
      'We put a 10% deposit down on the apartment this afternoon',
    ),
    PhrasalVerb(
      Verb.come,
      Preposition.into,
      'to inherit; to be left money by somebody who has died',
      Category.money,
      'She came into a fortune when her wealthy uncle died',
    ),
    PhrasalVerb(
        Verb.cut,
        Preposition.back,
        'to reduce the amount of something, especially money that you spend',
        Category.money,
        'We’re trying to cut back on the amount we spend on food',
        secondPreposition: Preposition.on),
    PhrasalVerb(
      Verb.get,
      Preposition.by,
      'to be able to live or deal with a situation by having just enough of something you need, such as money',
      Category.money,
      'We can get by with four computers at the moment, but we\'ll need a couple more when the new staff arrive',
    ),
    PhrasalVerb(
      Verb.chip,
      Preposition.$in,
      'to contribute some money with other people',
      Category.money,
      'Instead of buying her separate presents, we can all chip in and buy her something big together',
    ),
    //
    //MONEY
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //RELATIONSHIPS
    //
    PhrasalVerb(
      Verb.hang,
      Preposition.out,
      'to spend time relaxing, usually with friends',
      Category.relationships,
      'In stead of a big party, I’ll invite a few friends to hang out at my house',
    ),

    PhrasalVerb(
      Verb.$throw,
      Preposition.out,
      'to force someone to leave a place or group',
      Category.relationships,
      'He was thrown out of the team for cheating',
    ),
    PhrasalVerb(
      Verb.ask,
      Preposition.over,
      'If you ask someone over, you invite the person to your house or apartment',
      Category.relationships,
      'My roommates and I are going to ask our English teacher over for lunch',
    ),
    PhrasalVerb(
      Verb.come,
      Preposition.over,
      'to visit someone in the place where they are, especially their house',
      Category.relationships,
      'Why don’t you come over to my place after class? We can work on the project together',
    ),
    PhrasalVerb(
      Verb.bring,
      Preposition.over,
      'to take someone or something from one place to the place where someone else is, especially their home',
      Category.relationships,
      'I\'ll bring my holiday photos over when I come',
    ),
    PhrasalVerb(
      Verb.blend,
      Preposition.into,
      'to assimilate; to look or seem the same as surrounding people or things and therefore not be easily noticeable',
      Category.relationships,
      'We tried to blend into the crowd',
    ),
    PhrasalVerb(
      Verb.rely,
      Preposition.on,
      'to trust someone or something to do something for you',
      Category.relationships,
      'Can we rely on him to support us?',
    ),
    PhrasalVerb(
      Verb.ask,
      Preposition.after,
      'to ask for information about someone, especially about their health',
      Category.relationships,
      'Tell your father I was asking after him',
    ),
    PhrasalVerb(
      Verb.make,
      Preposition.up,
      'to forgive someone and be friendly with them again after an argument or disagreement; reconcile',
      Category.relationships,
      'Has he made it up with her yet?',
    ),
    PhrasalVerb(
      Verb.split,
      Preposition.up,
      'to end a relationship',
      Category.relationships,
      'She’s split up with her boyfriend last month',
    ),
    PhrasalVerb(
      Verb.look,
      Preposition.up,
      'to respect and admire someone',
      Category.relationships,
      'I’ve always looked up to my father for his courage and determination',
      secondPreposition: Preposition.to,
    ),
    PhrasalVerb(
      Verb.fall,
      Preposition.out,
      'to argue with someone and stop being friendly with them',
      Category.relationships,
      'It was the first time Bill and I had fallen out',
    ),
    PhrasalVerb(
        Verb.make,
        Preposition.up,
        'to flatter; to be too friendly to someone or to praise them in order to get advantages for yourself',
        Category.relationships,
        'It was the first time Bill and I had fallen out',
        secondPreposition: Preposition.to),
    PhrasalVerb(
      Verb.put,
      Preposition.down,
      'to say bad things about someone; to insult',
      Category.relationships,
      'They never put down other companies in their commercials',
    ),
    PhrasalVerb(
      Verb.put,
      Preposition.up,
      'to tolerate; accept an unpleasant situation without complaining',
      Category.relationships,
      'I don\'t know how she puts up with his quick temper',
      secondPreposition: Preposition.$with,
    ),
    PhrasalVerb(
      Verb.ask,
      Preposition.out,
      'to invite someone to come with you to the cinema, restaurant, especially as a way of starting a romantic relationship',
      Category.relationships,
      'He\'s asked her out to the cinema this night',
    ),
    PhrasalVerb(
      Verb.$break,
      Preposition.up,
      'to end a romantic relationship or marriage',
      Category.relationships,
      'Jenny and George have broken up after dating for 6 months.',
    ),
    PhrasalVerb(
      Verb.get,
      Preposition.along,
      'to have a frindly relationship',
      Category.relationships,
      'I don\'t really get along with my wife\'s relatives',
    ),
    PhrasalVerb(
      Verb.get,
      Preposition.together,
      'to gather; If two or more people get together, they meet each other, having arranged it before',
      Category.relationships,
      'Let\'s get together on Friday in the pub for a drink',
    ),
    PhrasalVerb(
      Verb.fizzle,
      Preposition.out,
      'to gradually end, often in a disappointing or weak way; to negate',
      Category.relationships,
      'They went to different universities and their relationship just fizzled out',
    ),
    PhrasalVerb(
      Verb.come,
      Preposition.along,
      'to join or go somewhere with someone',
      Category.relationships,
      'I’ve never seen a baseball game. Do you mind if I come along?',
    ),
    PhrasalVerb(
      Verb.come,
      Preposition.about,
      'to happen',
      Category.relationships,
      'She was late again, but I\'m not sure how it came about this time',
    ),
    PhrasalVerb(
      Verb.run,
      Preposition.into,
      'to meet someone you know when you are not expecting to',
      Category.relationships,
      'I ran into my boss at the supermarket the other day',
    ),
    PhrasalVerb(
      Verb.let,
      Preposition.down,
      'to make someone disappointed by not doing what they expect you to do',
      Category.relationships,
      'You’ll be there tomorrow – you won’t let me down, will you?',
    ),
    PhrasalVerb(
      Verb.stick,
      Preposition.together,
      'to support, help and stay close to each other',
      Category.relationships,
      'We have to stick to together because we\'re a family',
    ),
    PhrasalVerb(
      Verb.turn,
      Preposition.to,
      'to ask someone for help',
      Category.relationships,
      'You can always turn to me for help if you need it',
    ),
    PhrasalVerb(
      Verb.invite,
      Preposition.$in,
      'to ask someone to come into your home',
      Category.relationships,
      'Out neightbours invited us in for coffee on last weekend ',
    ),
    PhrasalVerb(
      Verb.fit,
      Preposition.$in,
      'to feel that you belong to a particular group or situation',
      Category.relationships,
      'It\'s no surprise she\'s leaving - she never really fitted in. ',
    ),
    PhrasalVerb(
      Verb.show,
      Preposition.up,
      'to come, especially late or unexpectedly',
      Category.relationships,
      'I invited him for eight o\'clock, but he didn\'t show up until 9.30',
    ),
    PhrasalVerb(
      Verb.take,
      Preposition.after,
      'to be similar to an older member of your family in appearance or character',
      Category.relationships,
      'She takes after me with her love of horses',
    ),
    PhrasalVerb(
      Verb.lap,
      Preposition.up,
      'to do something with enthusiasm; to accept eagerly',
      Category.relationships,
      'He was lapping up just about everything to do with entrepreneurship and business',
    ),
    PhrasalVerb(
      Verb.drop,
      Preposition.$in,
      'to come for a visit, usually without having arranged it',
      Category.relationships,
      'Drop in whenever you’re in the neighborhood',
    ),
    PhrasalVerb(
      Verb.see,
      Preposition.off,
      'to go to the place that someone is leaving from in order to say goodbye to them',
      Category.relationships,
      'My parents saw me off at the airport',
    ),
    PhrasalVerb(
      Verb.turn,
      Preposition.around,
      'to make better; to become successful, after being unsuccessful for a period of time',
      Category.business,
      'Turning the company around won\'t be easy.',
    ),
    PhrasalVerb(
      Verb.take,
      Preposition.out,
      'to go with someone to a restaurant or theater and pay for them',
      Category.relationships,
      'He took her out for a celebratory dinner',
    ),
    PhrasalVerb(
      Verb.take,
      Preposition.$in,
      'to provide a place for someone to live or stay; to shelter',
      Category.relationships,
      'The daughter persuaded her parents to take in three homeless puppies',
    ),
    PhrasalVerb(
        Verb.fall,
        Preposition.out,
        'to stop being friendly with someone because you have a disagreement with them',
        Category.relationships,
        'I’d fallen out with my parents',
        secondPreposition: Preposition.$with),

    //
    //RELATIONSHIP
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //FAMILY
    //
    //
    //
    PhrasalVerb(
      Verb.bring,
      Preposition.up,
      'to nurture; to care for a child until it becomes an adult',
      Category.family,
      'He was brought up by his grandmother',
    ),
    PhrasalVerb(
      Verb.care,
      Preposition.$for,
      'take care of someone (especially when they’re old)',
      Category.family,
      'We’re looking for someone to care for my grandmother',
    ),
    PhrasalVerb(
        Verb.live,
        Preposition.up,
        'to do what is expected of you',
        Category.family,
        'Both his parents studied at Oxford University and have successful careers. It’s hard for him to live up to his parents’ expectations',
        secondPreposition: Preposition.to),
    PhrasalVerb(
      Verb.go,
      Preposition.by,
      'to use a particular name for yourself that is not your real name',
      Category.family,
      'When I knew her, she used to go by the name of Judy.',
    ),
    PhrasalVerb(
      Verb.grow,
      Preposition.apart,
      'to stop having a close relationship with somebody over a period of time',
      Category.family,
      'As we got older we just grew apart',
    ),
    PhrasalVerb(
      Verb.grow,
      Preposition.up,
      'to develop into an adult',
      Category.family,
      'Their children have all grown up and left home',
    ),
    PhrasalVerb(
      Verb.look,
      Preposition.after,
      'to take care of someone',
      Category.family,
      'It’s hard work looking after three children all day',
    ),
    PhrasalVerb(
      Verb.take,
      Preposition.after,
      'to look or behave like an older relative',
      Category.family,
      'She takes after me with her love of horses.',
    ),
    PhrasalVerb(
      Verb.tell,
      Preposition.off,
      'to criticize someone angrily for doing something wrong',
      Category.family,
      'She takes after me with her love of horses.',
    ),
    PhrasalVerb(
      Verb.settle,
      Preposition.down,
      'to get married and lead a calmer life',
      Category.family,
      'Eventually I\'d like to settle down and have a family, but not yet',
    ),
    PhrasalVerb(
      Verb.pass,
      Preposition.away,
      'to die (to avoid saying ‘die’ when you think this might upset someone)',
      Category.family,
      'My grandmother passed away 8 years ago.',
    ),
    //
    //
    //
    //FAMILY
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //WORK
    //
    PhrasalVerb(
      Verb.burn,
      Preposition.out,
      'to get extremely tired because of working too hard',
      Category.work,
      'If he doesn’t stop working so hard, he’ll burn himself out.',
    ),
    PhrasalVerb(
      Verb.give,
      Preposition.off,
      'to produce heat, light, a smell, or a gas',
      Category.work,
      'That tiny radiator doesn\'t give off much heat',
    ),
    PhrasalVerb(
      Verb.get,
      Preposition.ahead,
      'to be successful in the work that you do',
      Category.work,
      'If you are willing to work hard, you will get ahead in this organisation',
    ),
    PhrasalVerb(
      Verb.go,
      Preposition.about,
      'to do something that you normally do in your usual way; to start dealing with a problem',
      Category.work,
      'How can we go about solving this problem?',
    ),
    PhrasalVerb(
      Verb.make,
      Preposition.$for,
      'to result in; to help to make something possible',
      Category.work,
      'The new computers make for much greater productivity',
    ),
    PhrasalVerb(
        Verb.run,
        Preposition.away,
        'to avoid dealing with a problem or difficult situation',
        Category.work,
        'She told me to try to solve the problem instead of running away from it',
        secondPreposition: Preposition.from),
    PhrasalVerb(
      Verb.come,
      Preposition.up,
      'If a job or opportunity comes up, it becomes available',
      Category.work,
      'Job opportunities like this don\'t come up everyday',
    ),
    PhrasalVerb(
        Verb.get,
        Preposition.down,
        'to focus; to direct your efforts and attention towards something',
        Category.work,
        'I\'ve got a lot of work to do, but I can\'t seem to get down to it',
        secondPreposition: Preposition.to),
    PhrasalVerb(
      Verb.call,
      Preposition.off,
      'to cancel',
      Category.work,
      'They have called off the meeting at the last minute',
    ),
    PhrasalVerb(
      Verb.build,
      Preposition.on,
      'to do something in addition to what you have already achieved',
      Category.work,
      'We need to build on the ideas we have had so far',
    ),
    PhrasalVerb(
      Verb.carry,
      Preposition.out,
      'to perform or complete a job or activity',
      Category.work,
      'The building work was carried out by a local contractor',
    ),
    PhrasalVerb(
      Verb.draw,
      Preposition.up,
      'to prepare something in writing, especially an official document',
      Category.work,
      'The contract was drawn up by out lawyers over the weekend',
    ),
    PhrasalVerb(
      Verb.put,
      Preposition.off,
      'to delay doing something, especially because you do not want to do it',
      Category.work,
      'You can’t put the decision off any longer',
    ),
    PhrasalVerb(
      Verb.back,
      Preposition.up,
      'to help; to support an idea, plan or person',
      Category.work,
      'The others backed her up when she complained about very low wages.',
    ),
    PhrasalVerb(
      Verb.note,
      Preposition.down,
      'to write something so that you do not forget it',
      Category.work,
      'All her answers were noted down on the chart',
    ),
    PhrasalVerb(
      Verb.hand,
      Preposition.$in,
      'to give something to an authority or responsible person',
      Category.work,
      'You must all hand your projects in by the end of next week',
    ),
    PhrasalVerb(
      Verb.come,
      Preposition.by,
      'to achieve; to get something, using effort, by chance or in a way that has not been explained; to get something, especially something that is hard to get',
      Category.work,
      'Cheap organic food is still difficult to come by',
    ),
    PhrasalVerb(
        Verb.fill,
        Preposition.$in,
        'to do somebody’s job for a short time while they are not there',
        Category.work,
        'Could I fill in for him until he\'s back',
        secondPreposition: Preposition.$for),
    PhrasalVerb(
      Verb.knock,
      Preposition.off,
      'to stop working',
      Category.work,
      'I don\'t knock off for lunch until the most important job is done.',
    ),
    PhrasalVerb(
      Verb.knuckle,
      Preposition.down,
      'to start working or studying harder',
      Category.work,
      'You\'re going to have to really knuckle down if you want to pass your final exams',
    ),
    PhrasalVerb(
      Verb.lay,
      Preposition.off,
      'to stop employing someone for reasons that have nothing to do with the worker’s performance; to fire',
      Category.work,
      '200 workers at the factory have been laid off when the company moved to California.',
    ),
    PhrasalVerb(
      Verb.run,
      Preposition.by,
      'to tell someone about something, to make sure they understand or approve',
      Category.work,
      'I would like to run some ideas by my boss before we agree to the deal',
    ),
    PhrasalVerb(
      Verb.work,
      Preposition.on,
      'to spend time repairing or improving something',
      Category.work,
      'His jokes are good, but he needs to work on his delivery',
    ),
    PhrasalVerb(
      Verb.mop,
      Preposition.up,
      'to finish the last part of a job after most of it has been completed',
      Category.work,
      'We should be able to mop the rest of this up by the beginning of next week.',
    ),
    PhrasalVerb(
      Verb.slack,
      Preposition.off,
      'to work less hard',
      Category.work,
      'Workers tend to slack off on Mondays and Fridays',
    ),
    PhrasalVerb(
      Verb.take,
      Preposition.on,
      'to employ someone',
      Category.work,
      'The party has been taking on staff, including temporary organisers',
    ),
    PhrasalVerb(
      Verb.take,
      Preposition.over,
      'to take control of something; to do something instead of someone else',
      Category.work,
      'She took over marketing of this department last winter',
    ),
    PhrasalVerb(
      Verb.work,
      Preposition.out,
      'to develop in a particular way, usually a successful',
      Category.work,
      'Things have worked out quite well for us regardless of the initial setbacks',
    ),
    PhrasalVerb(
      Verb.make,
      Preposition.out,
      'to succeed; to deal with a situation in a successful way',
      Category.work,
      'The business made out better than expected and profits went slightly up',
    ),
    //
    //WORK
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //ILLNESS
    //
    //
    //
    PhrasalVerb(
      Verb.bring,
      Preposition.on,
      'to cause something bad to happen',
      Category.illness,
      'I think the loud music brought my headache on',
    ),
    PhrasalVerb(
      Verb.keep,
      Preposition.down,
      'to try not to vomit; to prevent something eaten from being vomited up',
      Category.illness,
      'The food was so spicy that I struggled to keep it down',
    ),
    PhrasalVerb(
      Verb.disagree,
      Preposition.$with,
      'to cause someone to feel ill or uncomfortable',
      Category.illness,
      'Spicy food disagrees with me',
    ),
    PhrasalVerb(
      Verb.wear,
      Preposition.off,
      'to weaken gradually; to stop having an effect or influence',
      Category.illness,
      'The vaccine wears off after 10 years',
    ),
    PhrasalVerb(
        Verb.come,
        Preposition.down,
        'to become ill; to show signs of an illness',
        Category.illness,
        'I seems like I’m coming down with a cold',
        secondPreposition: Preposition.$with),
    PhrasalVerb(
      Verb.$throw,
      Preposition.up,
      'to vomit',
      Category.illness,
      'The baby’s thrown up her dinner',
    ),
    PhrasalVerb(
      Verb.let,
      Preposition.up,
      'if something bad or unpleasant lets up, it slows down or stops',
      Category.illness,
      'A cold continues at its peak for several days, then it gradually lets up.',
    ),
    PhrasalVerb(
        Verb.go,
        Preposition.down,
        'to get sick; to start to suffer from an infectious disease',
        Category.illness,
        'Half of the class has gone down with flu',
        secondPreposition: Preposition.$with),
    PhrasalVerb(
      Verb.get,
      Preposition.over,
      'to recover from something',
      Category.illness,
      'It’s taken me ages to get over the flu',
    ),
    PhrasalVerb(
      Verb.lay,
      Preposition.up,
      'to force someone to stay in bed',
      Category.illness,
      'She’s laid up with a broken leg',
    ),

    //
    //
    //ILLNESS
    //
    //
    //
    //
    //
    //
    //
    //
    //LOVE
    //
    //
    //
    PhrasalVerb(
      Verb.fall,
      Preposition.$for,
      'to begin to be in love or to be attracted to somebody',
      Category.love,
      'They fell for each other instantly',
    ),
    PhrasalVerb(
      Verb.go,
      Preposition.out,
      'To date someone',
      Category.love,
      'They\'d been going out for almost five years before he married her',
    ),
    PhrasalVerb(
      Verb.ask,
      Preposition.out,
      'to ask someone on a date',
      Category.love,
      'He asked me out to the movies on Friday night',
    ),
    PhrasalVerb(
      Verb.hook,
      Preposition.up,
      'to have a physical relationship',
      Category.love,
      'We hooked up, but we are not dating',
    ),
    PhrasalVerb(
      Verb.make,
      Preposition.out,
      'to have sex, or to kiss and touch in a sexual way',
      Category.love,
      'They were making out all night.',
    ),
    //
    //
    //LOVE
    //
    //
    //HEALTH
    //
    //
    PhrasalVerb(
      Verb.keep,
      Preposition.away,
      'to conceal',
      Category.health,
      'Medicines should always be kept away from children',
    ),

    PhrasalVerb(
      Verb.tell,
      Preposition.on,
      'to have a bad effect on someone\'s health or behaviour',
      Category.health,
      'These endless business trips are telling on his marriage',
    ),
    PhrasalVerb(
      Verb.leave,
      Preposition.out,
      'to exclude something or someone',
      Category.health,
      'You should leave out the butter if you want to loose weight',
    ),

    PhrasalVerb(
      Verb.burn,
      Preposition.off,
      'If you burn off pounds or something that you have eaten, you do exercise',
      Category.health,
      'Running can help you burn off unwanted pounds',
    ),

    PhrasalVerb(
      Verb.bring,
      Preposition.around,
      'to make someone become conscious',
      Category.health,
      'Medics tried to bring him around but he is still unconscious',
    ),
    PhrasalVerb(
      Verb.cut,
      Preposition.down,
      'to reduce the amount or number of something; to do or use less of something',
      Category.health,
      'She used to work 16 hours a day, but recently she\'s cut down',
    ),

    PhrasalVerb(
      Verb.doze,
      Preposition.off,
      'to nap; to sleep during a day',
      Category.health,
      'The chemistry class was so boring I nearly dozed off at my desk',
    ),
    PhrasalVerb(
      Verb.pass,
      Preposition.out,
      'to become unconscious for a short time',
      Category.health,
      'He passed out because somebody hit him in the head',
    ),
    PhrasalVerb(
      Verb.put,
      Preposition.on,
      'to add or increase an amount or action; to gain weight',
      Category.health,
      'I put on 20 pounds when I went away to college',
    ),
    PhrasalVerb(
      Verb.slow,
      Preposition.down,
      'to be less active and relax more; to start working less',
      Category.health,
      'The doctor has told him to slow down or he\'ll have a heart attack.',
    ),

    PhrasalVerb(
      Verb.stay,
      Preposition.up,
      'to be awake; to go to bed later than usual',
      Category.health,
      'The kids were allowed to stay up till midnight on New Year\'s Eve.',
    ),

    PhrasalVerb(
      Verb.fight,
      Preposition.off,
      'to resist an illness',
      Category.health,
      'I’m trying to fight off a cold',
    ),
    PhrasalVerb(
      Verb.run,
      Preposition.over,
      'to hit someone or something with a vehicle and drive over them',
      Category.health,
      'Keeley was run over by a car outside her house',
    ),
    PhrasalVerb(
      Verb.fill,
      Preposition.out,
      'to get fat; to become heavier and more rounded',
      Category.health,
      'She has filled out so much in her face that I almost didn\'t recognize her',
    ),

    PhrasalVerb(
      Verb.get,
      Preposition.down,
      'to decrease',
      Category.health,
      'You should get down your daily sugar consumption',
    ),

    PhrasalVerb(
      Verb.come,
      Preposition.round,
      'to become conscious again after being unconscious',
      Category.health,
      'Your mother hasn’t yet come round from the anaesthetic',
    ),
    PhrasalVerb(
      Verb.work,
      Preposition.out,
      'to train the body by physical exercising',
      Category.health,
      'I work out regularly to keep fit',
    ),

    PhrasalVerb(
      Verb.warm,
      Preposition.up,
      'to prepare yourself for a physical activity by doing some gentle exercises and stretches',
      Category.health,
      'If you don\'t warm up before exercising, you risk injuring yourself',
    ),

    PhrasalVerb(
      Verb.get,
      Preposition.up,
      'to rise or to stand up',
      Category.health,
      'The whole audience got up and started clapping',
    ),

    PhrasalVerb(
        Verb.cool,
        Preposition.down,
        'to continue to exercise gently to prevent injury after you have done more difficult exercises',
        Category.health,
        'After you\'ve cooled down from a hard run, you should refuel as soon as you can.',
        secondPreposition: Preposition.$with),
    //
    //
    //HEALTH
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //EMOTIONS
    //
    //
    //
    PhrasalVerb(
      Verb.shake,
      Preposition.up,
      'to shock; to upset or frighten someone by shocking or surprising them',
      Category.emotions,
      'A series of robberies has shaken up residents in this area',
    ),
    PhrasalVerb(
      Verb.blow,
      Preposition.up,
      'to suddenly become very angry',
      Category.emotions,
      'My dad may blow up when he finds out how much I spend on clothes',
    ),
    PhrasalVerb(
      Verb.cool,
      Preposition.down,
      'to become, or to cause someone to become, less angry or excited',
      Category.emotions,
      'Just try to cool down and think rationally',
    ),
    PhrasalVerb(
      Verb.heat,
      Preposition.up,
      'if a situation heats up, it becomes more exciting, dangerous, or serious',
      Category.emotions,
      'The dispute was already heating up',
    ),
    PhrasalVerb(
      Verb.flip,
      Preposition.out,
      'to infuriate; to become extremely angry or to lose control of yourself from surprise or shock',
      Category.emotions,
      'I nearly flipped out when she told me she and David were getting married',
    ),
    //
    //
    //
    //EMOTIONS
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //ANIMAL
    //
    //
    //
    //
    PhrasalVerb(
      Verb.chicken,
      Preposition.out,
      'to decide not to do something because you are too frightened',
      Category.animal,
      'I was going to go bungee jumping but I chickened out at the last minute.',
    ),
    PhrasalVerb(Verb.duck, Preposition.out, 'to avoid doing something',
        Category.animal, 'You can\'t duck out of your responsibilities',
        secondPreposition: Preposition.of),

    PhrasalVerb(
      Verb.fish,
      Preposition.$for,
      'to ask for or try to get something in an indirect way',
      Category.animal,
      'The telephone caller was fishing for too much information, so I hung up',
    ),
    PhrasalVerb(
      Verb.fish,
      Preposition.out,
      'to pull something out of water or take something out of a bag or pocket',
      Category.animal,
      'She fished a piece of paper out of the pile of the desk',
    ),
    PhrasalVerb(
      Verb.duck,
      Preposition.out,
      'to leave a place quietly and secretly',
      Category.animal,
      'If I can I’ll duck out to get something to eat',
    ),
    PhrasalVerb(
      Verb.horse,
      Preposition.around,
      'to behave or play in a silly and noisy way',
      Category.animal,
      'He was horsing around in the kitchen and broke my favourite bowl',
    ),
    PhrasalVerb(
      Verb.leech,
      Preposition.off,
      'to use someone for personal gain, not giving anything in return',
      Category.animal,
      'He’s leeching off the abilities of others',
    ),
    PhrasalVerb(
      Verb.pig,
      Preposition.out,
      'to eat a lot of food at once',
      Category.animal,
      'Kids tend to pig out on junk food',
    ),
    PhrasalVerb(
      Verb.wolf,
      Preposition.down,
      'to eat very quickly',
      Category.animal,
      'Don’t wolf down an entire chocolate cake; you will get indigestion',
    ),
    PhrasalVerb(
      Verb.monkey,
      Preposition.around,
      'to do things in an unserious way; to behave in a silly, playful way',
      Category.animal,
      'The kids were just monkeying around, throwing things at each other',
    ),
    PhrasalVerb(
      Verb.beaver,
      Preposition.away,
      'to work hard for a long time',
      Category.animal,
      'She was beavering away at his homework until midnight',
    ),
    PhrasalVerb(
      Verb.ferret,
      Preposition.out,
      'to discover someone or something, especially information, after searching for it in a determined way',
      Category.animal,
      'I had to ferret out all the information for myself',
    ),
    PhrasalVerb(
        Verb.worm,
        Preposition.out,
        'to gradually get information from someone who does not want to give it to you',
        Category.animal,
        'I eventually managed to worm a few details out of him',
        secondPreposition: Preposition.of),
    PhrasalVerb(
      Verb.rat,
      Preposition.on,
      'to tell someone in authority about something that someone you know has done wrong',
      Category.animal,
      'He was arrested in a few days after John rat on him',
    ),
    PhrasalVerb(
      Verb.rabbit,
      Preposition.on,
      'to continue talking about something that is not interesting to the person you are talking to',
      Category.animal,
      'He\'s always rabbiting on about his art collection',
    ),
    PhrasalVerb(
      Verb.monkey,
      Preposition.around,
      'to touch, change, or treat something in a careless or harmful way',
      Category.animal,
      'Come on, don’t monkey around with my new laptop. It\'s too expensive',
    ),

    PhrasalVerb(
      Verb.drone,
      Preposition.on,
      'to talk for a long time in a boring way',
      Category.animal,
      'I nearly fell asleep while he was droning on about science',
    ),
    PhrasalVerb(
      Verb.clam,
      Preposition.up,
      'to become silent; to stop talking, to shut up',
      Category.animal,
      'She just clams up if you ask her about her family',
    ),
    PhrasalVerb(
      Verb.hound,
      Preposition.out,
      'to force somebody to leave a job or a place, especially by making their life difficult and unpleasant',
      Category.animal,
      'They were hounded out of the country',
    ),
    PhrasalVerb(
      Verb.beef,
      Preposition.up,
      'to increase or improve something, or to make it more interesting',
      Category.animal,
      'The hotel plans to beef up its marketing effort',
    ),
    //
    //
    //
    //ANIMAL
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //BUSINESS
    //
    //
    PhrasalVerb(
      Verb.branch,
      Preposition.out,
      'to start a business activity or a job that is different from what you usually do',
      Category.business,
      'After a couple of years working for other people, she branched out on her own',
    ),
    PhrasalVerb(
      Verb.$break,
      Preposition.into,
      'to begin working in a new business or a new area',
      Category.business,
      'It’s always been his ambition to break into the advertising business',
    ),
    PhrasalVerb(
      Verb.carry,
      Preposition.on,
      'to continue',
      Category.business,
      'He had to move to New York to carry on his business',
    ),
    PhrasalVerb(
      Verb.close,
      Preposition.down,
      'to stop operating',
      Category.business,
      'The firm has decided to close down its Chicago branch',
    ),
    PhrasalVerb(
        Verb.look,
        Preposition.forward,
        'to feel pleased and excited about something that is going to happen',
        Category.business,
        'We look forward to hearing from you soon',
        secondPreposition: Preposition.to),

    PhrasalVerb(
      Verb.rule,
      Preposition.out,
      'to prevent something from happening',
      Category.business,
      'The warehouse fire has ruled out any chance that we will make a profit this year.',
    ),
    PhrasalVerb(
      Verb.step,
      Preposition.down,
      'to leave a position or job',
      Category.business,
      'The chairman was forced to step down due to poor health',
    ),
    PhrasalVerb(
      Verb.take,
      Preposition.off,
      'to suddenly become successful or popular',
      Category.business,
      'Her business had just begun to take off',
    ),
    PhrasalVerb(
      Verb.scrape,
      Preposition.up,
      'to gather something with difficulty, especially money; to succeed in getting enough of something ',
      Category.business,
      'He\'s struggling to scrape up enough money to buy a new car',
    ),
    PhrasalVerb(
      Verb.fill,
      Preposition.up,
      'to fill space or time',
      Category.business,
      'My day is completely taken up with meetings',
    ),
    PhrasalVerb(
      Verb.come,
      Preposition.up,
      'to happen or arise, usually unexpectedly',
      Category.business,
      'I’m going to cancel our meeting – something has just come up at home and I\'m needed there',
    ),
    PhrasalVerb(
      Verb.beat,
      Preposition.down,
      'to persuade a person or organization to accept a lower amount of money for something that they are selling',
      Category.business,
      'They tried to beat us down on the price, but we remained firm',
    ),
    PhrasalVerb(
      Verb.bring,
      Preposition.out,
      'to produce something for people to buy',
      Category.business,
      'How many books did this publisher brought out?',
    ),
    PhrasalVerb(
        Verb.keep,
        Preposition.up,
        'to follow; to do whatever is necessary to stay equal',
        Category.business,
        'Technology changes so fast that it\'s hard to keep up with it',
        secondPreposition: Preposition.$with),
    PhrasalVerb(
      Verb.set,
      Preposition.up,
      'to prepare (a business) for use',
      Category.business,
      'They\'re planning to set up their own marketing asgency',
    ),
    PhrasalVerb(
      Verb.go,
      Preposition.through,
      'to experience something bad',
      Category.business,
      'I\'ve gone through a lot in order to make my company succeed',
    ),
    PhrasalVerb(
      Verb.find,
      Preposition.out,
      'to discover a fact or piece of information',
      Category.business,
      'Can you find out which marketing strategies do our competitors use?',
    ),
    PhrasalVerb(
      Verb.deal,
      Preposition.$with,
      'to handle a problem',
      Category.business,
      'He’s good at dealing with pressure',
    ),
    PhrasalVerb(
      Verb.fill,
      Preposition.out,
      'to complete a form',
      Category.business,
      'It took me several hours to fill out the application form',
    ),
    PhrasalVerb(
      Verb.bring,
      Preposition.down,
      'to reduce the amount of something',
      Category.business,
      'We aim to bring down prices on all our computers',
    ),
    PhrasalVerb(
      Verb.join,
      Preposition.$in,
      'to participate in an activity with other people',
      Category.business,
      'We would be eager to join in projects of that sort',
    ),
    PhrasalVerb(
      Verb.put,
      Preposition.back,
      'to delay or postpone',
      Category.business,
      'The meeting has been put back to the next week',
    ),
    PhrasalVerb(
      Verb.run,
      Preposition.out,
      'to have no more of something; to finish the supply of something',
      Category.business,
      'Many companies are running out of money',
      secondPreposition: Preposition.of,
    ),
    PhrasalVerb(
      Verb.sort,
      Preposition.out,
      'to deal successfully with a problem or a situation',
      Category.business,
      'Her financial records are a mess, but we’ll sort them out',
    ),
    PhrasalVerb(
      Verb.take,
      Preposition.on,
      'to start to employ someone',
      Category.business,
      'We’re not taking on any new staff at the moment',
    ),
    PhrasalVerb(
      Verb.bail,
      Preposition.out,
      'to rescue somebody from a difficult situation, especially financial problems',
      Category.business,
      'The bank helped to bail out the struggling company',
    ),
    PhrasalVerb(
      Verb.go,
      Preposition.under,
      'to become bankrupt; to fail financially',
      Category.business,
      'The company will go under unless a genrous investor can be found within the next few weeks',
    ),
    PhrasalVerb(
      Verb.fall,
      Preposition.through,
      'to fail to happen',
      Category.business,
      'We found a buyer for our house, but then the sale fell through',
    ),
    PhrasalVerb(
      Verb.pull,
      Preposition.out,
      'to move away from something or stop being involved in it',
      Category.business,
      'The project became so expensive that we had to pull out',
    ),
    PhrasalVerb(
      Verb.bottom,
      Preposition.out,
      'to stop getting worse and be about to improve',
      Category.business,
      'Property prices are still falling, and show no signs of bottoming out',
    ),
    PhrasalVerb(
      Verb.come,
      Preposition.down,
      'to decline; to become less in amount, level, price etc',
      Category.business,
      'House prices have come down recently',
    ),
    PhrasalVerb(
      Verb.level,
      Preposition.off,
      'to stop rising or falling and become steady',
      Category.business,
      'Inflation has begun to level off',
    ),
    PhrasalVerb(
      Verb.come,
      Preposition.off,
      'to happen as planned, or to succeed',
      Category.business,
      'Despite some small problems, the meeting came off pretty smoothly',
    ),
    PhrasalVerb(
      Verb.start,
      Preposition.up,
      'to open a business',
      Category.business,
      'We started up this company on a shoestring',
    ),

    PhrasalVerb(
      Verb.put,
      Preposition.into,
      'to spend a lot of time or effort doing something',
      Category.business,
      'We\'ve put a lot of effort into this project',
    ),
    PhrasalVerb(
      Verb.go,
      Preposition.ahead,
      'to start to do something',
      Category.business,
      'The meeting will go ahead as planned',
    ),
    PhrasalVerb(
      Verb.keep,
      Preposition.down,
      'to control something and prevent it from increasing in size or number',
      Category.business,
      'We have to try and keep costs down',
    ),
    PhrasalVerb(
      Verb.put,
      Preposition.forward,
      'to propose; to suggest an idea for consideration',
      Category.business,
      'None of the ideas that I put forward have been accepted',
    ),
    PhrasalVerb(
      Verb.wind,
      Preposition.up,
      'to close a business, especially when it is not successful and has debts',
      Category.business,
      'The company was wound up in February with debts of \$7.5 million',
    ),
    PhrasalVerb(
      Verb.turn,
      Preposition.around,
      'to supply or complete something in a particular time; to successfully deal with a problem or difficulty',
      Category.work,
      'The company claims to turn orders around in 24 hours.',
    ),
    PhrasalVerb(
      Verb.think,
      Preposition.through,
      'to carefully consider the possible results of doing something',
      Category.business,
      'I need some time to think it through. I don\'t want to make a wrong decision',
    ),
    PhrasalVerb(
      Verb.drop,
      Preposition.off,
      'to become lower in level, value, price, etc; to decline',
      Category.business,
      'The demand for Blackberry smartphone dropped off after iPhone entered the market',
    ),
    PhrasalVerb(
      Verb.run,
      Preposition.over,
      'to exceed; to continue after the expected finishing time',
      Category.business,
      'We already ran over by 20 minutes, so could you keep your speeches short, please',
    ),
    PhrasalVerb(
      Verb.run,
      Preposition.over,
      'to defend or support a particular idea or a person who is being criticized or attacked',
      Category.business,
      'He\'s the kind of manager who will always stand up for his staff',
    ),
    //
    //
    //BUSINESS
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //TECHNOLOGY
    //
    //
    PhrasalVerb(
      Verb.log,
      Preposition.$in,
      'to connect to a computer using a username and password',
      Category.technology,
      'If you are already a registered user, please log in',
    ),
    PhrasalVerb(
      Verb.type,
      Preposition.$in,
      'to enter data with a keyboard',
      Category.technology,
      'How can I type in my password if I can’t remember it?',
    ),
    PhrasalVerb(
        Verb.scroll,
        Preposition.down,
        'to move the screen down. The opposite is to scroll up',
        Category.technology,
        'The reason you can’t see the image at the bottom of the document is because you haven’t scrolled down enough,'),
    PhrasalVerb(
      Verb.boot,
      Preposition.up,
      'If a computer boots, or if you boot it, it starts working and becomes ready to use',
      Category.technology,
      'It’ll take my laptop a couple of minutes to finish booting up.',
    ),
    PhrasalVerb(
      Verb.set,
      Preposition.up,
      'to install a new computer program or assemble a computer system',
      Category.technology,
      'This application took a long time to set up.',
    ),
    PhrasalVerb(
      Verb.click,
      Preposition.on,
      'to move a mouse over an item and press to select',
      Category.technology,
      'Click on the start menu to begin',
    ),
    PhrasalVerb(
      Verb.hack,
      Preposition.into,
      'to enter a computer or network illegally',
      Category.technology,
      'Someone hacked into my bank account and stole millions of dollars.',
    ),
    PhrasalVerb(
      Verb.plug,
      Preposition.$in,
      'to insert a cord into an outlet or port',
      Category.technology,
      'Plug in your laptop over there.',
    ),
    PhrasalVerb(
      Verb.sign,
      Preposition.up,
      'to register with a service',
      Category.technology,
      'She signed up on an online dating website',
    ),
    PhrasalVerb(
      Verb.shut,
      Preposition.down,
      'if a machine or computer shuts down, or if someone shuts it down, it stops operating',
      Category.technology,
      'Sometimes I forget to shut down my computer before I go home. It means it’s running all night',
    ),
    PhrasalVerb(
      Verb.pop,
      Preposition.up,
      'to appear suddenly on a computer screen',
      Category.technology,
      'If you do not want to see the ads, turn on your pop up blocker.',
    ),
    PhrasalVerb(
      Verb.back,
      Preposition.up,
      'to make a copy of information',
      Category.technology,
      'It’s a good idea to back up your files from time to time',
    ),

    PhrasalVerb(
      Verb.wipe,
      Preposition.off,
      'to erase; to remove something from something',
      Category.technology,
      'All their customer information was wiped off the computer by a virus',
    ),
    PhrasalVerb(
      Verb.print,
      Preposition.out,
      'to produce a copy of a computer document from a printer',
      Category.technology,
      'Should I print out that graph now?',
    ),
    PhrasalVerb(
      Verb.pull,
      Preposition.down,
      'to click on an item with a mouse that opens a list of options.',
      Category.technology,
      'Pull the menu down and select the first command',
    ),
    //
    //
    //TECHNOLOGY
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //COMMUNICATION
    //
    //
    PhrasalVerb(
      Verb.bring,
      Preposition.up,
      'to start talking about a particular topic',
      Category.business,
      'I hate to bring up business at lunch',
    ),
    PhrasalVerb(
      Verb.cope,
      Preposition.$with,
      'to tackle something successfully despite of difficulties and problems',
      Category.communication,
      'In order to succeed in this business you should have to cope with good communication skills, as it’s a primary condition of the corporate world',
    ),
    PhrasalVerb(
      Verb.bristle,
      Preposition.at,
      'to be angry or offended about something',
      Category.communication,
      'He bristled at the suggestion that he was like his father',
    ),
    PhrasalVerb(
      Verb.fight,
      Preposition.back,
      'to defend yourself against attack or criticism',
      Category.communication,
      'You’ve seen him fight back every time he’s been unfairly attacked',
    ),
    PhrasalVerb(
      Verb.fess,
      Preposition.up,
      'to admit that something is true or that you have done something wrong',
      Category.communication,
      'It’s time to fess up – did you spend all that money?',
    ),
    PhrasalVerb(
        Verb.talk,
        Preposition.down,
        'to talk to someone as if you think they are not as clever or important as you are',
        Category.communication,
        'Try not to talk down to your employees.',
        secondPreposition: Preposition.to),
    PhrasalVerb(
      Verb.speak,
      Preposition.up,
      'to express your opinion frankly and publicly',
      Category.communication,
      'If anyone has a better idea, please speak up.',
    ),
    PhrasalVerb(
      Verb.bring,
      Preposition.around,
      'to persuade someone to have the same opinion as you have',
      Category.communication,
      'At first they refused but I managed to bring them around',
    ),
    PhrasalVerb(
      Verb.work,
      Preposition.on,
      'to try to persuade or influence someone',
      Category.communication,
      'I\'m working on my father to get him to let me go to the party',
    ),
    PhrasalVerb(
      Verb.call,
      Preposition.out,
      'to shout something, especially when you are trying to get someone’s attention',
      Category.communication,
      'He called out, but she didn\'t hear him',
    ),
    PhrasalVerb(
      Verb.put,
      Preposition.off,
      'to make someone not want to do something, or to make someone not like someone or something',
      Category.communication,
      'Robert’s attitude towards women really puts me off',
    ),
    PhrasalVerb(
      Verb.point,
      Preposition.out,
      'to direct attention toward something',
      Category.communication,
      'He pointed out the best beaches on the map',
    ),
    PhrasalVerb(
      Verb.spell,
      Preposition.out,
      'to describe or explain it very carefully in a detailed and meticulous way',
      Category.communication,
      'It’s frustrating when you have to spell everything out for them.',
    ),
    PhrasalVerb(
      Verb.cut,
      Preposition.off,
      'to interrupt the person in the middle of a sentence',
      Category.communication,
      'Don’t cut me off when I’m talking',
    ),
    PhrasalVerb(
      Verb.rattle,
      Preposition.off,
      'to say something quickly, especially something that you have learned by memory',
      Category.communication,
      'She rattled off the names of everyone coming to the party',
    ),
    PhrasalVerb(
      Verb.blurt,
      Preposition.out,
      'to say something suddenly and without thinking about the effect it will have, usually because you are nervous or excited',
      Category.communication,
      'She blurted out his name, then gasped as she realized what she’d done',
    ),
    PhrasalVerb(
      Verb.butt,
      Preposition.$in,
      'to interrupt a conversation',
      Category.communication,
      'It is rude to butt in when two people are having a discussion',
    ),
    //
    //
    //COMMUNICATION
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //SKILLS
    //
    //
    //
    //
    //
    //SKILLS
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //DECISION
    //
    //
    PhrasalVerb(
      Verb.weigh,
      Preposition.up,
      'to think carefully about the advantages or disadvantages of a situation before making a decision; to evaluate',
      Category.decision,
      'I\'m weighing up the consequences before I decide to leave the job',
    ),
    PhrasalVerb(
      Verb.yield,
      Preposition.to,
      'to agree to do something that you do not want to do or should not do',
      Category.decision,
      'It\'s very easy to yield to temptation and spend too much money.',
    ),

    PhrasalVerb(
      Verb.allow,
      Preposition.$for,
      'to take something into consideration; to take into account',
      Category.decision,
      'We have to allow for the possibility of the project being delayed',
    ),
    PhrasalVerb(
        Verb.talk,
        Preposition.out,
        'to persuade someone not to do something',
        Category.decision,
        'Her parents tried to talk her out of getting engaged.',
        secondPreposition: Preposition.of),
    PhrasalVerb(Verb.carry, Preposition.on, 'to resume;', Category.decision,
        'Just carry on with with doing your homework',
        secondPreposition: Preposition.$with),

    PhrasalVerb(
      Verb.stand,
      Preposition.out,
      'to be very noticeable, striking, much better than other similar things or people',
      Category.decision,
      'The black lettering really stands out on that orange background.',
    ),
    PhrasalVerb(
      Verb.stick,
      Preposition.to,
      'to limit yourself to doing one particular thing and not change to anything else',
      Category.decision,
      'I think we should stick to our original plan.',
    ),
    PhrasalVerb(
      Verb.back,
      Preposition.down,
      'to admit you were wrong, or to stop supporting a position',
      Category.decision,
      'She refused to back down and was fired immediately',
    ),
    PhrasalVerb(
      Verb.back,
      Preposition.down,
      'to convince; to persuade someone to do something',
      Category.decision,
      'She doesn\'t really want to go to the museum, but I think I can talk her into it',
    ),
    PhrasalVerb(
      Verb.match,
      Preposition.up,
      'if one thing matches up with another, or if they match up, they are the same or have similar qualities',
      Category.decision,
      'Information received from the two resources didn’t match up',
    ),
    //
    //
    //DECISION
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //EDUCATION
    //
    //
    //
    PhrasalVerb(
      Verb.find,
      Preposition.out,
      'to learn something that you didn’t know',
      Category.education,
      'Please click on the following link to find out about the lessons provided in school',
    ),
    PhrasalVerb(
      Verb.look,
      Preposition.up,
      'to find a piece of information in a book, internet, etc',
      Category.education,
      'Can you give me his last name, so I can look up his email address?',
    ),
    PhrasalVerb(
      Verb.be,
      Preposition.into,
      'to be interested in something',
      Category.education,
      'Are you into English?',
    ),
    PhrasalVerb(
      Verb.think,
      Preposition.up,
      'to invent or to imagine something',
      Category.education,
      'She’d have to think up a good excuse for being late',
    ),
    PhrasalVerb(
      Verb.turn,
      Preposition.into,
      'to evolve; to change or develop from one thing to another',
      Category.education,
      'Rain in the morning will turn into snow during the afternoon',
    ),

    PhrasalVerb(
      Verb.zone,
      Preposition.out,
      'to disregard; to stop paying attention and not hear or see what is around you for a short period of time',
      Category.education,
      'When the teacher started talking about nuclear physics, I just zone out',
    ),
    PhrasalVerb(
      Verb.sail,
      Preposition.through,
      'to do something, or to deal with something, very easily',
      Category.education,
      'After a year he returned to the college and sailed through his final exams',
    ),
    PhrasalVerb(
      Verb.take,
      Preposition.up,
      'to start doing something regularly as a habit, job, or interest',
      Category.education,
      'I\'ve taken up English recently',
    ),
    PhrasalVerb(
      Verb.fall,
      Preposition.behind,
      'to make less progress than other people; to fail to do something fast enough or on time',
      Category.education,
      'My daughter is falling behind with her school work',
    ),
    PhrasalVerb(
      Verb.go,
      Preposition.over,
      'to check something carefully',
      Category.education,
      'Remember to go over your essay to check for grammar and spelling mistakes before you hand it in',
    ),
    PhrasalVerb(
      Verb.$catch,
      Preposition.up,
      'to improve and reach the same level as other people',
      Category.education,
      'If you miss a lot of classes, it’s very difficult to catch up',
    ),
    PhrasalVerb(
        Verb.read,
        Preposition.up,
        'to study something by reading a lot about it',
        Category.education,
        'I need to read up on my British history',
        secondPreposition: Preposition.on),
    PhrasalVerb(
      Verb.hand,
      Preposition.out,
      'to give things to different people in a group',
      Category.education,
      'Could you hand these papers out, please?',
    ),
    PhrasalVerb(
        Verb.copy,
        Preposition.out,
        'to write something again exactly as it was written',
        Category.education,
        'We need to copy out a few sentences from a book',
        secondPreposition: Preposition.on),
    PhrasalVerb(
      Verb.drop,
      Preposition.out,
      'to leave school without finishing your studies',
      Category.education,
      'She started a degree but dropped out after only a year',
    ),
    PhrasalVerb(
      Verb.water,
      Preposition.down,
      'to soften; to make something weaker or less effective',
      Category.education,
      'The law was watered down after it failed to pass the legislature the first time',
    ),

    //
    //
    //
    //DEGREE
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //CLOTHES
    //
    //
    //
    PhrasalVerb(
      Verb.$do,
      Preposition.up,
      'to fasten an item of clothing',
      Category.clothes,
      'You don’t need to do up the top button',
    ),
    PhrasalVerb(
      Verb.dress,
      Preposition.up,
      'to put on formal clothes for a special occasion',
      Category.clothes,
      'You don’t need to dress up. It’s just a family get-together',
    ),
    PhrasalVerb(
      Verb.dress,
      Preposition.down,
      'to wear clothes that are more informal than those you usually wear',
      Category.clothes,
      'Staff have been told that they can dress down on Fridays.',
    ),
    PhrasalVerb(
      Verb.hang,
      Preposition.out,
      'to dry clothes outside after washing',
      Category.clothes,
      'Have you hung the washing out?',
    ),
    PhrasalVerb(
      Verb.kick,
      Preposition.off,
      'to make your shoes come off by shaking your feet',
      Category.clothes,
      'He kicked his shoes off as soon as he got home',
    ),
    PhrasalVerb(
      Verb.slip,
      Preposition.on,
      'to put clothing on quickly and easily',
      Category.clothes,
      'She slipped her sandals on before she went into the sea',
    ),
    PhrasalVerb(
      Verb.take,
      Preposition.$in,
      'to make a piece of clothing more narrow or tight, so that it fits you',
      Category.clothes,
      'I’ll have to take this dress in at the waist – it’s too big',
    ),
    PhrasalVerb(
      Verb.take,
      Preposition.up,
      'to make a piece of clothing shorter, especially by making a fold along the bottom edge',
      Category.clothes,
      'I want to take this pair of pants up. It’s too long.',
    ),
    PhrasalVerb(
      Verb.$throw,
      Preposition.on,
      'to put on a piece of clothing quickly and carelessly',
      Category.clothes,
      'She just threw on the first skirt she found.',
    ),

    PhrasalVerb(
      Verb.wrap,
      Preposition.up,
      'to wear enough clothes to keep you warm',
      Category.clothes,
      'I could hear my mother telling me to wrap up warm.',
    ),
    PhrasalVerb(
      Verb.zip,
      Preposition.up,
      'to be closed by means of a zip',
      Category.clothes,
      'He zipped up his leather jacket',
    ),
    PhrasalVerb(
      Verb.let,
      Preposition.out,
      'to make clothing wider',
      Category.clothes,
      'I’m going to have this skirt let out',
    ),
    PhrasalVerb(
      Verb.show,
      Preposition.off,
      'to behave in a way that is intended to attract attention or admiration',
      Category.clothes,
      'He bought her a ring and she is showing it off to everyone',
    ),
    PhrasalVerb(
      Verb.wear,
      Preposition.out,
      'to use an item until it is no longer in good condition',
      Category.clothes,
      'I wore out my boots. I need to buy a new pair soon.',
    ),
    PhrasalVerb(
      Verb.go,
      Preposition.$with,
      'If one thing goes with another, they suit each other or they look or taste good together',
      Category.clothes,
      'Do you think this shirt goes with these trousers?',
    ),
    //
    //
    //
    //CLOTHES
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //HOUSE
    //
    //
    //
    PhrasalVerb(
      Verb.$throw,
      Preposition.away,
      'to put something into the trash; to get rid of something',
      Category.house,
      'He wanted to throw away the cup, but he couldn’t find a trash can',
    ),
    PhrasalVerb(
      Verb.pick,
      Preposition.up,
      'to lift someone or something up from a surface',
      Category.house,
      'When you pick up the bag, make sure to support the bottom',
    ),
    PhrasalVerb(
      Verb.sweep,
      Preposition.up,
      'to clean and remove dirt or dust from a floor or the ground using a brush or broom',
      Category.house,
      'Would you sweep up the broken glass?',
    ),
    PhrasalVerb(
      Verb.hang,
      Preposition.up,
      'to hang a piece of clothing on something',
      Category.house,
      'We hang our clothes up in the closet',
    ),
    PhrasalVerb(
      Verb.put,
      Preposition.away,
      'to put something in the place where you usually keep it',
      Category.house,
      'He put the notebook away and stood up.',
    ),
    PhrasalVerb(
      Verb.clean,
      Preposition.up,
      'to make a place completely clean and tidy',
      Category.house,
      'We spent all Saturday morning cleaning up our rooms',
    ),
    PhrasalVerb(
      Verb.mop,
      Preposition.up,
      'Use a mop (towel or sponge) to remove liquid from the floor',
      Category.house,
      'Why am I the one who has to mop up after the mess you made!',
    ),
    PhrasalVerb(
      Verb.build,
      Preposition.on,
      'to build a new room or part onto the outside of a building',
      Category.house,
      'We’re planning to build on a conservatory',
    ),
    PhrasalVerb(
      Verb.turn,
      Preposition.on,
      'to make a piece of equipment start working by pressing a button or moving a switch',
      Category.house,
      'Do you want me to turn the lamp on?',
    ),
    PhrasalVerb(
      Verb.turn,
      Preposition.off,
      'to make a piece of equipment stop working',
      Category.house,
      'It’s too noisy. Turn off the TV please',
    ),
    PhrasalVerb(
      Verb.put,
      Preposition.up,
      'to attach a picture, or other object to the wall to hang',
      Category.house,
      'I put a few posters up to make the room look less bare.',
    ),
    PhrasalVerb(
      Verb.take,
      Preposition.down,
      'to remove (a picture or object) from the wall',
      Category.house,
      'She made us take down all the pictures',
    ),
    PhrasalVerb(
      Verb.stock,
      Preposition.up,
      'to buy a large quantity of something',
      Category.house,
      'We need to stock up the freezer',
    ),
    PhrasalVerb(
      Verb.put,
      Preposition.on,
      'to make a machine or piece of equipment start working, especially by pressing a switch',
      Category.house,
      'Do you mind if I put some music on?',
    ),
    PhrasalVerb(
      Verb.put,
      Preposition.out,
      'to extinguish; to make something stop burning',
      Category.house,
      'It took firefighters three hours to put the fire out',
    ),

    //
    //
    //
    //
    //HOUSE
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //PHONE
    //
    //
    //
    PhrasalVerb(
      Verb.$break,
      Preposition.up,
      'if the sound on a radio or mobile phone breaks up, you can no longer hear the person who is speaking on it',
      Category.phone,
      'Sorry, could you repeat that, please? You’re breaking up“.',
    ),
    PhrasalVerb(
      Verb.call,
      Preposition.up,
      'to call someone on the phone',
      Category.phone,
      'My dad called me up to tell me the bad news',
    ),
    PhrasalVerb(
      Verb.cut,
      Preposition.off,
      'if someone or something cuts you off when you are talking on the telephone, they make the telephone line stop working',
      Category.phone,
      'We were cut off in the middle of our conversation',
    ),
    PhrasalVerb(
      Verb.get,
      Preposition.through,
      'to be connected to a place by telephone; to reach somebody on the phone',
      Category.phone,
      'I finally got through to Tom on his mobile.',
    ),
    PhrasalVerb(
      Verb.speak,
      Preposition.up,
      'to speak louder',
      Category.phone,
      'Can you speak up a bit? It’s very noisy here',
    ),
    PhrasalVerb(
      Verb.hang,
      Preposition.on,
      'to wait for a short time ',
      Category.phone,
      'Can you hang on on the line, please? I will be right back in a minute',
    ),
    PhrasalVerb(
      Verb.hang,
      Preposition.up,
      'to end a telephone call by putting the phone down',
      Category.phone,
      'After I hung up I remembered what I’d wanted to say',
    ),
    PhrasalVerb(
      Verb.pick,
      Preposition.up,
      'to answer the telephone call',
      Category.phone,
      'Why do you need a mobile phone anyway? You are never picking up',
    ),
    PhrasalVerb(
      Verb.phone,
      Preposition.$in,
      'to phone the place where you work in order to tell your employer something',
      Category.phone,
      'I have to phone in and report the changes.',
    ),
    PhrasalVerb(
        Verb.put,
        Preposition.on,
        'to maintain a phone call in progress without the other person’s being able to hear you, usually in order to transfer a call',
        Category.phone,
        'I called the customer service hotline to complain and they put me on hold for twenty minutes before a manager finally picked up the phone',
        secondPreposition: Preposition.hold),

    //
    //
    //
    //PHONE
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //ENVIRONMENT
    //
    //
    //
    PhrasalVerb(
      Verb.wipe,
      Preposition.out,
      'to destroy something completely',
      Category.environment,
      'Whole villages were wiped out by the huricane',
    ),
    PhrasalVerb(
      Verb.$break,
      Preposition.down,
      'to decompose, when something slowly reduces to its smallest parts',
      Category.environment,
      'A plastic pot may take more than a million years to be broken down.',
    ),
    PhrasalVerb(
      Verb.use,
      Preposition.up,
      'to use all of a supply of something; to exhaust of strength or useful properties',
      Category.environment,
      'We’re going to use up earth’s resources very soon',
    ),
    PhrasalVerb(
      Verb.die,
      Preposition.out,
      'to stop exist; to disappear completely',
      Category.environment,
      'This species has nearly died out because its habitat is being destroyed',
    ),
    PhrasalVerb(
      Verb.spread,
      Preposition.out,
      'to cover a large area',
      Category.environment,
      'Because our population is so densely concentrated, a new disease like bird flu can spread out very quickly after the first case has appeared',
    ),
    PhrasalVerb(
      Verb.cut,
      Preposition.down,
      'to kill trees',
      Category.environment,
      'The rainforest is being cut down',
    ),
    PhrasalVerb(
      Verb.rely,
      Preposition.on,
      'to depend on or need something in order to continue living, existing, or operating',
      Category.environment,
      'We won’t have to rely on nuclear power if we use solar and wind power instead',
    ),
    PhrasalVerb(
      Verb.cool,
      Preposition.down,
      'to become cooler, or to make something cooler',
      Category.environment,
      'Global temperatures will not cool down until we reduce the amount of carbon gasses we release into the atmosphere.',
    ),
    PhrasalVerb(
      Verb.heat,
      Preposition.up,
      'to make hotter',
      Category.environment,
      'The weather is heating up due to the effect of greenhouse gasses',
    ),
    PhrasalVerb(
      Verb.dispose,
      Preposition.of,
      'to get rid of something that you no longer need or want',
      Category.environment,
      'There is a recycling bin in the car park where you can dispose of your drinks cans',
    ),
    PhrasalVerb(
        Verb.put,
        Preposition.down,
        'to give a reason or excuse for something; if you put something down to a particular reason, you think it has happened for that reason',
        Category.environment,
        'I put global warming down to bad long-term planning.',
        secondPreposition: Preposition.to),

    //
    //
    //
    //
    //ENVIRONMENT
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //CRIME
    //
    //
    //
    //
    PhrasalVerb(
      Verb.$break,
      Preposition.into,
      'to enter a building or car by using force, in order to steal something',
      Category.crime,
      'Someone broke into my car and stole the radio',
    ),
    PhrasalVerb(Verb.$break, Preposition.out, 'to escape from a prison',
        Category.crime, 'Three men have broken out of a top-security jail',
        secondPreposition: Preposition.of),
    PhrasalVerb(
      Verb.tip,
      Preposition.off,
      'to warn somebody about something that is going to happen, especially something illegal; to give secret information to someone',
      Category.crime,
      'Two men were arrested after police were tipped off about the possible raid',
    ),
    PhrasalVerb(
      Verb.stake,
      Preposition.out,
      'to watch a place secretly, especially for signs of illegal activity',
      Category.crime,
      'Detectives had been staking out the house for several weeks',
    ),
    PhrasalVerb(
      Verb.bring,
      Preposition.$in,
      'to bring somebody to a police station in order to ask them questions or arrest them',
      Category.crime,
      'Two men were brought in for questioning',
    ),
    PhrasalVerb(
      Verb.beat,
      Preposition.up,
      'to attack with violence; to hit someone hard and repeatedly',
      Category.crime,
      'They threatened to beat me up if I didn’t give them my wallet',
    ),
    PhrasalVerb(
      Verb.lock,
      Preposition.up,
      'to put someone in prison',
      Category.crime,
      'Rapists should be locked up',
    ),

    PhrasalVerb(
      Verb.blow,
      Preposition.up,
      'to explode',
      Category.crime,
      'The terrorist\'s threatening to blow up the building',
    ),
    PhrasalVerb(
        Verb.get,
        Preposition.away,
        'to escape blame or punishment when you do something wrong, or to avoid harm or criticism for something you did',
        Category.crime,
        'They have repeatedly broken the law and got away with it',
        secondPreposition: Preposition.$with),
    PhrasalVerb(
      Verb.get,
      Preposition.away,
      'to leave or escape from a person or place, often when it is difficult to do this',
      Category.crime,
      'I managed to get away from the police as my car was faster',
    ),
    PhrasalVerb(
      Verb.give,
      Preposition.$in,
      'to hand yourself in; to submit to pressure',
      Category.crime,
      'The thief gave himself in to the police.',
    ),
    PhrasalVerb(
      Verb.let,
      Preposition.off,
      'to give someone little or no punishment for something that they did',
      Category.crime,
      'The police let us off with a warning as we were not speeding too much.',
    ),
    PhrasalVerb(
      Verb.look,
      Preposition.into,
      'to investigate; to examine the facts about a problem or situation',
      Category.crime,
      'The police are looking into the incident.',
    ),
    PhrasalVerb(
      Verb.run,
      Preposition.away,
      'to leave a place or person secretly and suddenly',
      Category.crime,
      'We all ran away after the protest so that we were not detained.',
    ),
    PhrasalVerb(
      Verb.tell,
      Preposition.off,
      'to shout at; to speak angrily to someone because they have done something wrong',
      Category.crime,
      'Their teacher told them off for chattering in the lesson.',
    ),
    PhrasalVerb(
      Verb.tell,
      Preposition.on,
      'to give information about someone, usually something bad that they have said or done, especially to a person in authority',
      Category.crime,
      'The witness told on his business partner to avoid further prosecution.',
    ),
    //
    //
    //CRIME
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //TRAVEL
    //
    //
    PhrasalVerb(
      Verb.set,
      Preposition.off,
      'to start a journey; to start going in a particular direction',
      Category.travel,
      'What time do we set off tomorrow for London?',
    ),
    PhrasalVerb(
      Verb.get,
      Preposition.$in,
      'if a train, plane etc gets in, it arrives',
      Category.travel,
      'I got in just after eight o’clock',
    ),
    PhrasalVerb(
      Verb.hold,
      Preposition.up,
      'to cause a delay for someone or something, or to make them late',
      Category.travel,
      'Sorry I’m late, but my plane was held up',
    ),
    PhrasalVerb(
      Verb.take,
      Preposition.off,
      'if an aircraft takes off, it leaves the ground and starts flying',
      Category.travel,
      'The plane should take off on time',
    ),
    PhrasalVerb(
      Verb.check,
      Preposition.$in,
      'to arrive and register at a hotel or airport',
      Category.travel,
      'Please check in at least an hour before departure',
    ),
    PhrasalVerb(
      Verb.get,
      Preposition.off,
      'to leave a bus, plane, or train',
      Category.travel,
      'We get off at the next station',
    ),
    PhrasalVerb(
      Verb.get,
      Preposition.off,
      'to leave a hotel after paying and returning your room key',
      Category.travel,
      'We checked out from our hotel at noon to catch a 2 p.m. flight',
    ),
    PhrasalVerb(
      Verb.get,
      Preposition.away,
      'to have a holiday or vacation',
      Category.travel,
      'Wouldn’t it be nice to get away for a weekend?',
    ),
    PhrasalVerb(
      Verb.get,
      Preposition.on,
      'to enter a bus, train, or plane',
      Category.travel,
      'I think we got on the wrong bus',
    ),
    PhrasalVerb(
      Verb.drop,
      Preposition.off,
      'to take someone to a place and leave them there',
      Category.travel,
      'I’ll drop you off on my way home',
    ),
    PhrasalVerb(
      Verb.pick,
      Preposition.up,
      'to let someone get into your car and take them somewhere',
      Category.travel,
      'He’ll pick you up at the station',
    ),
    PhrasalVerb(
      Verb.speed,
      Preposition.up,
      'to increase speed; to move or happen faster',
      Category.travel,
      'Can you try and speed things up a bit?',
    ),
    PhrasalVerb(
      Verb.look,
      Preposition.around,
      'to explore what is near you, in your area',
      Category.travel,
      'When we went to New York, we only had a couple of hours to look around',
    ),
    PhrasalVerb(
      Verb.hurry,
      Preposition.up,
      'to do something more quickly',
      Category.travel,
      'You\'d better hurry up, otherwise you\'ll miss the train',
    ),
    PhrasalVerb(
      Verb.stop,
      Preposition.over,
      'to stay somewhere for a short time during a long journey',
      Category.travel,
      'They\'re stopping over in Malaysia for a couple of nights on the way to Australia',
    ),
    //
    //
    //TRAVEL
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //SHOPPING
    //
    //
    PhrasalVerb(
      Verb.pay,
      Preposition.$for,
      'to give money in order to buy something',
      Category.shopping,
      'I paid good money for that sofa, so it should last',
    ),
    PhrasalVerb(
      Verb.put,
      Preposition.on,
      'to get dressed; to move something you wear onto your body',
      Category.shopping,
      'She put on her coat and went out',
    ),
    PhrasalVerb(
      Verb.line,
      Preposition.up,
      'to wait for something in a line',
      Category.shopping,
      'Some people lined up all night to get into the store.',
    ),
    PhrasalVerb(
      Verb.sell,
      Preposition.out,
      'to sell all of the supply that you have',
      Category.shopping,
      'We sold out of the sneakers in the first couple of hours.',
    ),
    PhrasalVerb(
      Verb.shop,
      Preposition.around,
      'to compare the price and quality of items in different stores before you decide which one to buy',
      Category.shopping,
      'You can get good rates if you shop around on the internet',
    ),
    PhrasalVerb(
      Verb.take,
      Preposition.off,
      'to remove a piece of clothing',
      Category.shopping,
      'He took off my wet boots and made me sit by the fire.',
    ),
    PhrasalVerb(
      Verb.$try,
      Preposition.on,
      'to put on a piece of clothing to see if it fits',
      Category.shopping,
      'You should try the shoes on before you buy them.',
    ),
    PhrasalVerb(
      Verb.$try,
      Preposition.out,
      'to test something to see if you like it',
      Category.shopping,
      'John looks forward to try out his new running shoes this weekend.',
    ),
    PhrasalVerb(
      Verb.pop,
      Preposition.into,
      'to visit briefly a place, usually for some purpose',
      Category.shopping,
      'I’m going to pop into the store for a moment',
    ),
    PhrasalVerb(
      Verb.stand,
      Preposition.out,
      'to be very noticeable; to be much better than other similar things or people',
      Category.shopping,
      'Your red dress really stands out against all those dull grey ones.',
    ),
    PhrasalVerb(
      Verb.pick,
      Preposition.out,
      'to choose one thing or person from a group',
      Category.shopping,
      'Can you help me pick out a wedding dress?',
    ),
    PhrasalVerb(
      Verb.splash,
      Preposition.out,
      'to spend money freely',
      Category.shopping,
      'She splashed out on a new Lexus',
    ),
    PhrasalVerb(
      Verb.set,
      Preposition.back,
      'to cost someone a particular amount of money, especially a large amount',
      Category.shopping,
      'Anna’s new laptop must have set her back over \$1000',
    ),
    PhrasalVerb(
        Verb.look,
        Preposition.out,
        'to watch or check regularly for something or to search for something',
        Category.shopping,
        'I always look out for great deals when I’m shopping.',
        secondPreposition: Preposition.$for),
    PhrasalVerb(
      Verb.go,
      Preposition.$with,
      'to seem good, natural, or attractive in combination with something',
      Category.shopping,
      'Which shoes go best with this dress?',
    ),
  ];

  static const Category firstCategory = Category.food;
  List<Level> levels = [
    Level(firstCategory, 1),
    Level(Category.education, 1),
    Level(Category.money, 1),
    Level(Category.relationships, 1),
    Level(Category.health, 1),
    Level(Category.work, 1),
    //
    //
    //
    //
    //
    Level(Category.emotions, 1),
    Level(Category.animal, 1),
    Level(Category.shopping, 1),
    Level(Category.family, 1),
    Level(Category.phone, 1),
    Level(Category.business, 1),
    //
    //
    //
    //
    Level(Category.travel, 1),
    Level(Category.communication, 1),
    Level(Category.work, 2),
    Level(Category.love, 1),
    Level(Category.house, 2),
    Level(Category.business, 2),
    //
    //
    //
    //
    Level(Category.food, 2),
    Level(Category.phone, 2),
    Level(Category.decision, 1),
    Level(Category.travel, 2),
    Level(Category.illness, 1),
    Level(Category.business, 3),
    //
    //
    //
    //
    Level(Category.technology, 1),
    Level(Category.animal, 2),
    Level(Category.house, 3),
    Level(Category.family, 3),
    Level(Category.crime, 1),
    Level(Category.business, 4),
    //
    //
    Level(Category.house, 1),
    Level(Category.relationships, 2),
    Level(Category.clothes, 1),
    Level(Category.food, 3),

    Level(Category.communication, 2),
    Level(Category.travel, 3),
    //
    //
    //
    Level(Category.relationships, 3),

    Level(Category.animal, 3),
    Level(Category.clothes, 2),
    Level(Category.money, 2),
    Level(Category.environment, 1),
    Level(Category.business, 5),
    //
    //
    //
    //
    Level(Category.work, 3),
    Level(Category.crime, 2),
    Level(Category.relationships, 4),
    Level(Category.technology, 2),
    Level(Category.communication, 3),
    Level(Category.animal, 4),

    //
    //
    //
    //

    Level(Category.shopping, 2),
    Level(Category.environment, 2),
    Level(Category.money, 3),
    Level(Category.relationships, 5),
    Level(Category.health, 2),
    Level(Category.business, 6),
    //
    //
    Level(Category.work, 4),
    Level(Category.relationships, 6),
    Level(Category.illness, 2),
    Level(Category.education, 2),
    Level(Category.business, 7),
    Level(Category.clothes, 3),

    //
    //
    Level(Category.work, 5),
    Level(Category.crime, 3),
    Level(Category.education, 3),
    Level(Category.technology, 3),
    Level(Category.health, 3),
    Level(Category.business, 8),
    //
    //
    //
    //
    Level(Category.work, 6),
    Level(Category.shopping, 3),
    Level(Category.decision, 2),
    Level(Category.relationships, 7),
    Level(Category.health, 4),
    Level(Category.business, 9),
    //
    //
    //
    //
  ];
}
