"
the page that allows to enter information about the tag (like its name and category)
This is the right part of the tag browser
"
Class {
	#name : 'MiTagCreationForm',
	#superclass : 'SpPresenter',
	#instVars : [
		'colorPicker',
		'cancelButton',
		'submitButton',
		'nameField',
		'descriptionField',
		'categorySelection',
		'tagModel',
		'intentButton',
		'extentButton',
		'isIntent',
		'formLayout',
		'queryList',
		'queryListLabeled',
		'tagBrowser'
	],
	#category : 'MooseIDE-Tagging-Browser',
	#package : 'MooseIDE-Tagging',
	#tag : 'Browser'
}

{ #category : 'accessing' }
MiTagCreationForm >> cancelButton [

	^ cancelButton
]

{ #category : 'accessing' }
MiTagCreationForm >> categorySelection [

	^ categorySelection
]

{ #category : 'initialization' }
MiTagCreationForm >> checkFormInputs [

	nameField text ifEmpty: [ ^ false ].
	^ true
]

{ #category : 'private' }
MiTagCreationForm >> connectPresenters [
	
	extentButton action: [ self setExtentForm ].
	intentButton action: [ self setIntentForm ].
]

{ #category : 'brokerage' }
MiTagCreationForm >> consume: aQuery [

	self updateQueryList
]

{ #category : 'accessing' }
MiTagCreationForm >> extentButton [

	^ extentButton
]

{ #category : 'initialization' }
MiTagCreationForm >> fetchQueries [

	^ (tagBrowser application itemsFor: FQAbstractQuery) asOrderedCollection
]

{ #category : 'initialization' }
MiTagCreationForm >> initialize [

	super initialize.
	isIntent := false.
]

{ #category : 'initialization' }
MiTagCreationForm >> initializeDialogWindow: aDialog [

	"aDialog initialExtent: self class windowExtent."

	aDialog
		addButton: 'Cancel'
		do: [ :dialog | dialog close ].
	aDialog
		addButton: 'Add'
		do: [ :dialog | 
			self submit.
			dialog close ].

]

{ #category : 'initialization' }
MiTagCreationForm >> initializeLayout [

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

	formLayout := SpBoxLayout newTopToBottom
		spacing: 5;
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
			add: 'Description (optional)' asPresenter
			expand: false;
			add: descriptionField;
			yourself)
		 expand: true;
		 add: queryListLabeled expand: false;
		 yourself.

	self layout
		add:  (SpBoxLayout newLeftToRight
			spacing: 10;
			add: colorPickerLayout
			width: colorPickerWidth ;
			add: sep width: 2;
			add: (SpBoxLayout newTopToBottom
				spacing: 4;
				add: (SpBoxLayout newLeftToRight
				add: extentButton;
				add: intentButton;
				yourself)
			expand: false;
			add: formLayout expand: true fill: true;
			yourself);
		yourself)

]

{ #category : 'initialization' }
MiTagCreationForm >> initializePresenters [

	(colorPicker := self newColorPicker) setColor: Color random.
	extentButton := self newToggleButton
		state: true;
		label: 'Static';
		yourself.
	intentButton := self newToggleButton
		state: false;
		label: 'Dynamic';
		yourself.

	nameField := self newTextInput.
	descriptionField := self newText.
	categorySelection := self newDropList
		sortingBlock: [ :item |
			item specModel
				ifNil: [ '' ]
				ifNotNil: [ :category | category name ] ]
		ascending;
		display: [ :cat |
			cat ifNil: [ '' ] ifNotNil: [ cat name ] ];
		yourself.
	queryList := self newDropList
		             startWithoutSelection;
		             display:
			             [ :query | self stringForQuery: query ] yourself.
	queryListLabeled := MiPresenter new
		                    layout: (SpBoxLayout newTopToBottom
				                     add: 'Query' asPresenter expand: false;
				                     add: queryList expand: false;
				                     yourself);
		                    hide;
		                    yourself.

	self initializeLayout
]

{ #category : 'accessing' }
MiTagCreationForm >> intentButton [

	^ intentButton
]

{ #category : 'accessing' }
MiTagCreationForm >> nameField [

	^ nameField
]

{ #category : 'accessing' }
MiTagCreationForm >> queryList [

	^ queryList
]

{ #category : 'accessing' }
MiTagCreationForm >> queryListLabeled [

	^ queryListLabeled
]

{ #category : 'brokerage' }
MiTagCreationForm >> remove: aQuery [

	self updateQueryList
]

{ #category : 'initialization' }
MiTagCreationForm >> reset [

	colorPicker setColor: Color random.
	nameField text: ''.
	descriptionField text: ''.
	categorySelection resetSelection.
	queryList resetSelection.
	self updateQueryList
]

{ #category : 'private' }
MiTagCreationForm >> setExtentForm [

	isIntent ifFalse: [ 
		extentButton state: true.
		^ self ].
	isIntent := false.
	intentButton state: false.
	queryListLabeled hide.
	self update
]

{ #category : 'private' }
MiTagCreationForm >> setIntentForm [

	isIntent ifTrue: [ 
		intentButton state: true.
		^ self ].
	isIntent := true.
	extentButton state: false.
	queryListLabeled show.
	self update
]

{ #category : 'initialization' }
MiTagCreationForm >> setModelBeforeInitialization: aTagModel [

	tagModel := aTagModel
]

{ #category : 'accessing' }
MiTagCreationForm >> specModel [

	^tagBrowser specModel
]

{ #category : 'initialization' }
MiTagCreationForm >> stringForQuery: aQuery [

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
MiTagCreationForm >> submit [

	| tag |
	self checkFormInputs ifFalse: [ ^ self ].
	tag := isIntent
		ifFalse: [
			self specModel
				createTag: nameField text
				description: descriptionField text
				color: colorPicker color
				category: categorySelection selectedItem ]
		ifTrue: [
			self specModel
				createDynamicTag: nameField text
				description: descriptionField text
				color: colorPicker color
				category: categorySelection selectedItem
				query: queryList selectedItem ].

	tag
		ifNil: [
			self alert:
				'This tag name is already in use. Please choose a different one.' ]
		ifNotNil: [ tagBrowser refreshTagList ]
]

{ #category : 'accessing' }
MiTagCreationForm >> submitButton [

	^ submitButton
]

{ #category : 'accessing' }
MiTagCreationForm >> tagBrowser: aTagBrowser [

	tagBrowser := aTagBrowser.
		self updateQueryList.
]

{ #category : 'private' }
MiTagCreationForm >> updateCategories [

	categorySelection items: { nil }, (self specModel allCategories)
]

{ #category : 'accessing' }
MiTagCreationForm >> updateQueryList [

	queryList items: { nil } , self fetchQueries
]

{ #category : 'accessing - deprecated' }
MiTagCreationForm >> windowTitle [ 

	^'Create tag'
]
