# TodoEy
> 사용자가 자신의 할 일을 정리하고 , 완료한 작업을 체크하여 쉽게 확인할 수 있는 간편한 앱입니다.

<img src="https://github.com/user-attachments/assets/5e86c625-a933-4457-bb5c-26e5f1a33304"  width="200" height="400"/>
<img src="https://github.com/user-attachments/assets/1bfb984d-6d4a-4e3f-9f99-3267df26f776"  width="200" height="400"/>
<img src="https://github.com/user-attachments/assets/0b5068ae-6037-4750-920f-df55a91b787e"  width="200" height="400"/>
<img src="https://github.com/user-attachments/assets/56823a70-6851-4a74-9774-00e32c1af9ba"  width="200" height="400"/>
<img src="https://github.com/user-attachments/assets/ff66601e-f589-40bb-8b91-d168e19cebe0"  width="200" height="400"/>
<img src="https://github.com/user-attachments/assets/9a93da14-0393-4863-8dbe-e68d691b008c"  width="200" height="400"/>
<img src="https://github.com/user-attachments/assets/b0eb3ee5-cd13-4d25-9adc-12be6989a32b"  width="200" height="400"/>


<br>

## ⚙️ 주요 기능
- 나만의 할일 카테고리 추가 , 삭제 , 재배치
- 해당 카테고리에 일정들 추가 , 삭제 , 검색



<br>

## 🛠️ iOS 기술 스택

#### MVC 패턴
- Todoey 앱은 간단한 기능과 구조를 가지고 있으며, 복잡한 로직이 필요하지 않았기 때문에 가장 기본적이고 이해하기 쉬운 **MVC 패턴**을 선택했습니다.
- MVC 패턴은 애플리케이션의 구조를 명확히 분리하여 코드의 가독성을 높이고, 유지보수를 용이하게 해줍니다. 특히, 초보 개발자에게는 이 패턴이 이해하기 쉽고 적용하기 편리하다는 장점이 있습니다.

#### Realm
- Todoey 앱에서는 카테고리별로 할 일을 관리하고, 각 카테고리에 속한 할 일들을 효율적으로 저장하고 조회할 수 있는 데이터베이스가 필요했습니다. 이때, 코드가 비교적 간단하면서도 강력한 기능을 제공하는 **Realm**을 선택했습니다.
- Realm은 사용하기 쉽고, 빠른 성능을 자랑하는 오프라인 데이터베이스입니다. 간단한 API로 데이터를 저장하고 관리할 수 있어, 앱 개발 초기에 적합한 선택이었습니다.

#### UIKit
- iOS 앱을 처음 개발하면서, 애플이 제공하는 기본적인 UI 프레임워크인 **UIKit**을 사용해 보고자 했습니다. 특히, **Storyboard**를 이용하여 앱의 UI를 시각적으로 설계하고, 화면 간의 데이터 흐름을 쉽게 파악할 수 있었습니다.
- UIKit은 iOS 개발에 있어서 가장 기본적이며 널리 사용되는 UI 프레임워크입니다. Storyboard를 사용하면 각 화면의 요소들을 직관적으로 배치하고, 화면 전환과 데이터 흐름을 쉽게 관리할 수 있습니다. 이로 인해 앱 개발 과정에서 UI 구현을 더 쉽게 할 수 있었습니다.



<br>

## 🔥 나만의 고민

#### 1. Realm 데이터베이스 구조 설계

한 카테고리와 그와 연결된 아이템을 만들기 위해 Realm을 사용하였고 간단한 구조로 데이터베이스를 만들 수 있었습니다.

```
// Category.swift
class Category : Object {
    @objc dynamic var name : String = ""
    @objc dynamic var CategoryIndex : Int = 0
    
    let items  =  List<Item>()
    
}

// Item.swift
class Item : Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated : Date?
    var parentCategory = LinkingObjects(fromType : Category.self, property : "items")
    
}

```
앱에서 `Category`와 `Item`은 각각 **카테고리**와 **할 일 항목**을 의미합니다.
한 `Category` 에는 여러 `Item` 을 가지도록 설계하였습니다.


#### 2. View Update 문제

카테고리 추가 또는 스와이프 시 데이터는 변경되었지만, 뷰가 갱신되지 않아 이전 데이터를 계속 표시하는 문제가 발생했습니다. 이를 해결하기 위해 loadItems 함수를 추가하여 뷰를 업데이트하도록 하였습니다.

```
  var todoItems : Results<Item>?
  
  var selectedCategory : Category? {
      //변경된 직후 호출
      didSet{
          loadItems()
      }
  }
  
  func loadItems() {
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
  }


```

