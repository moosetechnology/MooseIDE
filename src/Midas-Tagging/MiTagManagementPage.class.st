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
		'tagModel',
		'rgbColorChooser'
	],
	#category : #'Midas-Tagging'
}

{ #category : #specs }
MiTagManagementPage class >> defaultSpec [
	^SpBoxLayout newTopToBottom
		add: (SpBoxLayout newLeftToRight
			add: (SpBoxLayout newTopToBottom
				add: 'Category'  expand: false ;
				add: #catManagmt ;
				yourself) ;
			add: (SpBoxLayout newTopToBottom
				add: 'Tag' expand: false ;
				add: #tagManagmt  ;
				yourself) ;
			yourself) ;

		add: 'Description:'  expand: false ;
		add: #txtDescription  ;

		add: 'Color:' expand: false ;
		add: #rgbColorChooser expand: false ;

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

	rgbColorChooser := self instantiate: SpRGBChooser
]

{ #category : #initialization }
MiTagManagementPage >> initializePresenters [
	super initializePresenters.

	self initializeCategoryManagmtPart.
	self initializeTagManagmtPart.
	self initializeColorChooserPart
]

{ #category : #initialization }
MiTagManagementPage >> initializeTagManagmtPart [
	tagManagmt := (self instantiate: SpAddDelListPresenter)
		whenSelectedNameChangedDo: [ :tag | self tagModel currentTag: tag ];
		addNameAction: [ self createTag ];
		delNameAction: [ self removeTag ];
		yourself.

	txtDescription := self newText.

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
