"
A model for the CoUsageMap browser
"
Class {
	#name : #MiCoUsageMapModel,
	#superclass : #MiAbstractModel,
	#instVars : [
		'settingsWindow',
		'containerEntities',
		'selectedEntity',
		'strategies',
		'methodAttributeCounter',
		'innerBoxes',
		'containerBoxes',
		'widthScale'
	],
	#category : #'MooseIDE-CoUsageMap-Model'
}

{ #category : #tagging }
MiCoUsageMapModel >> automaticColor [

	self changeTagsDuring: [ 
		self containerBoxes
			do: [:met | self automaticColorForContainerBox: met ].
	]
	
]

{ #category : #tagging }
MiCoUsageMapModel >> automaticColorForContainerBox: aMiContainer [
	| groupsByTag |

	groupsByTag := aMiContainer innerBoxes groupedBy: [ :att | att tag ].
	groupsByTag ifEmpty: [ "nothing to compare" ^ self ].
	self strategies do: [ :strat | 
		strat
			method: aMiContainer;
			groupsByTag: groupsByTag.
		strat computeTag ifNotNil: [ :tag | 
			self setTag: tag onInnerBox: aMiContainer.
			^ self ] ].
	self setTag: nil onInnerBox: aMiContainer
]

{ #category : #tagging }
MiCoUsageMapModel >> changeTagsDuring: aBlockClosure [
	| lastTag |
	lastTag := self selectedTag.
	aBlockClosure value.
	self selectedTag: lastTag
]

{ #category : #'private - for tests' }
MiCoUsageMapModel >> closeSettings [
	"used only for closing settings opened in tests"
	settingsWindow ifNotNil: [ settingsWindow close ]
]

{ #category : #accessing }
MiCoUsageMapModel >> containerBoxNamed: aByteString [
	^ self containerBoxes detect: [ :contr | contr name = aByteString ]
]

{ #category : #accessing }
MiCoUsageMapModel >> containerBoxes [
	^containerBoxes
]

{ #category : #accessing }
MiCoUsageMapModel >> containerEntities [
	^ containerEntities
]

{ #category : #accessing }
MiCoUsageMapModel >> containerEntities: aCollection [
	containerEntities := aCollection
]

{ #category : #accessing }
MiCoUsageMapModel >> containerInnerCounter [

	^ methodAttributeCounter
]

{ #category : #accessing }
MiCoUsageMapModel >> containerInnerCounter: aMiCoMethodAttributeCounter [
	methodAttributeCounter := aMiCoMethodAttributeCounter
]

{ #category : #default }
MiCoUsageMapModel >> defaultInnerSortBlock [
	^ [ :inner1 :inner2 :containr | inner1 name < inner2 name ].
]

{ #category : #default }
MiCoUsageMapModel >> defaultSettings [
	^ MiCoUsageMapSettings
]

{ #category : #default }
MiCoUsageMapModel >> defaultSortBlock [
	^ [ :container1 :container2 | 
		| size1 size2 |
		size1 := container1 innerBoxes size.
		size2 := container2 innerBoxes size.
		size1 = size2 
			ifTrue: [ container1 name < container2 name ]
			ifFalse: [ size1 > size2 ]
		 ].
]

{ #category : #default }
MiCoUsageMapModel >> defaultTester [
	^ MiCoFromSettingsMethodAttributeTester new
]

{ #category : #accessing }
MiCoUsageMapModel >> entities [
	^containerEntities
]

{ #category : #actions }
MiCoUsageMapModel >> followEntity: aCollection [
	self containerEntities: aCollection.
	self initializeValues.
	browser update
]

{ #category : #accessing }
MiCoUsageMapModel >> getBoxFor: object [
	^(self getContainerBoxFor: object) ifNil: [ self getInnerBoxFor: object ]
]

{ #category : #accessing }
MiCoUsageMapModel >> getContainerBoxFor: object [
	^self containerBoxes
		detect: [ :box | box mooseEntity = object ]
		ifNone: [ nil ]
]

{ #category : #accessing }
MiCoUsageMapModel >> getInnerBoxFor: object [
	^self innerBoxes
		detect: [ :inner | inner mooseEntity = object ]
		ifNone: [ nil ]
]

{ #category : #accessing }
MiCoUsageMapModel >> getInnerBoxNamed: aByteString [
	^ self innerBoxes detect: [ :box | box name = aByteString ]
]

{ #category : #accessing }
MiCoUsageMapModel >> getOrCreateInnerBoxFor: object [

	^ (self getInnerBoxFor: object)
		ifNil: [ innerBoxes add: (self newInnerBoxFor: object) ]
]

{ #category : #initialization }
MiCoUsageMapModel >> initialize [
	super initialize.

	strategies := (MiCoMarkStrategy subclasses collect: #new) sorted: [ :a :b | a order < b order ].
	self containerInnerCounter: self defaultTester
]

{ #category : #initialization }
MiCoUsageMapModel >> initializeContainerBoxes [

	containerBoxes := self containerEntities 
		collect: [ :cont | self newContainerBoxFor: cont ]
		as: OrderedCollection.
]

{ #category : #initialization }
MiCoUsageMapModel >> initializeReferences [
	innerBoxes := OrderedCollection new.

	self containerInnerCounter settings: self settings.
	
	self containerBoxes do: [ :cont | 
		| bag |
		bag := Bag withAll: (self containerInnerCounter allAttributesFor: cont).
		bag doWithOccurrences: [ :innerEntity :count | | in |
			count > 0 ifTrue: [ 
				in := self getOrCreateInnerBoxFor: innerEntity.
				cont addInnerBox: in.
				in containerBox: cont numberOfUses: count.
			].
		].
	]
]

{ #category : #initialization }
MiCoUsageMapModel >> initializeScale [
	| allInnerUses range scaleType cls |

	allInnerUses := self containerBoxes flatCollect: [ :cont | 
		cont innerBoxes collect: [ :inner | inner numberOfUses ] ].
	cls := MiCoUsageMapSettings.
	range := cls innerBoxRange.
	scaleType := cls innerBoxScaleType.
	
	widthScale := (scaleType value: NSScale)
		range: {range first. range last}.
	allInnerUses ifEmpty: [ ^ self ].
	widthScale domain: {allInnerUses min. allInnerUses max}.
]

{ #category : #initialization }
MiCoUsageMapModel >> initializeValues [
	self
		initializeContainerBoxes;
		initializeReferences;
		initializeScale.
]

{ #category : #properties }
MiCoUsageMapModel >> innerBoxHeight [
	^self settings innerBoxHeight
]

{ #category : #properties }
MiCoUsageMapModel >> innerBoxSortBlockCompiled [
	^self settings innerBoxSortBlockCompiled
]

{ #category : #accessing }
MiCoUsageMapModel >> innerBoxes [
	^ innerBoxes
]

{ #category : #accessing }
MiCoUsageMapModel >> miSelectedItem [
	^selectedEntity
]

{ #category : #'instance creation' }
MiCoUsageMapModel >> newContainerBoxFor: anObject [
	"| tags |
	tags := anObject allTagAssociations collect: [ :asso | asso tag ].
	tags := tags
		ifEmpty: [ nil ]
		ifNotEmpty: [ tags anyOne ]."
	^ MiCoContainerBox new
		mooseEntity: anObject;
		yourself
]

{ #category : #'instance creation' }
MiCoUsageMapModel >> newInnerBoxFor: anObject [
	| tags |
	tags := anObject allTagAssociations collect: [ :asso | asso tag ].
	tags := tags
		ifEmpty: [ nil ]
		ifNotEmpty: [ tags anyOne ].
	^ MiCoInnerBox new
		mooseEntity: anObject;
		yourself
]

{ #category : #actions }
MiCoUsageMapModel >> openSettings [ 
	"For now, we handle settings here:
	 - create the window 
	 - subscribe to be informed when any window is closed closed
	 - if this is the setting window that is closed
	    - unsubscribe to ALL announcements
	    - update the visualization"

	| settingBrowser |
	settingBrowser := SettingBrowser new.
	settingBrowser
		changePackageSet:
			(OrderedCollection with:
				(RPackage organizer 
					packageNamed: MiCoUsageMapSettings package name)).
	settingsWindow := settingBrowser open.
	settingsWindow position: (self currentWorld extent - settingsWindow extent) // 2.
	settingBrowser expandAll.

	self currentWorld announcer when: WindowClosed do: [ :annoucement |
		(annoucement window = settingsWindow)
		ifTrue: [
			self currentWorld announcer unsubscribe: self.
			browser update
		]
	]
]

{ #category : #properties }
MiCoUsageMapModel >> outerBoxSortBlockCompiled [
	^self settings outerBoxSortBlockCompiled
]

{ #category : #events }
MiCoUsageMapModel >> quickTaggingOn: entity [ 

	self selectedTag
	ifNil: [ ^ self ]
	ifNotNil: [ :tag | self setTag: tag onInnerBox: entity ]

]

{ #category : #tagging }
MiCoUsageMapModel >> removeTagOn: aMooseEntity [
	aMooseEntity allTags
		detect: [ :aTag | aTag isHidden not ]
		ifOne: [ :aTag | aTag removeReference: aMooseEntity ]
		ifNone: [ "nothing" ]
]

{ #category : #accessing }
MiCoUsageMapModel >> selectedEntity [
	^selectedEntity
]

{ #category : #accessing }
MiCoUsageMapModel >> selectedEntity: aMooseEntity [

	selectedEntity := aMooseEntity
]

{ #category : #tagging }
MiCoUsageMapModel >> setTag: aTag onInnerBox: aBox [

	self selectedTag: aTag.
	self tagEntity: aBox mooseEntity with: aTag
]

{ #category : #accessing }
MiCoUsageMapModel >> settings [
	^MiCoUsageMapSettings
]

{ #category : #tagging }
MiCoUsageMapModel >> strategies [

	^ strategies
]

{ #category : #tagging }
MiCoUsageMapModel >> tagEntitiesSelected [ 
	| tag entity |
	(tag := self selectedTag) ifNil: [ ^self ].
	(entity := self selectedEntity) ifNil: [ ^self ].
	self tagEntity: entity with: tag
	
]

{ #category : #tagging }
MiCoUsageMapModel >> tagEntity: aMooseEntity with: aTag [

	self removeTagOn: aMooseEntity.

	aTag ifNotNil: [ 
		| tagAssociation |
		tagAssociation := aTag addReference: aMooseEntity.
		self currentApplication consumeItem: tagAssociation.

		self selectedTag: aTag ].

	browser updateBoxColor: (self getBoxFor: aMooseEntity) fromTags: aMooseEntity allTags
]

{ #category : #tagging }
MiCoUsageMapModel >> threshold75: aNumber [

	self assert: (aNumber between: 0 and: 100) description: 'use number between 0 and 100'.

	self strategies 
		detect: [ :strat | strat class = MiCo75PercentageMarkStrategy ]
		ifFound: [ :strat | strat threshold: aNumber / 100.0 ]
		ifNone: [  ]
]

{ #category : #accessing }
MiCoUsageMapModel >> widthScale [
	^ widthScale
]
