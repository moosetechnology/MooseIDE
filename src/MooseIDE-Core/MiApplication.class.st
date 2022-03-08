Class {
	#name : #MiApplication,
	#superclass : #SpApplication,
	#instVars : [
		'buses',
		'defaultBus',
		'producers',
		'consumers'
	],
	#classInstVars : [
		'Current'
	],
	#category : #'MooseIDE-Core-Application'
}

{ #category : #'instance creation' }
MiApplication class >> current [
	^ Current ifNil: [ Current := self new
  		yourself. ]
]

{ #category : #accessing }
MiApplication class >> defaultBusName [
	^ 'Default'
]

{ #category : #'instance creation' }
MiApplication class >> reset [
	<script>
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

{ #category : #accessing }
MiApplication >> browsers [
	^ self windows collect: #presenter thenSelect: #isMiBrowser
]

{ #category : #buses }
MiApplication >> busNamed: aName [
	^ buses
		detect: [ :b | b name = aName ]
		ifNone: [ | bus |
			bus := MiBus named: aName.
			buses add: bus.
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

{ #category : #buses }
MiApplication >> defaultBus [

	^ defaultBus
]

{ #category : #showing }
MiApplication >> defaultWindowPresenterClass [

	^ MiWindowPresenter "SpWindowPresenter"
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

{ #category : #initialization }
MiApplication >> initialize [

	super initialize.

	buses := OrderedCollection new.
	defaultBus := self busNamed: self class defaultBusName.
	
	consumers := Dictionary new.
	producers  := Dictionary new.
]

{ #category : #brokerage }
MiApplication >> itemsFor: aClass [

	^ (self producersOf: aClass) flatCollect: [ :producer | 
		  producer itemsFor: aClass ]
]

{ #category : #'private - factory' }
MiApplication >> newIconProvider [

	^ MiIconProvider new
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

{ #category : #private }
MiApplication >> registerWindow: aWindow [

	super registerWindow: aWindow.
	self updateOverviewBrowsers
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

{ #category : #running }
MiApplication >> start [
	"we will see"
]

{ #category : #brokerage }
MiApplication >> unregisterConsumer: aConsumer [

	"removes aConsumer from all lists of consumers for any class"

	consumers do: [ :consumerList | 
		consumerList remove: aConsumer ifAbsent: [  ] ]
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
