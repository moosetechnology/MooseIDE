Class {
	#name : #MiQueryCreationPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'#queryConfigurationPresenter',
		'#queryCode',
		'#queryTypesDropList',
		'#resultList',
		'#browser',
		'#query => SpObservableSlot',
		'#breadcrumbs',
		'#toolbar'
	],
	#category : #'Midas-FamixQueries-Presenters'
}

{ #category : #commands }
MiQueryCreationPresenter class >> buildCommandsGroupWith: presenter forRoot: aCmCommandsGroup [
	aCmCommandsGroup
		register: (MiQueryCreationCommand forSpecContext: presenter)
]

{ #category : #specs }
MiQueryCreationPresenter class >> defaultSpec [

	^ SpBoxLayout newVertical
		  add: #toolbar height: self toolbarHeight;
		  add: #breadcrumbs height: self toolbarHeight;
		  add: (SpPanedLayout newHorizontal
				   add: self queryConfigurationLayout;
				   positionOfSlider: 65 percent;
				   add: #resultList;
				   yourself);
		  yourself
]

{ #category : #specs }
MiQueryCreationPresenter class >> queryConfigurationHeight [
	"If this is changed, FQQueryConfigurationPresenter>>paddingAroundButton should also be changed."

	"(Padding around button = 50) * 2 + (button height = 29, see SpAbstractPresenter>>buttonHeight)"

	^ 129
]

{ #category : #specs }
MiQueryCreationPresenter class >> queryConfigurationLayout [
	^ SpBoxLayout newVertical
		add: #queryTypesDropList height: self buttonHeight;
		add: #queryConfigurationPresenter
			height: self queryConfigurationHeight;
		add: #queryCode;
		yourself
]

{ #category : #'query configuration presenters' }
MiQueryCreationPresenter class >> queryTypes [
	^ (FQUnaryQuery allSubclasses select: #canBeConfigured)
		"sort: #name ascending"
]

{ #category : #specs }
MiQueryCreationPresenter class >> title [
	^ 'Query Creation'
]

{ #category : #'query configuration' }
MiQueryCreationPresenter >> configureBooleanQuery: aQuery [
	queryConfigurationPresenter := MiBooleanQueryPresenter
		owner: self
		on: aQuery
]

{ #category : #'query configuration' }
MiQueryCreationPresenter >> configureNavigationQuery: aQuery [
	queryConfigurationPresenter := MiNavigationQueryPresenter
		owner: self
		on: aQuery
]

{ #category : #'query configuration' }
MiQueryCreationPresenter >> configureNumericQuery: aQuery [
	queryConfigurationPresenter := MiNumericQueryPresenter
		owner: self
		on: aQuery
]

{ #category : #'query configuration' }
MiQueryCreationPresenter >> configureScopeQuery: aQuery [
	queryConfigurationPresenter := MiScopeQueryPresenter
		owner: self
		on: aQuery
]

{ #category : #'query configuration' }
MiQueryCreationPresenter >> configureStringQuery: aQuery [
	queryConfigurationPresenter := MiStringQueryPresenter
		owner: self
		on: aQuery
]

{ #category : #'query configuration' }
MiQueryCreationPresenter >> configureTypeQuery: aQuery [
	queryConfigurationPresenter := MiTypeQueryPresenter
		owner: self
		on: aQuery
]

{ #category : #initialization }
MiQueryCreationPresenter >> connectPresenters [
	self queryAcceptedPort transmitTo: browser queryInputPort
]

{ #category : #initialization }
MiQueryCreationPresenter >> initialize [
	super initialize.
	self flag: #FQImprove.
	queryTypesDropList selectIndex: 3	"Select the fastest query while we do not compute the results in a fork"
]

{ #category : #initialization }
MiQueryCreationPresenter >> initializeBreadcrumbs [
	breadcrumbs := (MiBreadcrumbsBar
		on: browser selectedQuery parentSequence)
		shapeColor: [ :model | model class color ];
		shapeLabel: [ :model | 
			(model name substrings first withoutPrefix: 'numberOf')
				truncateWithElipsisTo: 10 ];
		shapePopup: [ :model | model name ]
]

{ #category : #initialization }
MiQueryCreationPresenter >> initializePresenters [
	self initializeToolbar.
	self initializeBreadcrumbs.
	self initializeQueryTypesDropList.
	self initializeQueryCode.
	self initializeResultList
]

{ #category : #initialization }
MiQueryCreationPresenter >> initializeQueryCode [
	queryCode := self newCode
		whenSubmitDo: [ :code | self updateFromCode: code ];
		yourself.
	self flag: #FQSpecPb , 'modifying syntaxt highlight is slow for now'
]

{ #category : #initialization }
MiQueryCreationPresenter >> initializeQueryTypesDropList [
	queryTypesDropList := self newDropList
		items: self class queryTypes;
		display: [ :queryClass | queryClass label ];
		whenSelectedItemChangedDo:
				[ :queryClass | self updateQueryConfigurationFor: queryClass ]
]

{ #category : #initialization }
MiQueryCreationPresenter >> initializeResultList [
	resultList := (self instantiate: MiResultTreePresenter on: browser)
		updateForEntities: browser entities;
		yourself
]

{ #category : #initialization }
MiQueryCreationPresenter >> initializeToolbar [

	toolbar := self newToolbar "beText"
]

{ #category : #initialization }
MiQueryCreationPresenter >> initializeWindow: aWindowPresenter [
	super initializeWindow: aWindowPresenter.
	aWindowPresenter initialExtent: 550 @ 400
]

{ #category : #transmissions }
MiQueryCreationPresenter >> notifyAcceptedQuery [
	browser selectedQuery addChild: self query.
	self notifyPropertyChanged: #query
]

{ #category : #accessing }
MiQueryCreationPresenter >> parentEntities [
	^ browser entities
]

{ #category : #accessing }
MiQueryCreationPresenter >> query [
	^ queryConfigurationPresenter query
]

{ #category : #transmissions }
MiQueryCreationPresenter >> queryAcceptedPort [
	^ MiQueryOutputPort newPresenter: self
]

{ #category : #'accessing model' }
MiQueryCreationPresenter >> setModelBeforeInitialization: aQueriesPresenter [
	browser := aQueriesPresenter
]

{ #category : #update }
MiQueryCreationPresenter >> updateForQuery: aQuery [
	"aQuery should already have browser selectedQuery as parent"

	self flag: #FQImprove , 'Use this to update queryConfiguration ?'.
	resultList updateForEntities: aQuery result.
	self updateQueryCode.
	breadcrumbs setModels: aQuery parentSequence.
	self updateToolBar.
	self update
]

{ #category : #update }
MiQueryCreationPresenter >> updateFromCode: code [
	self flag: #FQImprove
]

{ #category : #update }
MiQueryCreationPresenter >> updateFromConfiguration [
	resultList updateForEntities: self query result.
	self updateQueryCode.
	breadcrumbs setModels: self query parentSequence.
	self updateToolBar
]

{ #category : #update }
MiQueryCreationPresenter >> updateQueryCode [
	queryCode
		text:
			(self query isValid
				ifTrue: [ String streamContents: [ :s | self query storeOn: s ] ]
				ifFalse: [ 'No valid query' ]);
		update.
	"syntaxHighlight: self query isValid;"
	self flag: #FQSpecPb , 'modifying syntaxt highlight is slow for now'
]

{ #category : #update }
MiQueryCreationPresenter >> updateQueryConfigurationFor: queryClass [
	self flag: #FQImprove.	"The following method is calling indirectly the method giving the possible types once again.
		
		Currently we configure the query before creating the browser.
		A better way would be to create an unconfigured query, initialize the browser and execute the query with the selected elements of the browser."
	(queryClass defaultForParent: browser selectedQuery) configureIn: self.
	self updateForQuery: queryConfigurationPresenter query
]

{ #category : #update }
MiQueryCreationPresenter >> updateToolBar [
	| commandGroup |
	self flag: #FQSpecPb , 'Disabling a toolbar button does nothing.'.
	commandGroup := self rootCommandsGroup.
	toolbar fillWith: commandGroup.
	commandGroup allCommands do: #updateEnableStatus.
	toolbar update
]
