"
the page that allows to enter information about the tag (like its name and category)
This is the right part of the tag browser
"
Class {
	#name : 'MiTagAbstractForm',
	#superclass : 'SpPresenter',
	#instVars : [
		'colorPicker',
		'cancelButton',
		'submitButton',
		'nameField',
		'descriptionField',
		'categorySelection',
		'intentButton',
		'extentButton',
		'isIntent',
		'queryList',
		'queryListLabeled',
		'tagBrowser'
	],
	#category : 'MooseIDE-Tagging-Browser',
	#package : 'MooseIDE-Tagging',
	#tag : 'Browser'
}

{ #category : 'accessing' }
MiTagAbstractForm >> cancelButton [

	^ cancelButton
]

{ #category : 'accessing' }
MiTagAbstractForm >> categorySelection [

	^ categorySelection
]

{ #category : 'initialization' }
MiTagAbstractForm >> checkFormInputs [

	nameField text ifEmpty: [ ^ false ].
	^ true
]

{ #category : 'initialization' }
MiTagAbstractForm >> close [

	owner close
]

{ #category : 'private' }
MiTagAbstractForm >> connectPresenters [
	
	extentButton action: [ self setExtentForm ].
	intentButton action: [ self setIntentForm ].
]

{ #category : 'brokerage' }
MiTagAbstractForm >> consume: aQuery [

	self updateQueryList
]

{ #category : 'accessing' }
MiTagAbstractForm >> extentButton [

	^ extentButton
]

{ #category : 'initialization' }
MiTagAbstractForm >> fetchQueries [

	^ (tagBrowser application itemsFor: FQAbstractQuery) asOrderedCollection
]

{ #category : 'initialization' }
MiTagAbstractForm >> formLayout [

	^ SpBoxLayout newTopToBottom
		  spacing: 10;
		  add: (SpBoxLayout newLeftToRight
				   spacing: 5;
				   add: (SpBoxLayout newTopToBottom
						    add: 'Name' asPresenter expand: false;
						    add: nameField expand: false;
						    yourself);
				   add: (SpBoxLayout newTopToBottom
						    add: 'Category (optional)';
						    add: categorySelection;
						    yourself)
				   width: 200;
				   yourself)
		  expand: false;
		  add: (SpBoxLayout newTopToBottom
				   add: 'Description (optional)' asPresenter expand: false;
				   add: descriptionField expand: true;
				   yourself)
		  expand: true ;
		yourself
]

{ #category : 'initialization' }
MiTagAbstractForm >> initialize [

	super initialize.
	isIntent := false.

]

{ #category : 'initialization' }
MiTagAbstractForm >> initializeDialogButtonsLayout [

	^SpBoxLayout newLeftToRight
		hAlignEnd ;
		add: cancelButton expand: false ;
		add: submitButton expand: false ;
		yourself
]

{ #category : 'initialization' }
MiTagAbstractForm >> initializeFormLayout [

	self subclassResponsibility
]

{ #category : 'initialization' }
MiTagAbstractForm >> initializeLayout [

	| sep colorPickerWidth colorPickerLayout |
	self layout: (SpBoxLayout newTopToBottom spacing: 5).

	colorPickerWidth := 240.
	
	(sep := SpRoassalPresenter new) canvas color: (Color
			 r: 40
			 g: 40
			 b: 40
			 range: 255) translucent.

	colorPickerLayout := SpBoxLayout newTopToBottom
		add: (SpBoxLayout newLeftToRight
			add: 'Tag Color' asPresenter;
			hAlignCenter;
			yourself)
		width: colorPickerWidth;
		add: colorPicker  ;
		yourself.
	
	self initializeFormLayout.

	self layout
		add:  (SpBoxLayout newLeftToRight
			spacing: 10;
			add: colorPickerLayout width: colorPickerWidth ;
			add: sep width: 2;
			add: (SpBoxLayout newTopToBottom
			spacing: 5;
				add: (self initializeFormLayout) expand: true fill: true;
				add: self initializeDialogButtonsLayout expand: false ;
				yourself);
		yourself)

]

{ #category : 'initialization' }
MiTagAbstractForm >> initializePresenters [

	submitButton := self newButton 
		label: 'Add' ;
		action: [ self submit ].
	cancelButton := self newButton 
		label: 'Cancel' ;
		action: [ self close ].

	colorPicker := self newColorPicker
		setColor: Color random.
	extentButton := self newToggleButton
		state: true;
		label: 'Static'.
	intentButton := self newToggleButton
		state: false;
		label: 'Dynamic'.

	self initializeTagDescriptionPresenters.

	self initializeLayout
]

{ #category : 'initialization' }
MiTagAbstractForm >> initializeTagDescriptionPresenters [

	nameField := self newTextInput.
	descriptionField := self newText.
	categorySelection := self newDropList
		sortingBlock: [ :item |
			item model
				ifNil: [ '' ]
				ifNotNil: [ :category | category name ] ]
		ascending;
		display: [ :cat | cat ifNil: [ '' ] ifNotNil: [ cat name ] ].
	queryList := self newDropList
		startWithoutSelection;
		display: [ :query | self stringForQuery: query ].
	queryListLabeled := MiPresenter new
		layout: (SpBoxLayout newTopToBottom
			add: 'Query' asPresenter expand: false;
			add: queryList expand: false;
			yourself);
		 hide.

]

{ #category : 'accessing' }
MiTagAbstractForm >> intentButton [

	^ intentButton
]

{ #category : 'accessing' }
MiTagAbstractForm >> nameField [

	^ nameField
]

{ #category : 'accessing' }
MiTagAbstractForm >> queryList [

	^ queryList
]

{ #category : 'accessing' }
MiTagAbstractForm >> queryListLabeled [

	^ queryListLabeled
]

{ #category : 'brokerage' }
MiTagAbstractForm >> remove: aQuery [

	self updateQueryList
]

{ #category : 'initialization' }
MiTagAbstractForm >> reset [

	colorPicker setColor: Color random.
	nameField text: ''.
	descriptionField text: ''.
	categorySelection resetSelection.
	queryList resetSelection.
	self updateQueryList
]

{ #category : 'private' }
MiTagAbstractForm >> setExtentForm [

	isIntent ifFalse: [ 
		extentButton state: true.
		^ self ].
	isIntent := false.
	intentButton state: false.
	queryListLabeled hide.
	self update
]

{ #category : 'private' }
MiTagAbstractForm >> setIntentForm [

	isIntent ifTrue: [ 
		intentButton state: true.
		^ self ].
	isIntent := true.
	extentButton state: false.
	queryListLabeled show.
	self update
]

{ #category : 'accessing' }
MiTagAbstractForm >> specModel [

	^tagBrowser specModel
]

{ #category : 'initialization' }
MiTagAbstractForm >> stringForQuery: aQuery [

	| queryText contractor |
	queryText := aQuery ifNil: [ '' ] ifNotNil: [ 
		             String streamContents: [ :aStream | 
			             aQuery storeWithParentsOn: aStream ] ].
	contractor := LbCContractor new addStrategy:
		              (LbCEllipsisStrategy new
			               separator: '...';
			               upTo: 50;
			               yourself).
	^ contractor reduce: queryText
]

{ #category : 'initialization' }
MiTagAbstractForm >> submit [

	| tag |
	self checkFormInputs ifFalse: [ ^ self ].

	tag := isIntent
		ifTrue: [
			self specModel
				createDynamicTag: nameField text
				description: descriptionField text
				color: colorPicker color
				category: categorySelection selectedItem
				query: queryList selectedItem ]
		ifFalse: [
			self specModel
				createTag: nameField text
				description: descriptionField text
				color: colorPicker color
				category: categorySelection selectedItem ].

	tag
		ifNil: [ self alert: 'This tag name is already in use. Please choose a different one.' ].

	tagBrowser refreshTagList.
	self close
]

{ #category : 'accessing' }
MiTagAbstractForm >> submitButton [

	^ submitButton
]

{ #category : 'accessing' }
MiTagAbstractForm >> tagBrowser: aTagBrowser [

	tagBrowser := aTagBrowser.
	self updateQueryList.
	self updateCategories
]

{ #category : 'private' }
MiTagAbstractForm >> updateCategories [
	"allow to have no category, hence the first nil element"

	categorySelection items: { nil }, (self specModel allCategories)
]

{ #category : 'accessing' }
MiTagAbstractForm >> updateQueryList [

	queryList items: self fetchQueries
]

{ #category : 'accessing - deprecated' }
MiTagAbstractForm >> windowTitle [ 

	^'Create tag'
]
