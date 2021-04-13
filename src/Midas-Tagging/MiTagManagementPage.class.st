"
The page of the TagBrowser allowing to create, select, or remove tags
"
Class {
	#name : #MiTagManagementPage,
	#superclass : #MiPresenter,
	#instVars : [
		'tagManagmt',
		'catManagmt',
		'txtDescription',
		'txtColor',
		'tagModel',
		'colorExample'
	],
	#category : #'Midas-Tagging'
}

{ #category : #specs }
MiTagManagementPage class >> defaultSpec [

	^SpBoxLayout newVertical 
		add: 'Category' expand: false ;
		add: #catManagmt ;
		add: 'Tag' expand: false ;
		add: #tagManagmt ;
		
		add: (SpGridLayout new
			add: 'Description:' at: 1 @ 1 ;
			add: #txtDescription at: 2 @ 1 span: 2 @ 1 ;
			add: 'Color:' at: 1 @ 2 ;
			add: #txtColor at: 2 @ 2 ;
			add: #colorExample at: 3 @ 2 ;
			yourself) ;
		yourself
]

{ #category : #action }
MiTagManagementPage >> createCategory [
	| newCat |
	newCat := self tagModel addCategory: catManagmt nameEntered.
	catManagmt clearName.
	self refreshCategoryList.
	catManagmt selectName: newCat
]

{ #category : #action }
MiTagManagementPage >> createTag [
	|newTag |
	newTag := self tagModel addTag: tagManagmt nameEntered.
	tagManagmt clearName.
	self refreshTagList.
	tagManagmt selectName: newTag
]

{ #category : #initialization }
MiTagManagementPage >> initializeCategoryManagmtPart [
	catManagmt := (self instantiate: SpAddDelListPresenter)
		nameDisplayBlock: [ :object | object "because categories are not implemented yet" ] ;
		whenSelectedNameChangedDo: [ :cat | self tagModel currentCategory: cat ] ;
		addNameAction: [ self createCategory ] ;
		delNameAction: [ self removeCategory ] ;
		yourself
]

{ #category : #initialization }
MiTagManagementPage >> initializeColorChooserPart [
	txtColor := self newText
		autoAccept: true;
		color: Color white;
		whenTextChangedDo: [ :notUsed | colorExample refresh ];
		yourself.

	colorExample := (self instantiate: SpRoassalPresenter)
		script: [ :canvas | canvas color: (Color fromHexString: txtColor text asString , '000000') ];
		yourself
]

{ #category : #initialization }
MiTagManagementPage >> initializePresenters [
	super initializePresenters.

	self initializeCategoryManagmtPart.
	self initializeTagManagmtPart.

]

{ #category : #initialization }
MiTagManagementPage >> initializeTagManagmtPart [
	tagManagmt := (self instantiate: SpAddDelListPresenter)
		whenSelectedNameChangedDo: [ :tag | self tagModel currentTag: tag ];
		addNameAction: [ self createTag ];
		delNameAction: [ self removeTag ];
		yourself.

	txtDescription := self newText.

	self initializeColorChooserPart
]

{ #category : #refreshing }
MiTagManagementPage >> onBrowserPageRedisplay [
	"nothing to do"
]

{ #category : #refreshing }
MiTagManagementPage >> refreshCategoryList [
	catManagmt refreshList: tagModel allCategories
]

{ #category : #refreshing }
MiTagManagementPage >> refreshTagList [
	tagManagmt refreshList: tagModel allTags
]

{ #category : #action }
MiTagManagementPage >> removeCategory [
	tagModel deleteCurrentCategory.
	self refreshCategoryList
]

{ #category : #action }
MiTagManagementPage >> removeTag [
	tagModel deleteCurrentTag.
	self refreshTagList
]

{ #category : #accessing }
MiTagManagementPage >> tagModel [
	^tagModel

]

{ #category : #accessing }
MiTagManagementPage >> tagModel: aModel [
	tagModel := aModel.
	self refreshCategoryList.
	self refreshTagList

]
