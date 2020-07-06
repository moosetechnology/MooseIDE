Class {
	#name : #MiQueriesCombinationPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'#queriesTree',
		'#resultList',
		'#combinationsDroplist',
		'#parentQueries',
		'#newQuery',
		'#browser',
		'#toolBar',
		'#queryWasValidated',
		'#query => SpObservableSlot',
		'#firstParent',
		'#secondParent',
		'#reverseButton',
		'#queryOperator'
	],
	#category : #'Midas-FamixQueries-Presenters'
}

{ #category : #commands }
MiQueriesCombinationPresenter class >> buildCommandsGroupWith: presenter forRoot: aCmCommandsGroup [
	aCmCommandsGroup
		register:
			((MiQueryCreationCommand forSpecWithIconNamed: #glamorousGo)
				context: presenter)
]

{ #category : #specs }
MiQueriesCombinationPresenter class >> defaultSpec [
	^ SpBoxLayout newVertical
		add: #toolBar height: self toolbarHeight;
		add:
			(SpPanedLayout newHorizontal
				add:
					(SpBoxLayout newVertical
						add: #combinationsDroplist height: self buttonHeight;
						add: #queriesTree;
						yourself);
				add: #resultList;
				yourself);
		yourself
]

{ #category : #specs }
MiQueriesCombinationPresenter class >> nonCommuntativeQueryLayout [
	^ SpBoxLayout newVertical
		add: #toolBar height: self toolbarHeight;
		add:
			(SpPanedLayout newHorizontal
				add:
					(SpBoxLayout newVertical
						add: #combinationsDroplist height: self buttonHeight;
						add: self parentsInversionLayout
							height: self parentInversionHeight;
						add: #queriesTree;
						yourself);
				add: #resultList;
				yourself);
		yourself
]

{ #category : #specs }
MiQueriesCombinationPresenter class >> parentInversionHeight [
	"3 labels in parentsInversionLayout"

	^ self labelHeight * 3
]

{ #category : #specs }
MiQueriesCombinationPresenter class >> parentsInversionLayout [
	^ SpBoxLayout newHorizontal
		add:
			(SpBoxLayout newVertical
				add: #firstParent;
				add: #queryOperator;
				add: #secondParent;
				yourself);
		add: #reverseButton width: self buttonHeight;
		yourself
]

{ #category : #specs }
MiQueriesCombinationPresenter class >> title [
	^ 'Queries Combination'
]

{ #category : #initialization }
MiQueriesCombinationPresenter >> basicInitializeQueriesTree [
	queriesTree := SpNullPresenter new
]

{ #category : #initialization }
MiQueriesCombinationPresenter >> connectPresenters [
	self queryAcceptedPort
		transmitTo: browser queryInputPort
		transform: [ :q | 
			self window close.
			q ]
]

{ #category : #initialization }
MiQueriesCombinationPresenter >> initialize [
	super initialize.
]

{ #category : #initialization }
MiQueriesCombinationPresenter >> initializeDropList [
	combinationsDroplist := self newDropList
		items: FQBinaryQuery availableCombinations;
		display: [ :queryClass | queryClass label ];
		whenSelectedItemChangedDo: [ :queryClass | self updateForQueryClass: queryClass ]
]

{ #category : #initialization }
MiQueriesCombinationPresenter >> initializeNonCommutativeConfiguration [
	firstParent := self newLabel.
	secondParent := self newLabel.
	queryOperator := self newLabel.
	reverseButton := self newButton
		icon: (self theme iconNamed: #glamorousRefresh);
		action: [ newQuery reverseParents.
			self updateSubPresenters ]
]

{ #category : #initialization }
MiQueriesCombinationPresenter >> initializePresenters [
	self initializeToolBar.
	self initializeDropList.
	self basicInitializeQueriesTree.
	self initializeResultList.
	self initializeNonCommutativeConfiguration
]

{ #category : #initialization }
MiQueriesCombinationPresenter >> initializeResultList [
	resultList := self instantiate: MiResultTreePresenter on: browser
]

{ #category : #initialization }
MiQueriesCombinationPresenter >> initializeToolBar [
	toolBar := self newToolbar fillWith: self rootCommandsGroup
]

{ #category : #initialization }
MiQueriesCombinationPresenter >> initializeWindow: aWindowPresenter [
	super initializeWindow: aWindowPresenter.
	aWindowPresenter
		whenClosedDo: [ queryWasValidated
				ifFalse: [ parentQueries do: [ :parent | parent removeChild: newQuery ] ] ]
]

{ #category : #update }
MiQueriesCombinationPresenter >> labelsForNonCommutativeQuery: aQuery [
	firstParent label: aQuery parents first name.
	secondParent label: aQuery parents second name.
	queryOperator label: newQuery operator asString
]

{ #category : #accessing }
MiQueriesCombinationPresenter >> newQuery [
	^ newQuery
]

{ #category : #transmissions }
MiQueriesCombinationPresenter >> notifyAcceptedQuery [
	queryWasValidated := true.
	self notifyPropertyChanged: #query
]

{ #category : #opening }
MiQueriesCombinationPresenter >> onQueries: aQueriesCollection [
	parentQueries := aQueriesCollection.
	(queriesTree := MiRoassalQueryPresenter on: parentQueries)
		noInteractions;
		adaptToBrowser: browser.
	combinationsDroplist selectIndex: 1
]

{ #category : #accessing }
MiQueriesCombinationPresenter >> parentEntities [
	^ browser entities
]

{ #category : #accessing }
MiQueriesCombinationPresenter >> query [
	^ newQuery
]

{ #category : #transmissions }
MiQueriesCombinationPresenter >> queryAcceptedPort [
	^ MiQueryOutputPort newPresenter: self
]

{ #category : #'accessing model' }
MiQueriesCombinationPresenter >> setModelBeforeInitialization: aBrowser [
	browser := aBrowser.
	queryWasValidated := false
]

{ #category : #update }
MiQueriesCombinationPresenter >> updateForQueryClass: queryClass [
	newQuery ifNotNil: [ newQuery prepareRemoval ].
	newQuery := queryClass new
		beChildOf: parentQueries;
		yourself.
	self updateLayoutForQueryClass: queryClass.
	self updateSubPresenters.
	self update
]

{ #category : #update }
MiQueriesCombinationPresenter >> updateLayoutForQueryClass: queryClass [
	layout := queryClass isCommutative
		ifTrue: [ self class defaultSpec ]
		ifFalse: [ self class nonCommuntativeQueryLayout ]
]

{ #category : #update }
MiQueriesCombinationPresenter >> updateSubPresenters [
	self labelsForNonCommutativeQuery: newQuery.
	queriesTree updateWithQueries: newQuery parents , {newQuery}.
	resultList updateForEntities: newQuery result
]
