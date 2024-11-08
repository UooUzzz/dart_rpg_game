import 'dart:io';

class Character {
  String name;
  int hp;
  int att;
  int def;
  RegExp regExp = RegExp(r'^[a-zA-Z가-힣]+$'); //아래 조건 정규표현식

  Character({required this.name, required this.hp, required this.att, required this.def});

  // 사용자 이름 입력 메소드
  String characterName() {
    while (true) {
      stdout.write('캐릭터의 이름을 입력하세요: ');
      String? name = stdin.readLineSync();

      //이름은 빈 문자열이 아니어야 한다
      if (name == null || name.isEmpty) {
        print('다시 입력 해주세요!');
      } //이름에는 특수문자나 숫자가 포함되지 않아야 한다(허용 문자: 한글, 영문 대소문자)
      else if (!regExp.hasMatch(name)) {
        print('다시 입력 해주세요!');
      } else {
        return name;
      }
    }
  }

  //캐릭터의 상태를 출력하는 메서드(showStatus())
  void showStatus() {
    print('$name - 체력: $hp, 공격력: $att, 방어력: $def');
  }

  //characters파일에서 데이터를 갖고오는 메서드
  static Character fromFile(String filePath, String name) {
    final file = File(filePath);

    String characterT = file.readAsStringSync().trim(); //


    List<String> numbers = characterT.split(','); //

    int hp = int.parse(numbers[0].trim());
    int att = int.parse(numbers[1].trim());
    int def = int.parse(numbers[2].trim()); //문자열구분을 위해 파싱

    return Character(name: name, hp: hp, att: att, def: def);

  }
}

class Monster {
  String name;
  int hp;
  int att;

  Monster({required this.name, required this.hp, required this.att}); //위에 캐릭터 클래스 처럼 출력값대로 설정

  //몬스터의 상태를 출력하는 메서드 showStatus()
  void showStatus() {
    print('$name - 체력: $hp, 공격력: $att');
  }

  //monsters파일에서 데이터를 갖고오는 메서드
  static List<Monster> fromFile(String filePath) {
    final file = File(filePath);

    //파일을 한줄씩 읽기
    List<String> monsterNumbers = file.readAsLinesSync();
    List<Monster> monsters = [];

    //split으로 끊어줌
    for (var monsterNumber in monsterNumbers) {
      List<String> monsterT = monsterNumber.split(',');

      //위에처럼 trim
      if (monsterT.length == 3) {
        String name = monsterT[0].trim();
        int hp = int.parse(monsterT[1].trim());
        int att = int.parse(monsterT[2].trim());

        monsters.add(Monster(name: name, hp: hp, att: att)); //return에 넣어줄 객체만들기
      }
    }
    return monsters;
  }
}

void main() {
  Character character = Character(name: '', hp: 0, att: 0, def: 0); //Character class 인스턴스임
  String characterName = character.characterName(); //characterName 메소드 불러오기
  print('게임을 시작합니다!'); //class에서 조건문으로 캐릭터 입력을 제대로 완료하면 '게임을 시작합니다!' 출력

  String filePath = 'characters.txt'; //지금은 경로만 받아온거다
  Character showChStatus = Character.fromFile(filePath, characterName); //charaters.txt에서 받음
  showChStatus.showStatus(); // 캐릭터 상태 출력


  //이제 몬스터
  print('새로운 몬스터가 나타났습니다!');
  String monsterFilePath = 'monsters.txt';
  List<Monster> monsters = Monster.fromFile(monsterFilePath);

  // 몬스터 상태 출력
  for (var monster in monsters) {
    monster.showStatus();
  }
}
