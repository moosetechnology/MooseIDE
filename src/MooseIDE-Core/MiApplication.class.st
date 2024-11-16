"
The spec application for Moose IDE.
This is a singleton
"
Class {
	#name : #MiApplication,
	#superclass : #SpApplication,
	#instVars : [
		'buses',
		'defaultBus',
		'producers',
		'consumers',
		'dropFileHandlers',
		'mooseModelsTag',
		'currentModelsBrowser'
	],
	#classVars : [
		'Current'
	],
	#category : #'MooseIDE-Core-Application'
}

{ #category : #'instance creation' }
MiApplication class >> current [

	  ^ Current ifNil: [ Current := self new ]
]

{ #category : #accessing }
MiApplication class >> defaultBusName [

	^ 'Default'
]

{ #category : #'class initialization' }
MiApplication class >> reset [
	<script>
	Current ifNotNil: [ [Current unregisterForDropFilesEvent] onErrorDo: [ "ignore" ] ].
	Current := nil
]

{ #category : #brokerage }
MiApplication >> add: anObject toDictionary: aDictionary for: aKey [
	"adds anObject to the list of objects for given aKey in aDictionary
	 We expect the list for objects (producers or consumers) for any key will remain small"
	| objectList |
	objectList := aDictionary at: aKey ifAbsent: [ Set new: 2 ].
	objectList add: anObject.
	aDictionary at: aKey put: objectList.
	
]

{ #category : #bindings }
MiApplication >> addBindingForModel: aModel [

	self addSharedBinding:
		(WorkspaceVariable key: aModel name asValidSelector value: aModel)
]

{ #category : #accessing }
MiApplication >> allBrowsers: aMiClass [
	^self browsers select: [ :aBrowser | aBrowser isKindOf: aMiClass ]
]

{ #category : #'drag and drop support' }
MiApplication >> beDropFilesHandler [

	dropFileHandlers := { #mse. #json } collect: [ :extension |
		                    | handler |
		                    handler := ExternalDropHandler
			                               type: nil
			                               extension: extension
			                               action: [ :fileReference |
			                               self importModelFromFile:
				                               fileReference ].
		                    ExternalDropHandler registerHandler: handler.
		                    handler ]
]

{ #category : #accessing }
MiApplication >> browsers [
	^ self windows collect: #presenter thenSelect: #isMiBrowser
]

{ #category : #buses }
MiApplication >> busNamed: aName [

	  ^ buses detect: [ :b | b name = aName ] ifNone: [ 
		    | bus |
		    bus := MiBus named: aName.
		    buses add: bus.
		    self defaultBus: bus.
		    self updateOverviewBrowsers.
		    bus ]
]

{ #category : #accessing }
MiApplication >> buses [
	^ buses
]

{ #category : #brokerage }
MiApplication >> consumeItem: anItem [

	self consumeItem: anItem from: nil
]

{ #category : #brokerage }
MiApplication >> consumeItem: anItem from: aProducer [

	(self consumersOf: anItem class) do: [ :aConsumer | 
		aProducer = aConsumer ifFalse: [ aConsumer consume: anItem ] ]
]

{ #category : #brokerage }
MiApplication >> consumeItemsFrom: aProducer ofType: aClass [

	(aProducer itemsFor: aClass) do: [ :anItem | 
		self consumeItem: anItem ]
]

{ #category : #brokerage }
MiApplication >> consumer: aConsumer requestFor: requestedClass [

	(self producersOf: requestedClass) do: [ :aProducer | 
		(aProducer itemsFor: requestedClass) do: [ :anItem | 
			aConsumer consume: anItem ] ]
]

{ #category : #brokerage }
MiApplication >> consumersOf: aClass [

	| foundConsumers |
	foundConsumers := Set new.
	consumers keysDo: [ :consumedClass | 
		(self produced: aClass matchConsumed: consumedClass) ifTrue: [ 
			foundConsumers addAll: (consumers at: consumedClass) ] ].
	^ foundConsumers
]

{ #category : #'drag and drop support' }
MiApplication >> currentModelsBrowser [

	^ currentModelsBrowser
]

{ #category : #buses }
MiApplication >> defaultBus [

	^ defaultBus
]

{ #category : #buses }
MiApplication >> defaultBus: aMiBus [

	  defaultBus := aMiBus
]

{ #category : #showing }
MiApplication >> defaultWindowPresenterClass [

	^ MiWindowPresenter
]

{ #category : #buses }
MiApplication >> deleteBus: aBus [

	aBus == defaultBus ifTrue: [ ^ self ].
	buses remove: aBus ifAbsent: [  ].
	self updateOverviewBrowsers
]

{ #category : #buses }
MiApplication >> deleteBusNamed: aName [
	buses
		detect: [ :bus | bus name = aName ]
		ifFound: [ :bus | self deleteBus: bus ]
]

{ #category : #accessing }
MiApplication >> iconForTag: aTag [

	^ self iconProvider iconForTag: aTag
]

{ #category : #'drag and drop support' }
MiApplication >> importModelFromFile: aFileReference [

	self openCurrentModelsBrowser handleDropFile: aFileReference
]

{ #category : #initialization }
MiApplication >> initialize [

	super initialize.

	buses := OrderedCollection new.
	defaultBus := self busNamed: self class defaultBusName.

	consumers := Dictionary new.
	producers := Dictionary new.

	mooseModelsTag := Dictionary new: 5.

	self beDropFilesHandler.
	self registerToModelsAnnouncements
]

{ #category : #brokerage }
MiApplication >> itemsFor: aClass [
	| setCopy |

	setCopy := Set new.
	 (self producersOf: aClass) do: [ :producer | 
		  (producer itemsFor: aClass ) do: [ :e | setCopy add: e shallowCopy ]].
	^ setCopy
	
]

{ #category : #style }
MiApplication >> mooseStyleSheet [

	^ SpStyleVariableSTONReader fromString: '.application [
	   .titleLabel [
			Font { 
				#size: 18,
				#bold: true
			},
			Geometry { #height: Reset }
		],
		.title1 [ Font { #size: 12, #bold: true }, Geometry { #height: Reset } ],
		.hSep [ 
			Geometry {
				#height: 1
			},
			.vSep [ Geometry { #height: 25, #width: 1 } ],
			Draw {
				#color: #0000001F,
				#backgroundColor: #0000001F
			}
		],
		.itemList [
			Container { #borderWidth: 1, #borderColor: #00000020 },
			Draw { #backgroundColor: #00000010 },
			Geometry { #height: 30 }
		],
		.mooseContainer [ Container { #borderColor: #00000020, #borderWidth: 1, #padding: 5 } ],
		.help [ Geometry { 
			#height: 225,
			#width: 250 } ],
		.smallList [ Geometry { #height: 120, #width: 120 } ],
		.largeList [ Geometry { #height: 250, #width: 250 } ]
]'
]

{ #category : #'private - factory' }
MiApplication >> newIconProvider [

	^ MiIconProvider new
]

{ #category : #'drag and drop support' }
MiApplication >> openCurrentModelsBrowser [

	^ currentModelsBrowser
		  ifNotNil: [ :modelsBrowser |
			  modelsBrowser withWindowDo: [ :window |
				  window
					  restore;
					  activate ] ]
		  ifNil: [
		  currentModelsBrowser := MiModelsBrowser instantiateAndOpen ]
]

{ #category : #presenters }
MiApplication >> openedBrowsers [
	^self browsers
]

{ #category : #brokerage }
MiApplication >> produced: producedClass matchConsumed: consumedClass [

	producedClass = consumedClass ifTrue: [ ^ true ].
	(producedClass inheritsFrom: consumedClass) ifTrue: [ ^ true ].
	(producedClass traits includes: consumedClass) ifTrue: [ ^ true ].
	^ false
]

{ #category : #brokerage }
MiApplication >> producersOf: aClass [

	| foundProducers |
	
	foundProducers := Set new.
	producers keysDo: [ :producedClass | 
		(self produced: producedClass matchConsumed: aClass) ifTrue: [ 
			foundProducers addAll: (producers at: producedClass) ] ].
	^ foundProducers
]

{ #category : #brokerage }
MiApplication >> registerConsumer: aConsumer for: aClass [

	"adds a consumer to the list of consumers for given aClass"

	self add: aConsumer toDictionary: consumers for: aClass
]

{ #category : #brokerage }
MiApplication >> registerProducer: aProducer for: aClass [

	"adds a producer to the list of producers for given aClass"

	self add: aProducer toDictionary: producers for: aClass
]

{ #category : #bindings }
MiApplication >> registerToModelsAnnouncements [

	MooseModel root entitiesDo: [ :model |
		self addBindingForModel: model.
		self registerToSingleModelAnnouncements: model ].

	MooseModel root announcer
		when: MooseEntityAdded
		do: [ :announcement |
			self addBindingForModel: announcement entity.
			self registerToSingleModelAnnouncements: announcement entity ]
		for: self.

	MooseModel root announcer
		when: MooseEntityRemoved
		do: [ :announcement |
		self removeBindingNamed: announcement entity name ]
		for: self
]

{ #category : #bindings }
MiApplication >> registerToSingleModelAnnouncements: aModel [

	aModel announcer
		when: MooseEntityRenamed
		do: [ :announcement |
			self removeBindingNamed: announcement oldName.
			self addBindingForModel: aModel ]
		for: self
]

{ #category : #private }
MiApplication >> registerWindow: aWindow [

	super registerWindow: aWindow.
	self updateOverviewBrowsers
]

{ #category : #bindings }
MiApplication >> removeBindingNamed: aName [

	self sharedBindings removeKey: aName asValidSelector ifAbsent: [  ]
]

{ #category : #brokerage }
MiApplication >> removeItem: anItem [

	self removeItem: anItem from: nil
]

{ #category : #brokerage }
MiApplication >> removeItem: anItem from: aProducer [

	(self consumersOf: anItem class) do: [ :aConsumer | 
		aProducer = aConsumer ifFalse: [ aConsumer remove: anItem ] ]
]

{ #category : #tags }
MiApplication >> selectedTag: aTag [
	"mooseModel is deduced from aTag itself"

	aTag ifNotNil: [
		mooseModelsTag at: aTag mooseModel put: aTag
	]
]

{ #category : #running }
MiApplication >> start [
	"we will see"
]

{ #category : #style }
MiApplication >> styleSheet [

	^ super styleSheet , self mooseStyleSheet
]

{ #category : #tags }
MiApplication >> tagListForMooseModel: aMooseModel [
	^aMooseModel 
		ifNil: [ #() ]
		ifNotNil: [ aMooseModel allTags sorted: [ :a :b | a name < b name ] ]
]

{ #category : #tags }
MiApplication >> tagSelectedInMooseModel: aMooseModel [
	^mooseModelsTag at: aMooseModel ifAbsent: [ nil ]
]

{ #category : #settings }
MiApplication >> toolbarDisplayMode [

	^ StPharoSettings toolbarDisplayMode
]

{ #category : #brokerage }
MiApplication >> unregisterConsumer: aConsumer [

	"removes aConsumer from all lists of consumers for any class"

	consumers do: [ :consumerList | 
		consumerList remove: aConsumer ifAbsent: [  ] ]
]

{ #category : #'drag and drop support' }
MiApplication >> unregisterForDropFilesEvent [

	ExternalDropHandler registeredHandlers removeAll: dropFileHandlers.
	dropFileHandlers := #(  )
]

{ #category : #'drag and drop support' }
MiApplication >> unregisterModelsBrowser [

	currentModelsBrowser := nil
]

{ #category : #brokerage }
MiApplication >> unregisterProducer: aProducer [

	"removes aProducer from all lists of producers for any class"

	producers do: [ :producerList | 
		producerList remove: aProducer ifAbsent: [  ] ]
]

{ #category : #brokerage }
MiApplication >> updateItem: anItem [

	self updateItem: anItem from: nil
]

{ #category : #brokerage }
MiApplication >> updateItem: anItem from: aProducer [

	(self consumersOf: anItem class) do: [ :aConsumer | 
		aProducer = aConsumer ifFalse: [ aConsumer update: anItem ] ]
]

{ #category : #actions }
MiApplication >> updateOverviewBrowsers [

	(self windows
		collect: [ :each | each presenter]
		thenSelect: [ :presenter | presenter class == MiOverviewBrowser ])
		do: [ :each | each updateBrowsersListItems]
]

{ #category : #windows }
MiApplication >> windowClosed: aWindowPresenter [

	super windowClosed: aWindowPresenter.
	self updateOverviewBrowsers
]
