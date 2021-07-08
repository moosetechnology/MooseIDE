"
I allow to filter a MooseModel depending on the query that you choose. I have a dropdown list that has all the existing query types. When you select some query type, a configuration presenter is created. This configuration presenter is specific for each type of query.

I manage all the logic related of changing dynamically this configuration presenter. Also, I send a message to my parentPresenter (`MiQueryBuilderPresenter`) each time my add or remove button is pressed.
"
Class {
	#name : #MiNewQueryCreationPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'queryTypesDropListPresenter',
		'queryConfigurationPresenter',
		'parentQuery',
		'parentPresenter',
		'queryNumber',
		'queryNumberLabelPresenter',
		'optionsMenuButton'
	],
	#category : #'Midas-NewTools-Queries Browser'
}

{ #category : #'instance creation' }
MiNewQueryCreationPresenter class >> on: aModel parentPresenter: aPresenter [

	^ self basicNew
		  application: self currentApplication;
		  setModelBeforeInitialization: aModel;
		  parentPresenter: aPresenter;
		  initialize;
		  yourself
]

{ #category : #'instance creation' }
MiNewQueryCreationPresenter class >> on: aModel parentPresenter: aPresenter queryNumber: aNumber [

	^ self basicNew
		  application: self currentApplication;
		  setModelBeforeInitialization: aModel;
		  parentPresenter: aPresenter;
		  queryNumber: aNumber;
		  initialize;
		  yourself
]

{ #category : #actions }
MiNewQueryCreationPresenter >> addNewQueryAction [

	parentPresenter addNewQueryAction: self query
	"We need to see if after adding a new query we have to disable this one."
]

{ #category : #accessing }
MiNewQueryCreationPresenter >> allQueryPresenters [

	^ parentPresenter creationPresenters
]

{ #category : #accessing }
MiNewQueryCreationPresenter >> indentationSpacesPresenters [

	"Returns a collection with blank images to show the level of indentation that the query has"

	| indentationPresenters indentationLevel |
	indentationLevel := parentQuery parentSequence size - 1.
	indentationPresenters := OrderedCollection empty.
	indentationLevel timesRepeat: [ 
		indentationPresenters add: (SpImagePresenter new
				 image: ((self iconNamed: #blank) scaledToSize: 10 @ 10);
				 yourself) ].
	^ indentationPresenters
]

{ #category : #initialization }
MiNewQueryCreationPresenter >> initializeButtons [

	| optionsMenuGroup |
	optionsMenuGroup := self newMenu.
	optionsMenuGroup addGroup: [ :aGroup | 
		aGroup
			addItem: [ :anItem | 
				anItem
					name: 'Add a child query';
					icon: (self iconNamed: #smallAdd);
					help: 'Restrict result by adding a query';
					action: [ self addNewQueryAction ] ];
			addItem: [ :anItem | 
				anItem
					name: 'Remove this query';
					icon: (self iconNamed: #remove);
					help: 'Remove query and its sub-queries';
					action: [ self removeQueryAction ] ];
			addItem: [ :anItem | 
				anItem
					name: 'Negate/Unnegate';
					icon: (self iconNamed: #exception);
					help: 'Negate/Unnegate the query';
					action: [ self negateQueryAction ] ] ].
	optionsMenuButton := self newMenuButton
		                     menu: optionsMenuGroup;
		                     yourself
]

{ #category : #initialization }
MiNewQueryCreationPresenter >> initializeLayout [

	| buttonConstraints tempLayout |
	buttonConstraints := [ :constraints | 
	                     constraints
		                     width: self class iconWidth;
		                     expand: false ].
	tempLayout := SpBoxLayout newLeftToRight
		              spacing: 5;
		              borderWidth: 5;
		              yourself.
	self indentationSpacesPresenters do: [ :each | 
		tempLayout add: each expand: false ].
	tempLayout
		add: #queryNumberLabelPresenter expand: false;
		add: #queryTypesDropListPresenter width: 130;
		add: #queryConfigurationPresenter;
		addLast: #optionsMenuButton expand: false.
	self layout: tempLayout
]

{ #category : #initialization }
MiNewQueryCreationPresenter >> initializeNumberLabel [

	queryNumberLabelPresenter := self newLabel.
	queryNumberLabelPresenter label: queryNumber asString
]

{ #category : #initialization }
MiNewQueryCreationPresenter >> initializePresenters [

	self initializeLayout.
	self initializeButtons.
	self initializeNumberLabel.

	self initializeQueryTypesDropList.
	"After setting whenSelectedItemChangedDo:, select the fastest query while we do not compute the
	results in a fork.
	This is for instantiate queryConfigurationPresenter variable"
	"Changed, initially was typeQuery (selectIndex: 3)"
	queryTypesDropListPresenter selectItem: FQBooleanQuery
]

{ #category : #initialization }
MiNewQueryCreationPresenter >> initializeQueryTypesDropList [

	queryTypesDropListPresenter := self newDropList.
	queryTypesDropListPresenter
		items: parentPresenter availableQueryTypes;
		display: [ :queryClass | queryClass label ];
		whenSelectedItemChangedDo: [ :queryClass | 
			self updateQueryConfigurationFor: queryClass ]
]

{ #category : #testing }
MiNewQueryCreationPresenter >> isNegated [
	^self query isNegated 
]

{ #category : #accessing }
MiNewQueryCreationPresenter >> isNegated: aBoolean [

	self query isNegated: aBoolean.
	self queryChangedUpdate
]

{ #category : #accessing }
MiNewQueryCreationPresenter >> name [

	^ 'Q', queryNumber asString
]

{ #category : #actions }
MiNewQueryCreationPresenter >> negateQueryAction [

	self query canBeNegated
		ifTrue: [ self isNegated: self isNegated not ]
		ifFalse: [ 
		UIManager default inform: 'This type of query cannot be negated' ]
]

{ #category : #actions }
MiNewQueryCreationPresenter >> newQueryForClass: queryClass [

	| newQuery |
	(parentQuery children includes: self query) ifTrue: [ 
		parentQuery removeChild: self query ].

	queryClass isNAryQuery
		ifTrue: [ newQuery := parentQuery ]
		ifFalse: [ 
			newQuery := queryClass defaultForParent: parentQuery.
			parentQuery addChild: newQuery ].
	^ newQuery
]

{ #category : #accessing }
MiNewQueryCreationPresenter >> parentPresenter: aMiQueryBuilderPresenter [

	parentPresenter := aMiQueryBuilderPresenter
]

{ #category : #accessing }
MiNewQueryCreationPresenter >> query [

	^ queryConfigurationPresenter
		  ifNotNil: [ queryConfigurationPresenter query ]
		  ifNil: [ nil ]
]

{ #category : #'api - actions' }
MiNewQueryCreationPresenter >> queryChangedUpdate [

	parentPresenter ifNotNil: [ 
		parentPresenter queryChangedUpdate: self query ]
]

{ #category : #accessing }
MiNewQueryCreationPresenter >> queryConfigurationPresenter [

	^ queryConfigurationPresenter
]

{ #category : #accessing }
MiNewQueryCreationPresenter >> queryNumber: anInteger [

	queryNumber := anInteger
]

{ #category : #actions }
MiNewQueryCreationPresenter >> removeQueryAction [

	parentPresenter removeQueryAction: self
]

{ #category : #'accessing - model' }
MiNewQueryCreationPresenter >> setModelBeforeInitialization: aQuery [

	parentQuery := aQuery
]

{ #category : #'api - actions' }
MiNewQueryCreationPresenter >> updateFromConfiguration [

	"This method name is not meaningful. This method is kept only for backwards compatibility with the old queries browser."

	^ self queryChangedUpdate
]

{ #category : #update }
MiNewQueryCreationPresenter >> updateQueryConfigurationFor: queryClass [

	| newQuery |
	"Create the new query"
	newQuery := self newQueryForClass: queryClass.

	"Instantiate the configuration presenter with the new created query"
	queryConfigurationPresenter := self instantiate:
		                               (queryClass miPresenterClass
			                                owner: self
			                                on: newQuery).

	self isNegated: false.

	self update
]
