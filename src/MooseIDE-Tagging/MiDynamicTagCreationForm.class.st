Class {
	#name : #MiDynamicTagCreationForm,
	#superclass : #MiTagAbstractCreationForm,
	#instVars : [
		'queryList',
		'selectedQuery'
	],
	#category : #'MooseIDE-Tagging-Browser'
}

{ #category : #initialization }
MiDynamicTagCreationForm >> checkFormInputs [

	nameField text ifEmpty: [ ^ false ].
	queryList selectedItem ifNil: [ ^ false ].
	^ true
]

{ #category : #initialization }
MiDynamicTagCreationForm >> connectPresenters [

	cancelButton action: [ 
		self reset.
		self owner closeTagCreationForm ].
	submitButton action: [ self submit ]
]

{ #category : #initialization }
MiDynamicTagCreationForm >> fetchQueries [

	^ (self owner application itemsFor: FQAbstractQuery) asOrderedCollection
]

{ #category : #initialization }
MiDynamicTagCreationForm >> formLayout [

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
				   add: descriptionField height: 150;
				   yourself)
		  expand: false;
		  add: (self newLabel label: 'Query (optional)') expand: false;
		  add: queryList expand: false;
		  add: (SpBoxLayout newLeftToRight
				   vAlignEnd;
				   spacing: 10;
				   add: cancelButton;
				   add: submitButton;
				   yourself);
		  yourself
]

{ #category : #initialization }
MiDynamicTagCreationForm >> initializePresenters [

	queryList := self newDropList
		             startWithoutSelection;
		             display: [ :query | 
			            self stringForQuery: query ] yourself.
	self updateQueryList.
	super initializePresenters
]

{ #category : #initialization }
MiDynamicTagCreationForm >> reset [

	colorPicker setColor: Color random.
	nameField text: ''.
	descriptionField text: ''.
	categorySelection resetSelection.
	queryList resetSelection
]

{ #category : #initialization }
MiDynamicTagCreationForm >> stringForQuery: aQuery [

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
MiDynamicTagCreationForm >> submit [

	self checkFormInputs ifFalse: [ ^ self ].
	self owner
		createDynamicTag: nameField text
		description: descriptionField text
		color: colorPicker color
		category: categorySelection selectedItem
		query: queryList selectedItem.
	self owner closeTagCreationForm
]

{ #category : #accessing }
MiDynamicTagCreationForm >> title [

	^ 'Create dynamic tag'
]

{ #category : #accessing }
MiDynamicTagCreationForm >> updateQueryList [

	queryList items: { nil } , self fetchQueries
]
