"
TODO
"
Class {
	#name : #MiCoMarkManager,
	#superclass : #RSInteraction,
	#instVars : [
		'coUsageMap',
		'menuInteraction',
		'strategies',
		'lastTagSelected'
	],
	#category : #'MooseIDE-CoUsageMap-Roassal3'
}

{ #category : #public }
MiCoMarkManager >> automaticColor [
	self changeTagsDuring: [ 
		self coUsageMap miMethods 
			do:[:met | self automaticColorForMethod: met ].
	]
	
]

{ #category : #public }
MiCoMarkManager >> automaticColorForMethod: aMiCoMethod [
	| groupsByTag conflictTag |
	conflictTag := self conflictTag.
	groupsByTag := aMiCoMethod usedAttributes 
		groupedBy: [ :att | att tag ].
	groupsByTag ifEmpty: [
		 "nothing to compare" ^ self ].
	self strategies do: [ :strat | |  |
		strat
			method: aMiCoMethod;
			groupsByTag: groupsByTag.
		strat computeTag ifNotNil: [ :tag | 
			self setTag: tag onAttribute: aMiCoMethod.
			^ self ].
	].
	(groupsByTag size = 1 and: [ groupsByTag keys anyOne isNil])
		ifTrue: [ self setTag: nil onAttribute: aMiCoMethod. ]
		ifFalse: [ self setTag: conflictTag onAttribute: aMiCoMethod].
	
	
	
	
	
]

{ #category : #public }
MiCoMarkManager >> changeTagsDuring: aBlockClosure [
	| lastTag |
	lastTag := self lastTagSelected.
	aBlockClosure value.
	self lastTagSelected: lastTag
]

{ #category : #events }
MiCoMarkManager >> clickOn: aRSMouseClick [ 
	aRSMouseClick commandKeyPressed ifFalse: [ ^ self ].
	lastTagSelected ifNil: [ ^ self ].
	self setTag: lastTagSelected onAttribute: aRSMouseClick shape model.
	aRSMouseClick signalUpdate
]

{ #category : #accessing }
MiCoMarkManager >> coUsageMap [
	^ coUsageMap
]

{ #category : #accessing }
MiCoMarkManager >> coUsageMap: aMiCoCoUsageMapVisualization [
	coUsageMap := aMiCoCoUsageMapVisualization
]

{ #category : #accessing }
MiCoMarkManager >> conflictTag [
	^ self coUsageMap legendTag conflictTag
]

{ #category : #public }
MiCoMarkManager >> contractLabel: aString [
	| contractor |
	contractor := LbCContractor new.
	contractor  addStrategy: (LbCEllipsisStrategy new 
		separator: '...';
		upTo: 50;
		yourself).
	^ contractor reduce: aString
]

{ #category : #'building - menus' }
MiCoMarkManager >> createGlobalMenuOn: menu [
	(menu
		add: 'Automatic color methods'
			target: self
			selector: #automaticColor
			argumentList: #())
		icon: (self iconNamed: #smallPaint).
	menu addMorphBack: (('Threshold for 75% strategy:' asStringMorph)
		width: 200;
		yourself).
	menu addMorphBack: self newSlider.
]

{ #category : #'building - menus' }
MiCoMarkManager >> createMenuOn: menu for: aShape [
	aShape isShape
		ifTrue: [ aShape model createMenuOn: menu markManager: self ]
		ifFalse: [ self createGlobalMenuOn: menu ].
	
]

{ #category : #'building - menus' }
MiCoMarkManager >> fixMenuMouseFocus: evt [
	evt morph currentWorld activeHand newMouseFocus: evt morph owner
]

{ #category : #'building - menus' }
MiCoMarkManager >> iconFormFor: aMiCoTag [
	^ (FormCanvas extent: 15 asPoint)
		fillColor: aMiCoTag color;
		form
]

{ #category : #initialization }
MiCoMarkManager >> initialize [
	super initialize.
	strategies := (MiCoMarkStrategy subclasses collect: #new) sorted: [ :a :b | a order < b order ].
	menuInteraction := RSMenuActivable new
		menuDo: [ :menu :aShape | self createMenuOn: menu for: aShape ];
		yourself.
]

{ #category : #accessing }
MiCoMarkManager >> lastTagSelected [
	^ lastTagSelected
]

{ #category : #accessing }
MiCoMarkManager >> lastTagSelected: aMiCoTag [ 
	lastTagSelected := aMiCoTag
]

{ #category : #'building - menus' }
MiCoMarkManager >> newSlider [
	| canvas morph |
	canvas := RSCanvas new.
	MiCoSlider new
		container: canvas;
		getValueSelector: #threshold;
		setValueSelector: #threshold:;
		model: (self strategies detect: [ :s | s class = MiCo75PercentageMarkStrategy ]);
		build.
	canvas color: Color transparent.
	morph := canvas createMorph.
	morph extent: 200@15.
	canvas 
		when: RSMouseClick send: #fixMenuMouseFocus: to: self;
		when: RSMouseDragEnd send: #fixMenuMouseFocus: to: self;
		when: RSMouseMove send: #fixMenuMouseFocus: to: self.
	^ morph
]

{ #category : #hooks }
MiCoMarkManager >> onShape: aShape [
	aShape addInteraction: menuInteraction.
	aShape when: RSMouseClick send: #clickOn: to: self.
]

{ #category : #public }
MiCoMarkManager >> removeTag: aMiCoTag [
	self changeTagsDuring: [ 
		self coUsageMap miMethods, self coUsageMap miAttributes
			select: [:each | each tag = aMiCoTag ]
			thenDo: [:each | 
				each traceCr.
				self setTag: nil onAttribute: each ].
	]
]

{ #category : #public }
MiCoMarkManager >> setTag: aMicoTag onAttribute: aMicoTaggedObject [
	| color |
	aMicoTaggedObject tag: aMicoTag.
	self lastTagSelected: aMicoTag.
	color := self tagColorFrom: aMicoTag.
	(self coUsageMap canvas deepShapesFromModel: aMicoTaggedObject) 
		do: [ :shape | shape color: color ].
	self coUsageMap canvas signalUpdate.
]

{ #category : #accessing }
MiCoMarkManager >> strategies [
	^ strategies
]

{ #category : #'building - menus' }
MiCoMarkManager >> subMenuTagsFor: aMiCoAttribute subMenu: menu [
	self coUsageMap legendTag tags do: [ :aMiCoTag |
		(menu 
			add: aMiCoTag name
				target: self
				selector: #setTag:onAttribute:
				argumentList: { aMiCoTag. aMiCoAttribute })
			icon: (self iconFormFor: aMiCoTag) ].
	aMiCoAttribute tag ifNotNil: [ 
		menu addLine.
		(menu 
			add: 'Remove tag'
				target: self
				selector: #setTag:onAttribute:
				argumentList: { nil. aMiCoAttribute })
			icon: (self iconNamed: 'remove')
		 ].
	^ menu
]

{ #category : #accessing }
MiCoMarkManager >> tagColorFrom: aMicoTag [
	aMicoTag ifNil: [ ^ Color white ].
	^ aMicoTag color
]
