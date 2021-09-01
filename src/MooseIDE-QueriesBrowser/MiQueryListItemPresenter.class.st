"
I allow to filter a MooseModel depending on the query that you choose. I have a dropdown list that has all the existing query types. When you select some query type, a configuration presenter is created. This configuration presenter is specific for each type of query.

I manage all the logic related of changing dynamically this configuration presenter. Also, I send a message to my parentPresenter (`MiQueryBuilderPresenter`) each time my add or remove button is pressed.
"
Class {
	#name : #MiQueryListItemPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'queryTypesDropListPresenter',
		'parentQuery',
		'queryNumberLabelPresenter',
		'optionsMenuButton',
		'queryConfiguratorPresenter',
		'parentQueryListPresenter'
	],
	#category : #'MooseIDE-QueriesBrowser-Main presenters'
}

{ #category : #commands }
MiQueryListItemPresenter class >> buildCommandsGroupWith: presenterInstance forRoot: rootCommandGroup [

	rootCommandGroup register:
		((MiAddChildQueryCommand forSpecContext: presenterInstance) 
			 iconName: MiAddChildQueryCommand iconName).
	rootCommandGroup register:
		((MiRemoveQueryCommand forSpecContext: presenterInstance) iconName:
			 MiRemoveQueryCommand iconName)
]

{ #category : #'instance creation' }
MiQueryListItemPresenter class >> owner: aPresenter on: aQuery parentPresenter: aMiQueryListPresenter [

	"We need this method because the owner of the presenter will change to SpComponentListPresenter. The first time the owner is the same as parent presenter. But, then, Spec internally changes it. And we need to have the access to the parent presenter."

	^ self basicNew
		  application: self currentApplication;
		  owner: aPresenter;
		  setModelBeforeInitialization: aQuery;
		  parentQueryListPresenter: aMiQueryListPresenter;
		  initialize;
		  yourself
]

{ #category : #accessing }
MiQueryListItemPresenter >> allQueryPresentersExceptSelf [

	^ parentQueryListPresenter creationPresenters reject: [ :q | 
		  q query = self query ]
]

{ #category : #'api - actions' }
MiQueryListItemPresenter >> disableProgressNotification [

	parentQueryListPresenter disableProgressNotification
]

{ #category : #'api - actions' }
MiQueryListItemPresenter >> enableProgressNotification [

	parentQueryListPresenter enableProgressNotification
]

{ #category : #accessing }
MiQueryListItemPresenter >> indentationSpacesPresenters [

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
MiQueryListItemPresenter >> initializeLayout [

	| tempLayout |
	tempLayout := SpBoxLayout newLeftToRight
		              spacing: 5;
		              borderWidth: 5;
		              yourself.
	self indentationSpacesPresenters do: [ :each | 
		tempLayout add: each expand: false ].
	tempLayout
		add: #queryNumberLabelPresenter expand: false;
		add: #queryTypesDropListPresenter width: 130;
		add: #queryConfiguratorPresenter;
		addLast: #optionsMenuButton expand: false.
	self layout: tempLayout
]

{ #category : #initialization }
MiQueryListItemPresenter >> initializeMenu [

	| optionsMenuGroup |
	optionsMenuGroup := (self class buildRootCommandsGroupFor: self)
		                    asMenuPresenter.
	optionsMenuGroup addGroup: [ :aGroup | 
		aGroup addItem: [ :anItem | 
			anItem
				name: 'Cancel';
				icon: (self iconNamed: #smallCancel);
				action: [  ] ] ].

	optionsMenuButton := self newMenuButton
		                     menu: optionsMenuGroup;
		                     yourself
]

{ #category : #initialization }
MiQueryListItemPresenter >> initializeNumberLabel [

	queryNumberLabelPresenter := self newLabel
]

{ #category : #initialization }
MiQueryListItemPresenter >> initializePresenters [

	self initializeLayout.
	self initializeMenu.
	self initializeNumberLabel.

	self initializeQueryTypesDropList.
	"After setting whenSelectedItemChangedDo:, select the fastest query while we do not compute the
	results in a fork.
	This is for instantiate queryConfigurationPresenter variable"
	queryTypesDropListPresenter selectItem: FQBooleanQuery
]

{ #category : #initialization }
MiQueryListItemPresenter >> initializeQueryTypesDropList [

	queryTypesDropListPresenter := self newDropList.
	queryTypesDropListPresenter
		items: parentQueryListPresenter availableQueryTypes;
		display: [ :queryClass | queryClass label ];
		whenSelectedItemChangedDo: [ :queryClass | 
			self updateQueryConfiguratorPresenterFor: queryClass ]
]

{ #category : #accessing }
MiQueryListItemPresenter >> name [

	^ 'Q' , queryNumberLabelPresenter label
]

{ #category : #actions }
MiQueryListItemPresenter >> newQueryForClass: queryClass [

	| newQuery |
	(parentQuery children includes: self query) ifTrue: [ 
		parentQuery removeChild: self query ].

	newQuery := (queryClass isNAryQuery or: [ 
		             queryClass isComplementQuery ])
		            ifTrue: [ queryClass new ]
		            ifFalse: [ queryClass defaultForParent: parentQuery ].
	parentQuery addChild: newQuery.
	^ newQuery
]

{ #category : #accessing }
MiQueryListItemPresenter >> parentQueryListPresenter [

	^ parentQueryListPresenter
]

{ #category : #accessing }
MiQueryListItemPresenter >> parentQueryListPresenter: aPresenter [

	parentQueryListPresenter := aPresenter
]

{ #category : #accessing }
MiQueryListItemPresenter >> query [

	^ queryConfiguratorPresenter
		  ifNotNil: [ queryConfiguratorPresenter query ]
		  ifNil: [ nil ]
]

{ #category : #'api - actions' }
MiQueryListItemPresenter >> queryChangedUpdate [

	parentQueryListPresenter queryChangedUpdate: self query
]

{ #category : #'api - actions' }
MiQueryListItemPresenter >> queryPresentersListChanged [

	queryConfiguratorPresenter queryPresentersListChanged
]

{ #category : #accessing }
MiQueryListItemPresenter >> queryTypesDropList [

	^ queryTypesDropListPresenter
]

{ #category : #'accessing - model' }
MiQueryListItemPresenter >> setModelBeforeInitialization: aQuery [

	parentQuery := aQuery
]

{ #category : #accessing }
MiQueryListItemPresenter >> setQueryNumber: anInteger [

	queryNumberLabelPresenter label: anInteger asString
]

{ #category : #update }
MiQueryListItemPresenter >> updateQueryConfiguratorPresenterFor: queryClass [

	| newQuery |
	"Create the new query"
	newQuery := self newQueryForClass: queryClass.

	"Instantiate the configuration presenter with the new created query"
	queryConfiguratorPresenter := self instantiate:
		                              (queryClass miPresenterClass
			                               owner: self
			                               on: newQuery).
	"We update the subqueries droplist of all the presenters in the queries browser.
	This is to keep the list of the queries updated."
	parentQueryListPresenter updateSubqueriesListPresenter.
	self update
]
