"
The page of the TagBrowser allowing to create, select, or remove tags (left part of the browser)
"
Class {
	#name : #MiTagManagementPage,
	#superclass : #MiPresenter,
	#instVars : [
		'categoryManagement',
		'tagList',
		'descriptionPage',
		'tagModel',
		'tagDescriptionPage',
		'dynamicTagDescriptionPage',
		'addTagButton',
		'btnIsExtent',
		'btnIsIntent'
	],
	#category : #'MooseIDE-Tagging-Browser'
}

{ #category : #accessing }
MiTagManagementPage >> addTagButton [

	^ addTagButton
]

{ #category : #refreshing }
MiTagManagementPage >> computeExtentTagList [

	^btnIsExtent state
		ifTrue: [ tagModel currentCategory
		     ifNil: [ self model allTags ]
		     ifNotNil: [ :currentTag | currentTag markedTags asMooseGroup ] ]
		ifFalse: [ #() ]
]

{ #category : #refreshing }
MiTagManagementPage >> computeIntentTagList [

	^btnIsIntent state
		ifTrue: [ tagModel currentCategory
			ifNil: [ self model dynamicTags ]
			ifNotNil: [ :currentCat | 
				self model dynamicTags select: [ :tag | 
					tag category = currentCat ] ] ]
		ifFalse: [ #() ]

]

{ #category : #refreshing }
MiTagManagementPage >> computeTagList [

	^self computeExtentTagList 
	 ,
	 self computeIntentTagList

]

{ #category : #initialization }
MiTagManagementPage >> connectPresenters [

	btnIsExtent whenChangedDo: [ 
		self setIconForButton: btnIsExtent.
		self refreshTagList ].
	btnIsIntent whenChangedDo: [ 
		self setIconForButton: btnIsIntent.
		self refreshTagList ]
]

{ #category : #action }
MiTagManagementPage >> deleteCurrentTag [

	|tag|
	tag := tagModel deleteCurrentTag.
	self owner application removeItem: tag.
	descriptionPage hide.
	self refreshTagList
]

{ #category : #accessing }
MiTagManagementPage >> descriptionPage [

	^ descriptionPage
]

{ #category : #accessing }
MiTagManagementPage >> dynamicTagDescriptionPage [

	^ dynamicTagDescriptionPage
]

{ #category : #action }
MiTagManagementPage >> editCurrentTag [

	self owner openTagEditionForm
]

{ #category : #accessing }
MiTagManagementPage >> extentTagButton [

	^ btnIsExtent
]

{ #category : #initialization }
MiTagManagementPage >> initializeLayout [

	| sep |
	(sep := SpRoassalPresenter new) canvas color: (Color
			 r: 40
			 g: 40
			 b: 40
			 range: 255) translucent.

	self layout: (SpBoxLayout newLeftToRight
			 spacing: 4;
			 add: (SpBoxLayout newTopToBottom
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
					  yourself)
			 width: 200;
			 add: sep width: 2;
			 add: descriptionPage;
			 yourself)
]

{ #category : #initialization }
MiTagManagementPage >> initializePresenters [

	categoryManagement := self
		                      instantiate: MiTagCategoriesPresenter
		                      on: tagModel.

	tagDescriptionPage := self instantiate: MiTagExtentPage.
	dynamicTagDescriptionPage := self instantiate: MiTagIntentPage.
	descriptionPage := tagDescriptionPage.
	descriptionPage hide.

	btnIsExtent := self newToggleButton
		               state: true;
		               icon:
			               (Smalltalk ui icons iconNamed: #checkboxSelected);
		               label: 'Static';
		               yourself.
	btnIsIntent := self newToggleButton
		               state: false;
		               icon:
			               (Smalltalk ui icons iconNamed: #checkboxUnselected);
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
	addTagButton action: [ self owner openTagCreationForm ].

	self initializeLayout
]

{ #category : #accessing }
MiTagManagementPage >> intentTagButton [

	^ btnIsIntent
]

{ #category : #accessing }
MiTagManagementPage >> model [

	^ owner model
]

{ #category : #action }
MiTagManagementPage >> preparePageFor: aTag [

	aTag isIntent ifTrue: [ 
		self layout replace: descriptionPage with: dynamicTagDescriptionPage.
		descriptionPage := dynamicTagDescriptionPage.
		^ self ].
	self layout replace: descriptionPage with: tagDescriptionPage.
	descriptionPage := tagDescriptionPage
]

{ #category : #refreshing }
MiTagManagementPage >> refresh [

	self refreshTagList.
	self refreshCategoryList.
	self refreshDescriptionPage
]

{ #category : #refreshing }
MiTagManagementPage >> refreshCategoryList [

	categoryManagement refreshCategoryList
]

{ #category : #refreshing }
MiTagManagementPage >> refreshDescriptionPage [
	"No need to refresh if this is hidden."

	descriptionPage isVisible ifTrue: [ descriptionPage refresh ]
]

{ #category : #refreshing }
MiTagManagementPage >> refreshTagList [

	tagList items:
		(self computeTagList asArray
			sort: [ :t1 :t2 | t1 name <= t2 name ] ) .

	self model currentTag ifNotNil: [ :currentTag | tagList selectItem: currentTag ]

]

{ #category : #initialization }
MiTagManagementPage >> refreshTaggedEntitiesList [

	descriptionPage refreshTaggedEntitiesList
]

{ #category : #action }
MiTagManagementPage >> removeCategory [

	self model deleteCurrentCategory.
	self refreshCategoryList
]

{ #category : #accessing }
MiTagManagementPage >> selectedItems [

	^ tagDescriptionPage selectedItems
]

{ #category : #initialization }
MiTagManagementPage >> setIconForButton: aBtn [

	aBtn icon: (Smalltalk ui icons iconNamed: (aBtn state
				  ifTrue: [ #checkboxSelected ]
				  ifFalse: [ #checkboxUnselected ]))
]

{ #category : #initialization }
MiTagManagementPage >> setModelBeforeInitialization: aTagModel [

	tagModel := aTagModel
]

{ #category : #action }
MiTagManagementPage >> setTagTo: aTag [

	self owner setTagTo: aTag.
	self preparePageFor: aTag.
	descriptionPage setTag: aTag.
	descriptionPage show.
	self refreshDescriptionPage.
	self update
]

{ #category : #accessing }
MiTagManagementPage >> tagList [

	^ tagList
]

{ #category : #initialization }
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

{ #category : #accessing }
MiTagManagementPage >> tagModel [

	^ owner model
]
