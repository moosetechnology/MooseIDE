Class {
	#name : #MiTagCreationForm,
	#superclass : #MiPresenter,
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
		'queryListLabeled'
	],
	#category : #'MooseIDE-Tagging-Browser'
}

{ #category : #private }
MiTagCreationForm >> cancel [

	self reset.
	self owner closeTagCreationForm
]

{ #category : #accessing }
MiTagCreationForm >> cancelButton [

	^ cancelButton
]

{ #category : #accessing }
MiTagCreationForm >> categorySelection [

	^ categorySelection
]

{ #category : #initialization }
MiTagCreationForm >> checkFormInputs [

	nameField text ifEmpty: [ ^ false ].
	^ true
]

{ #category : #private }
MiTagCreationForm >> connectPresenters [
	
	extentButton action: [ self setExtentForm ].
	intentButton action: [ self setIntentForm ].
	cancelButton action: [ self cancel ].
	submitButton action: [ self submit ]
]

{ #category : #brokerage }
MiTagCreationForm >> consume: aQuery [

	self updateQueryList
]

{ #category : #accessing }
MiTagCreationForm >> extentButton [

	^ extentButton
]

{ #category : #initialization }
MiTagCreationForm >> fetchQueries [

	^ (self owner application itemsFor: FQAbstractQuery) asOrderedCollection
]

{ #category : #initialization }
MiTagCreationForm >> initialize [

	super initialize.
	isIntent := false.
]

{ #category : #initialization }
MiTagCreationForm >> initializeLayout [

	| sep colorPickerWidth headerLayout mainLayout |
	self layout: (SpBoxLayout newTopToBottom spacing: 5).
	colorPickerWidth := 240.
	(sep := SpRoassalPresenter new) canvas color: (Color
			 r: 40
			 g: 40
			 b: 40
			 range: 255) translucent.
	(sep := SpRoassalPresenter new) canvas color: (Color
			 r: 40
			 g: 40
			 b: 40
			 range: 255) translucent.

	headerLayout := SpBoxLayout newLeftToRight
		                add: (SpBoxLayout newLeftToRight
				                 add: 'Tag Color' asPresenter;
				                 hAlignCenter;
				                 yourself)
		                width: colorPickerWidth;
		                add: (SpBoxLayout newLeftToRight
				                 add: 'Create tag' asPresenter;
				                 hAlignCenter;
				                 yourself);
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

	mainLayout := SpBoxLayout newLeftToRight
		              spacing: 10;
		              add: colorPicker width: colorPickerWidth;
		              add: sep width: 2;
		              add: (SpBoxLayout newTopToBottom
				               spacing: 4;
				               add: (SpBoxLayout newLeftToRight
						                add: extentButton;
						                add: intentButton;
						                yourself)
				               expand: false;
				               add: formLayout expand: true fill: true;
				               add: (SpBoxLayout newLeftToRight
						                vAlignEnd;
						                spacing: 10;
						                add: cancelButton;
						                add: submitButton;
						                yourself)
				               expand: false;
				               yourself);
		              yourself.
	self layout
		add: headerLayout expand: false;
		add: mainLayout
]

{ #category : #initialization }
MiTagCreationForm >> initializePresenters [

	(colorPicker := self instantiate: MiColorPicker) setColor:
		Color random.
	extentButton := self newToggleButton
		                state: true;
		                label: 'Extent';
		                yourself.
	intentButton := self newToggleButton
		                state: false;
		                label: 'Intent';
		                yourself.
	submitButton := self newButton
		                label: 'Add';
		                yourself.
	cancelButton := self newButton
		                label: 'Cancel';
		                yourself.
	nameField := self newTextInput.
	descriptionField := self newText.
	categorySelection := self newDropList
		                     sortingBlock: [ :c1 :c2 | 
			                     c1 model ifNil: [ true ] ifNotNil: [ 
					                     c2 model
						                     ifNil: [ false ]
						                     ifNotNil: [ c1 model name < c2 model name ] ] ];
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
	self updateQueryList.
	self initializeLayout
]

{ #category : #accessing }
MiTagCreationForm >> intentButton [

	^ intentButton
]

{ #category : #accessing }
MiTagCreationForm >> nameField [

	^ nameField
]

{ #category : #accessing }
MiTagCreationForm >> queryList [

	^ queryList
]

{ #category : #accessing }
MiTagCreationForm >> queryListLabeled [

	^ queryListLabeled
]

{ #category : #brokerage }
MiTagCreationForm >> remove: aQuery [

	self updateQueryList
]

{ #category : #initialization }
MiTagCreationForm >> reset [

	colorPicker setColor: Color random.
	nameField text: ''.
	descriptionField text: ''.
	categorySelection resetSelection.
	queryList resetSelection.
	self updateQueryList
]

{ #category : #private }
MiTagCreationForm >> setExtentForm [

	isIntent ifFalse: [ 
		extentButton state: true.
		^ self ].
	isIntent := false.
	intentButton state: false.
	queryListLabeled hide.
	self update
]

{ #category : #private }
MiTagCreationForm >> setIntentForm [

	isIntent ifTrue: [ 
		intentButton state: true.
		^ self ].
	isIntent := true.
	extentButton state: false.
	queryListLabeled show.
	self update
]

{ #category : #initialization }
MiTagCreationForm >> setModelBeforeInitialization: aTagModel [

	tagModel := aTagModel
]

{ #category : #initialization }
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

{ #category : #initialization }
MiTagCreationForm >> submit [

	self checkFormInputs ifFalse: [ ^ self ].

	isIntent
		ifFalse: [ 
			self owner
				createTag: nameField text
				description: descriptionField text
				color: colorPicker color
				category: categorySelection selectedItem ]
		ifTrue: [ 
			self owner
				createDynamicTag: nameField text
				description: descriptionField text
				color: colorPicker color
				category: categorySelection selectedItem
				query: queryList selectedItem ].
	self owner closeTagCreationForm
]

{ #category : #accessing }
MiTagCreationForm >> submitButton [

	^ submitButton
]

{ #category : #private }
MiTagCreationForm >> updateCategories [

	categorySelection items: { nil }, tagModel allCategories
]

{ #category : #accessing }
MiTagCreationForm >> updateQueryList [

	queryList items: { nil } , self fetchQueries
]
