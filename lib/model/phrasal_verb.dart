import 'package:phrasal_verbs/model/verbs_bank.dart';

class PhrasalVerb {
  Verb name;
  String description;
  String example;
  Category category;
  Preposition preposition;
  Preposition secondPreposition;
  bool isUnlocked;


  PhrasalVerb(this.name, this.preposition, this.description, this.category,
      this.example,
      {this.secondPreposition, this.isUnlocked = false});
}

enum Verb {
  bristle,
  beef,
  sail,
  sweep,
  cut,
  stock,
  care,
  fish,
  hook,
  blurt,
  fess,
  point,
  spell,
  rattle,
  rely,
  cool,
  type,
  log,
  scroll,
  boot,
  click,
  hound,
  hack,
  plug,
  sign,
  shut,
  use,
  die,
  $do,
  dispose,
  spread,
  heat,
  ferret,
  dress,
  kick,
  slip,
  wrap,
  zip,
  worm,
  rat,
  be,
  rabbit,
  drone,
  clam,
  horse,
  $catch,
  leech,
  monkey,
  read,
  beaver,
  eat,
  copy,
  give,
  scrape,
  chicken,
  fetter,
  wolf,
  duck,
  shake,
  lock,
  tell,
  tip,
  stake,
  blow,
  rule,
  zone,
  step,
  blend,
  close,
  sort,
  speed,
  beat,
  print,
  water,
  weigh,
  talk,
  yield,
  match,
  $throw,
  hurry,
  hold,
  branch,
  note,
  think,
  find,
  deal,
  back,
  cope,
  wind,
  start,
  bail,
  join,
  pull,
  level,
  wipe,
  bake,
  warm,
  pig,
  pick,
  butt,
  bring,
  call,
  fit,
  fizzle,
  invite,
  lap,
  show,
  stick,
  take,
  let,
  ask,
  turn,
  $break,
  raise,
  chop,
  split,
  go,
  settle,
  look,
  make,
  chip,
  whip,
  boil,
  see,
  burn,
  carry,
  draw,
  drop,
  live,
  hand,
  fill,
  knock,
  lay,
  slack,
  knuckle,
  work,
  grow,
  keep,
  leave,
  doze,
  slow,
  pass,
  disagree,
  stop,
  check,
  around,
  wear,
  bottom,
  stay,
  fight,
  allow,
  flip,
  bolt,
  fry,
  pay,
  splash,
  save,
  put,
  squirrel,
  come,
  fork,
  run,
  get,
  rip,
  peel,
  slice,
  fall,
  $try,
  line,
  sell,
  mop,
  build,
  hang,
  speak,
  clean,
  phone,
  shop,
  pop,
  stand,
  set,
}
enum Category {
  travel,
  relationships,
  crime,
  illness,
  environment,
  money,
  emotions,
  education,
  animal,
  food,
  clothes,
  technology,
  house,
  health,
  business,
  communication,
  skills,
  shopping,
  family,
  decision,
  phone,
  love,
  work,
}
enum Preposition {
  up,
  $for,
  down,
  by,
  behind,
  of,
  under,
  round,
  from,

  ahead,
  apart,
  back,
  through,
  on,
  hold,
  forward,
  about,
  $with,
  out,
  into,
  after,
  together,
  over,
  aside,
  to,
  at,
  around,
  along,
  away,
  $in,
  off,
}

class Level {
  Category category;
  int level;
  int id;
  int progress;
  bool unlocked;
  Level(this.category, this.level,
      {
      this.progress = 0,
      this.id,
      this.unlocked = false});
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = id;
    }
    map['level'] = level;
    map['category'] = PhrasalVerbsBank().categoryToLabel(category);
    map['progress'] = progress;
    map['unlocked'] = unlocked ? 1 : 2;

    return map;
  }

  factory Level.fromMap(Map<String, dynamic> map) {
    return Level(
    categoryFromString(map['category']),
      map['level'],
      id: map['id'],
      progress: map['progress'],
      unlocked: map['unlocked'] == 1,
    );
  }
}

Category categoryFromString(String category) {
  switch (category) {
    case 'Food':
      return Category.food;
    case 'Money':
      return Category.money;
    case 'Technology':
      return Category.technology;
    case 'Love':
      return Category.love;
    case 'Relationships':
      return Category.relationships;
    case 'Health':
      return Category.health;
    case 'Business':
      return Category.business;
    case 'Family':
      return Category.family;
    case 'Illness':
      return Category.illness;
    case 'Emotions':
      return Category.emotions;
    case 'Animal':
      return Category.animal;
    case 'Communication':
      return Category.communication;
    case 'Decision':
      return Category.decision;
    case 'Education':
      return Category.education;
    case 'Clothes':
      return Category.clothes;
    case 'Phone':
      return Category.phone;
    case 'House':
      return Category.house;
    case 'Environment':
      return Category.environment;
    case 'Shopping':
      return Category.shopping;
    case 'Crime':
      return Category.crime;
    case 'Work':
      return Category.work;
    case 'Travel':
      return Category.travel;
    default:
      return Category.food;
  }
}
