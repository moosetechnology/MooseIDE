Class {
	#name : #MiBusLogsList,
	#superclass : #SpPresenter,
	#instVars : [
		'logsList',
		'bus',
		'busName',
		'clearButton'
	],
	#category : #'Midas-Core-Logger'
}

{ #category : #commands }
MiBusLogsList class >> buildCommandsGroupWith: presenterInstance forRoot: rootCommandGroup [
	rootCommandGroup
		register:
			(MiPropagateCommand new doNotFreezeBrowser asSpecCommand
				name: 'Propagate';
				context: presenterInstance owner);
		register: (MiInspectCommand forSpecContext: presenterInstance);
		register: (MiLoggerRemoveLogCommand forSpecContext: presenterInstance)
]

{ #category : #specs }
MiBusLogsList class >> defaultSpec [
	^ SpBoxLayout newVertical
		add:
			(SpBoxLayout newHorizontal
				add: #busName;
				add: #clearButton width: self buttonWidth;
				yourself)
			height: self toolbarHeight;
		add: #logsList;
		yourself
]

{ #category : #accessing }
MiBusLogsList >> bus [
	^ bus
]

{ #category : #actions }
MiBusLogsList >> cleanLogger [
	^ bus logger clean
]

{ #category : #actions }
MiBusLogsList >> forBus: aBus [
	bus := aBus.
	busName label: 'Bus: ' , bus name.
	logsList items: bus logger logs
]

{ #category : #initialization }
MiBusLogsList >> initializeClearButton [
	clearButton := self newButton
		label: 'Clear';
		iconName: #smallDelete;
		action: [ self cleanLogger.
			self owner update ];
		yourself
]

{ #category : #initialization }
MiBusLogsList >> initializeLogsList [
	logsList := self newList
		display: [ :log | log entity mooseName ];
		contextMenu: [ self rootCommandsGroup asMenuPresenter ];
		whenSelectionChangedDo: [ :selection | 
			selection selectedItem
				ifNotNil: [ self setOwnerSelectedItem: selection selectedItem ] ];
		yourself
]

{ #category : #initialization }
MiBusLogsList >> initializePresenters [

	super initializePresenters.
	busName := self newLabel.
	self initializeClearButton.
	self initializeLogsList
]

{ #category : #accessing }
MiBusLogsList >> logger [
	^ bus logger
]

{ #category : #accessing }
MiBusLogsList >> miSelectedItem [
	^ logsList selectedItems
		ifEmpty: [  ]
		ifNotEmpty: [ :list | list anyOne entity ]
]

{ #category : #accessing }
MiBusLogsList >> miSelectedLog [
	^ logsList selection selectedItem
]

{ #category : #actions }
MiBusLogsList >> removeLog: aLog [
	self logger removeLog: aLog.
	self update
]

{ #category : #initialization }
MiBusLogsList >> setOwnerSelectedItem: aLog [
	^ self owner selectedItem: aLog entity
]
