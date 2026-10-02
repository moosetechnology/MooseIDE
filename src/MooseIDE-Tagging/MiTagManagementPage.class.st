"
The page of the TagBrowser allowing to create, select, or remove tags (left part of the browser)
"
Class {
	#name : 'MiTagManagementPage',
	#superclass : 'MiPresenter',
	#instVars : [
		'categoryManagement',
		'tagList',
		'tagModel',
		'addTagButton',
		'btnIsExtent',
		'btnIsIntent'
	],
	#category : 'MooseIDE-Tagging-Browser',
	#package : 'MooseIDE-Tagging',
	#tag : 'Browser'
}

{ #category : 'accessing' }
MiTagManagementPage >> addTagButton [

	^ addTagButton
]

{ #category : 'refreshing' }
MiTagManagementPage >> computeExtentTagList [

	^ btnIsExtent state
		  ifTrue: [
				  tagModel currentCategory
					  ifNil: [ self specModel allTags ]
					  ifNotNil: [ :currentTag | currentTag markedTags asMooseGroup ] ]
		  ifFalse: [ #(  ) ]
]

{ #category : 'refreshing' }
MiTagManagementPage >> computeIntentTagList [

	^ btnIsIntent state
		  ifTrue: [
				  tagModel currentCategory
					  ifNil: [ self specModel dynamicTags ]
					  ifNotNil: [ :currentCat |
						  self specModel dynamicTags select: [ :tag |
							  tag category = currentCat ] ] ]
		  ifFalse: [ #(  ) ]
]

{ #category : 'refreshing' }
MiTagManagementPage >> computeTagList [

	^self computeExtentTagList 
	 ,
	 self computeIntentTagList

]

{ #category : 'initialization' }
MiTagManagementPage >> connectPresenters [

	btnIsExtent whenChangedDo: [ 
		self setIconForButton: btnIsExtent.
		self refreshTagList ].
	btnIsIntent whenChangedDo: [ 
		self setIconForButton: btnIsIntent.
		self refreshTagList ]
]

{ #category : 'action' }
MiTagManagementPage >> deleteCurrentTag [

	tagModel deleteCurrentTag.
	self refreshTagList
]

{ #category : 'action' }
MiTagManagementPage >> editCurrentTag [

	tagModel editCurrentTag
]

{ #category : 'accessing' }
MiTagManagementPage >> extentTagButton [

	^ btnIsExtent
]

{ #category : 'initialization' }
MiTagManagementPage >> initializeLayout [

	| sep |
	sep := owner separator.

	self layout: (SpBoxLayout newTopToBottom
		spacing: 5;
		add: categoryManagement expand: false;
		add: (SpBoxLayout newLeftToRight
			add: 'Tag list' asPresenter;
			hAlignCenter;
			yourself)
		expand: false;
		add: (SpBoxLayout newLeftToRight
			spacing: 3;
			add: btnIsExtent;
			add: btnIsIntent;
			add: addTagButton width: 30;
			yourself)
		expand: false;
		add: tagList;
		yourself).

]

{ #category : 'initialization' }
MiTagManagementPage >> initializePresenters [

	categoryManagement := self instantiate: MiTagCategoriesPresenter on: tagModel.

	btnIsExtent := self newToggleButton
		state: true;
		icon: (Smalltalk ui icons iconNamed: #checkboxSelected);
		label: 'Static';
		yourself.
	btnIsIntent := self newToggleButton
		state: false;
		icon: (Smalltalk ui icons iconNamed: #checkboxUnselected);
		label: 'Dynamic';
		yourself.

	tagList := self newList.
	tagList contextMenu: self tagListMenu.
	tagList display: [ :aTag | aTag name ].
	tagList
		displayIcon: [ :aTag | self application iconForTag: aTag ];
		whenSelectionChangedDo: [ :selection |
			selection selectedItem ifNotNil: [ :item | self setTagTo: item ] ].
	addTagButton := self newButton icon: (Smalltalk iconNamed: #smallAdd).
	addTagButton action: [ self owner createTag ].

	self initializeLayout
]

{ #category : 'accessing' }
MiTagManagementPage >> intentTagButton [

	^ btnIsIntent
]

{ #category : 'accessing' }
MiTagManagementPage >> model [

	self
		deprecated: 'This is a getter. Lets name it correctly.'
		transformWith: '`@receiver model' -> '`@receiver specModel'.
	^ self specModel
]

{ #category : 'refreshing' }
MiTagManagementPage >> refresh [

	self refreshTagList.
	self refreshCategoryList
]

{ #category : 'refreshing' }
MiTagManagementPage >> refreshCategoryList [

	categoryManagement refreshCategoryList
]

{ #category : 'refreshing' }
MiTagManagementPage >> refreshTagList [

	tagList items:
		(self computeTagList asArray sort: [ :t1 :t2 | t1 name <= t2 name ]).

	self specModel currentTag ifNotNil: [ :currentTag |
		tagList selectItem: currentTag ]
]

{ #category : 'action' }
MiTagManagementPage >> removeCategory [

	self specModel deleteCurrentCategory.
	self refreshCategoryList
]

{ #category : 'initialization' }
MiTagManagementPage >> setIconForButton: aBtn [

	aBtn icon: (Smalltalk ui icons iconNamed: (aBtn state
				  ifTrue: [ #checkboxSelected ]
				  ifFalse: [ #checkboxUnselected ]))
]

{ #category : 'initialization' }
MiTagManagementPage >> setModelBeforeInitialization: aTagModel [

	tagModel := aTagModel
]

{ #category : 'action' }
MiTagManagementPage >> setTagTo: aTag [

	self specModel setTagTo: aTag.

]

{ #category : 'accessing' }
MiTagManagementPage >> specModel [

	^ owner specModel
]

{ #category : 'accessing' }
MiTagManagementPage >> tagList [

	^ tagList
]

{ #category : 'initialization' }
MiTagManagementPage >> tagListMenu [

	^ self newMenu
		  addGroup: [ :aGroup | 
			  aGroup
				  addItem: [ :anItem | 
					  anItem
						  name: 'Edit tag';
						  iconName: #edit;
						  action: [ self editCurrentTag ] ];
				  addItem: [ :anItem | 
					  anItem
						  name: 'Delete';
						  iconName: #glamorousClose;
						  action: [ self deleteCurrentTag ] ] ]
]

{ #category : 'accessing' }
MiTagManagementPage >> tagModel [

	^ owner specModel
]
